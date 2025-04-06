import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../annotations/annotation.dart';
import '../listeners/naxalibre_listeners.dart';
import '../models/camera_position.dart';
import '../models/camera_update.dart';
import '../models/latlng.dart';
import '../models/latlng_bounds.dart';
import '../models/light.dart';
import '../models/projected_meters.dart';
import '../models/rendered_coordinates.dart';
import '../models/visible_region.dart';
import '../pigeon_generated.dart';
import '../sources/source.dart';
import '../layers/layer.dart';
import '../style_images/style_image.dart';
import '../typedefs/typedefs.dart';
import '../utils/naxalibre_logger.dart';
import 'naxalibre_controller.dart';

class NaxaLibreControllerImpl extends NaxaLibreController {
  /// The host API for communicating with the native side.
  ///
  final _hostApi = NaxaLibreHostApi();

  /// The listeners for map events.
  ///
  final NaxaLibreListeners _listeners;

  /// Creates a [NaxaLibreControllerImpl] instance.
  ///
  /// The [listeners] parameter is required and provides the listeners for map
  /// events.
  NaxaLibreControllerImpl(this._listeners);

  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    Duration? duration,
  }) async {
    try {
      await _hostApi.animateCamera({
        ...cameraUpdate.toArgs(),
        "duration": duration?.inMilliseconds,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.animateCamera] => $e");
    }
  }

  @override
  Future<void> easeCamera(
    CameraUpdate cameraUpdate, {
    Duration? duration,
  }) async {
    try {
      await _hostApi.easeCamera({
        ...cameraUpdate.toArgs(),
        "duration": duration?.inMilliseconds,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.easeCamera] => $e");
    }
  }

  @override
  Future<void> animateCameraToCurrentLocation({Duration? duration}) async {
    try {
      final location = await lastKnownLocation();

      if (location == null) throw Exception("Location is null");

      final cameraUpdate = CameraUpdateFactory.newLatLng(location);
      await animateCamera(cameraUpdate, duration: duration);
    } catch (e) {
      NaxaLibreLogger.logError(
        "[$runtimeType.animateCameraToCurrentLocation] => $e",
      );
    }
  }

  @override
  Future<bool> isSourceExist(String sourceId) async {
    try {
      final source = await _hostApi.getSource(sourceId);
      return source.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLayerExist(String layerId) async {
    try {
      final layer = await _hostApi.getLayer(layerId);
      return layer.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isStyleImageExist(String imageId) async {
    try {
      final image = await _hostApi.getImage(imageId);
      return image.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> addSource<T extends Source>({required T source}) async {
    try {
      await _hostApi.addSource(source.toArgs());
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addSource] => $e");
    }
  }

  @override
  Future<Map<String, Object?>?> addAnnotation<T extends Annotation>({
    required T annotation,
  }) async {
    try {
      if (annotation is PointAnnotation) {
        final isExist = await isStyleImageExist(annotation.image.imageId);

        if (!isExist) {
          await addStyleImage(image: annotation.image);
        }
      }

      final response = await _hostApi.addAnnotation(annotation.toArgs());

      return {
        ...response,
        "id": num.tryParse(response["id"].toString())?.toInt(),
      };
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addAnnotation] => $e");
      return null;
    }
  }

  @override
  Future<Map<String, Object?>?> updateAnnotation<T extends Annotation>({
    required int id,
    required T annotation,
  }) async {
    try {
      if (annotation is PointAnnotation) {
        final isExist = await isStyleImageExist(annotation.image.imageId);

        if (!isExist) {
          await addStyleImage(image: annotation.image);
        }
      }

      final response = await _hostApi.updateAnnotation(id, annotation.toArgs());

      return {
        ...response,
        "id": num.tryParse(response["id"].toString())?.toInt(),
      };
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.updateAnnotation] => $e");
      return null;
    }
  }

  @override
  Future<bool> removeAnnotation<T extends Annotation>(int annotationId) async {
    try {
      final args = <String, Object?>{
        "id": annotationId,
        "type":
            T == CircleAnnotation
                ? "Circle"
                : T == PointAnnotation
                ? "Symbol"
                : T == PolylineAnnotation
                ? "Polyline"
                : T == PolygonAnnotation
                ? "Polygon"
                : "Unknown",
      };

      await _hostApi.removeAnnotation(args);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeAnnotation] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeAllAnnotations<T extends Annotation>() async {
    try {
      final args = <String, Object?>{
        "type":
            T == CircleAnnotation
                ? "Circle"
                : T == PointAnnotation
                ? "Symbol"
                : T == PolylineAnnotation
                ? "Polyline"
                : T == PolygonAnnotation
                ? "Polygon"
                : "Unknown",
      };

      await _hostApi.removeAllAnnotations(args);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeAllAnnotations] => $e");
      return false;
    }
  }

  @override
  Future<void> addLayer<T extends Layer>({required T layer}) async {
    try {
      await _hostApi.addLayer(layer.toArgs());
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayer] => $e");
    }
  }

  @override
  Future<void> addLayerAbove<T extends Layer>({
    required T layer,
    required String above,
  }) async {
    try {
      await _hostApi.addLayer({...layer.toArgs(), "above": above});
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerAbove] => $e");
    }
  }

  @override
  Future<void> addLayerAt<T extends Layer>({
    required T layer,
    required int index,
  }) async {
    try {
      await _hostApi.addLayer({...layer.toArgs(), "index": index});
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerAt] => $e");
    }
  }

  @override
  Future<void> addLayerBelow<T extends Layer>({
    required T layer,
    required String below,
  }) async {
    try {
      await _hostApi.addLayer({...layer.toArgs(), "below": below});
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerBelow] => $e");
    }
  }

  @override
  Future<bool> removeSource(String sourceId) async {
    try {
      await _hostApi.removeSource(sourceId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeSource] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeLayer(String layerId) async {
    try {
      await _hostApi.removeLayer(layerId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeLayer] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeLayerAt(int index) async {
    try {
      await _hostApi.removeLayerAt(index);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeLayerAt] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeSources(List<String> sourcesId) async {
    try {
      for (final id in sourcesId) {
        if (await isSourceExist(id)) {
          await removeSource(id);
        }
      }
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeSources] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeLayers(List<String> layersId) async {
    try {
      for (final id in layersId) {
        if (await isLayerExist(id)) {
          await removeLayer(id);
        }
      }
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeLayers] => $e");
      return false;
    }
  }

  @override
  Future<bool> addStyleImage<T extends StyleImage>({required T image}) async {
    try {
      final bytes = await image.getByteArray();
      await _hostApi.addImage(image.imageId, bytes!);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addStyleImage] => $e");
      return false;
    }
  }

  @override
  Future<bool> removeStyleImage(String imageId) async {
    try {
      await _hostApi.removeImage(imageId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeStyleImage] => $e");
      return false;
    }
  }

  @override
  Future<LatLng?> lastKnownLocation() async {
    try {
      final location = await _hostApi.lastKnownLocation();

      if (location.length >= 2) {
        return LatLng(
          location[0],
          location[1],
          altitude: location.length > 2 ? location[2] : null,
        );
      }

      return null;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.lastKnownLocation] => $e");
      return null;
    }
  }

  @override
  Future<Uint8List?> snapshot() async {
    try {
      final image = await _hostApi.snapshot();
      return image;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.snapshot] => $e");
      return null;
    }
  }

  @override
  Future<void> triggerRepaint() async {
    try {
      await _hostApi.triggerRepaint();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.triggerRepaint] => $e");
    }
  }

  @override
  Future<void> resetNorth() async {
    try {
      await _hostApi.resetNorth();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.resetNorth] => $e");
    }
  }

  @override
  Future<LatLng?> fromScreenLocation(Point<double> point) async {
    try {
      final latLngArgs = await _hostApi.fromScreenLocation([point.x, point.y]);
      return LatLng.fromArgs(latLngArgs);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.fromScreenLocation] => $e");
      return null;
    }
  }

  @override
  Future<CameraPosition?> getCameraForLatLngBounds(LatLngBounds bounds) async {
    try {
      final positionArgs = await _hostApi.getCameraForLatLngBounds(
        bounds.toArgs(),
      );
      return CameraPosition.fromArgs(positionArgs);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getCameraForLatLngBounds] => $e");
      return null;
    }
  }

  @override
  Future<CameraPosition?> getCameraPosition() async {
    try {
      final positionArgs = await _hostApi.getCameraPosition();
      return CameraPosition.fromArgs(positionArgs);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getCameraPosition] => $e");
      return null;
    }
  }

  @override
  Future<double?> getHeight() async {
    try {
      final height = await _hostApi.getHeight();
      return height;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getHeight] => $e");
      return null;
    }
  }

  @override
  Future<Uint8List?> getImage(String id) async {
    try {
      final image = await _hostApi.getImage(id);
      return image;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getImage] => $e");
      return null;
    }
  }

  @override
  Future<Map<String, Object?>?> getAnnotation(int id) async {
    try {
      final annotation = await _hostApi.getAnnotation(id);
      return annotation;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getAnnotation] => $e");
      return null;
    }
  }

  @override
  Future<String?> getJson() async {
    try {
      final json = await _hostApi.getJson();
      return json;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getJson] => $e");
      return null;
    }
  }

  @override
  Future<LatLng?> getLatLngForProjectedMeters(ProjectedMeters meters) async {
    try {
      final args = await _hostApi.getLatLngForProjectedMeters(
        meters.northing,
        meters.easting,
      );
      return LatLng.fromArgs(args);
    } catch (e) {
      NaxaLibreLogger.logError(
        "[$runtimeType.getLatLngForProjectedMeters] => $e",
      );
      return null;
    }
  }

  @override
  Future<Map<String, Object?>?> getLayer(String id) async {
    try {
      final layer = await _hostApi.getLayer(id);
      return layer.map((k, v) => MapEntry(k.toString(), v));
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getLayer] => $e");
      return null;
    }
  }

  @override
  Future<List<Map<String, Object?>>?> getLayers() async {
    try {
      final layers = await _hostApi.getLayers();
      return layers
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getLayers] => $e");
      return null;
    }
  }

  @override
  Future<Light?> getLight() async {
    try {
      final lightArgs = await _hostApi.getLight();
      return Light.fromArgs(lightArgs);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getLight] => $e");
      return null;
    }
  }

  @override
  Future<double?> getMinimumPitch() async {
    try {
      final minPitch = await _hostApi.getMinimumPitch();
      return minPitch;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getMinimumPitch] => $e");
      return null;
    }
  }

  @override
  Future<double?> getMaximumPitch() async {
    try {
      final maxPitch = await _hostApi.getMaximumPitch();
      return maxPitch;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getMaximumPitch] => $e");
      return null;
    }
  }

  @override
  Future<double?> getMinimumZoom() async {
    try {
      final minZoom = await _hostApi.getMinimumZoom();
      return minZoom;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getMinimumZoom] => $e");
      return null;
    }
  }

  @override
  Future<double?> getMaximumZoom() async {
    try {
      final maxZoom = await _hostApi.getMaximumZoom();
      return maxZoom;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getMaximumZoom] => $e");
      return null;
    }
  }

  @override
  Future<double?> getPixelRatio() async {
    try {
      final pixelRatio = await _hostApi.getPixelRatio();
      return pixelRatio;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getPixelRatio] => $e");
      return null;
    }
  }

  @override
  Future<ProjectedMeters?> getProjectedMetersForLatLng(LatLng latLng) async {
    try {
      final res = await _hostApi.getProjectedMetersForLatLng(
        latLng.latLngList(),
      );
      return ProjectedMeters(res.first, res.last);
    } catch (e) {
      NaxaLibreLogger.logError(
        "[$runtimeType.getProjectedMetersForLatLng] => $e",
      );
      return null;
    }
  }

  @override
  Future<Map<String, Object?>?> getSource(String id) async {
    try {
      final source = await _hostApi.getSource(id);
      return source.map((k, v) => MapEntry(k.toString(), v));
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getSource] => $e");
      return null;
    }
  }

  @override
  Future<List<Map<String, Object?>>?> getSources() async {
    try {
      final sources = await _hostApi.getSources();
      return sources
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getSources] => $e");
      return null;
    }
  }

  @override
  Future<String?> getUri() async {
    try {
      final uri = await _hostApi.getUri();
      return uri;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getUri] => $e");
      return null;
    }
  }

  @override
  Future<VisibleRegion?> getVisibleRegion(bool ignorePadding) async {
    try {
      final args = await _hostApi.getVisibleRegion(ignorePadding);
      return VisibleRegion.fromArgs(args);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getVisibleRegion] => $e");
      return null;
    }
  }

  @override
  Future<double?> getWidth() async {
    try {
      final width = await _hostApi.getWidth();
      return width;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getWidth] => $e");
      return null;
    }
  }

  @override
  Future<double?> getZoom() async {
    try {
      final zoom = await _hostApi.getZoom();
      return zoom;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.getZoom] => $e");
      return null;
    }
  }

  @override
  Future<bool?> isAttributionEnabled() async {
    try {
      final enabled = await _hostApi.isAttributionEnabled();
      return enabled;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isAttributionEnabled] => $e");
      return null;
    }
  }

  @override
  Future<bool?> isCompassEnabled() async {
    try {
      final enabled = await _hostApi.isCompassEnabled();
      return enabled;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isCompassEnabled] => $e");
      return null;
    }
  }

  @override
  Future<bool?> isCompassFadeWhenFacingNorth() async {
    try {
      final isCompassFadeWhenFacingNorth =
          await _hostApi.isCompassFadeWhenFacingNorth();
      return isCompassFadeWhenFacingNorth;
    } catch (e) {
      NaxaLibreLogger.logError(
        "[$runtimeType.isCompassFadeWhenFacingNorth] => $e",
      );
      return null;
    }
  }

  @override
  Future<bool?> isDestroyed() async {
    try {
      final destroyed = await _hostApi.isDestroyed();
      return destroyed;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isDestroyed] => $e");
      return null;
    }
  }

  @override
  Future<bool?> isFullyLoaded() async {
    try {
      final loaded = await _hostApi.isFullyLoaded();
      return loaded;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isFullyLoaded] => $e");
      return null;
    }
  }

  @override
  Future<bool?> isLogoEnabled() async {
    try {
      final enabled = await _hostApi.isLogoEnabled();
      return enabled;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isLogoEnabled] => $e");
      return null;
    }
  }

  @override
  Future<List<Map<Object?, Object?>>> queryRenderedFeatures(
    RenderedCoordinates coordinates, {
    List<String> layerIds = const [],
    dynamic filter,
  }) async {
    try {
      RenderedCoordinates cords = coordinates;

      if (coordinates.type == "latLng") {
        final point = await toScreenLocation(
          LatLng(coordinates.coordinates.first, coordinates.coordinates.last),
        );

        if (point == null) return List.empty();
        cords = RenderedCoordinates.fromPoint(point);
      }

      final args = <String, dynamic>{
        ...cords.toArgs(),
        "layerIds": layerIds,
        "filter": filter != null ? jsonEncode(filter) : null,
      };

      final features = await _hostApi.queryRenderedFeatures(args);
      return features;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.queryRenderedFeatures] => $e");
      return List.empty();
    }
  }

  @override
  Future<void> setAttributionMargins(EdgeInsets margin) async {
    try {
      await _hostApi.setAttributionMargins(
        margin.left,
        margin.top,
        margin.right,
        margin.bottom,
      );
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setAttributionMargins] => $e");
    }
  }

  @override
  Future<void> setAttributionTintColor(int color) async {
    try {
      await _hostApi.setAttributionTintColor(color);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setAttributionTintColor] => $e");
    }
  }

  @override
  Future<void> setCompassFadeFacingNorth(bool compassFadeFacingNorth) async {
    try {
      await _hostApi.setCompassFadeFacingNorth(compassFadeFacingNorth);
    } catch (e) {
      NaxaLibreLogger.logError(
        "[$runtimeType.setCompassFadeFacingNorth] => $e",
      );
    }
  }

  @override
  Future<void> setCompassImage(Uint8List bytes) async {
    try {
      await _hostApi.setCompassImage(bytes);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setCompassImage] => $e");
    }
  }

  @override
  Future<void> setCompassMargins(EdgeInsets margin) async {
    try {
      await _hostApi.setCompassMargins(
        margin.left,
        margin.top,
        margin.right,
        margin.bottom,
      );
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setCompassMargins] => $e");
    }
  }

  @override
  Future<void> setLogoMargins(EdgeInsets margin) async {
    try {
      await _hostApi.setLogoMargins(
        margin.left,
        margin.top,
        margin.right,
        margin.bottom,
      );
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setLogoMargins] => $e");
    }
  }

  @override
  Future<void> setMaximumFps(int fps) async {
    try {
      await _hostApi.setMaximumFps(fps);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setMaximumFps] => $e");
    }
  }

  @override
  Future<void> setStyle(String style) async {
    try {
      await _hostApi.setStyle(style);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setStyle] => $e");
    }
  }

  @override
  Future<void> setSwapBehaviorFlush(bool flush) async {
    try {
      await _hostApi.setSwapBehaviorFlush(flush);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.setSwapBehaviorFlush] => $e");
    }
  }

  @override
  Future<Point<double>?> toScreenLocation(LatLng latLng) async {
    try {
      final point = await _hostApi.toScreenLocation(latLng.latLngList());

      return Point(point.first, point.last);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.toScreenLocation] => $e");
      return null;
    }
  }

  @override
  Future<void> zoomBy(int by) async {
    try {
      await _hostApi.zoomBy(by);
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.zoomBy] => $e");
    }
  }

  @override
  Future<void> zoomIn() async {
    try {
      await _hostApi.zoomIn();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.zoomIn] => $e");
    }
  }

  @override
  Future<void> zoomOut() async {
    try {
      await _hostApi.zoomOut();
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.zoomOut] => $e");
    }
  }

  @override
  void addOnMapRenderedListener(OnMapRendered listener) =>
      _listeners.add(NaxaLibreListenerKey.onMapRendered, listener);

  @override
  void addOnMapLoadedListener(OnMapLoaded listener) =>
      _listeners.add(NaxaLibreListenerKey.onMapLoaded, listener);

  @override
  void addOnStyleLoadedListener(OnStyleLoaded listener) =>
      _listeners.add(NaxaLibreListenerKey.onStyleLoaded, listener);

  @override
  void addOnMapClickListener(OnMapClick listener) =>
      _listeners.add(NaxaLibreListenerKey.onMapClick, listener);

  @override
  void addOnMapLongClickListener(OnMapLongClick listener) =>
      _listeners.add(NaxaLibreListenerKey.onMapLongClick, listener);

  @override
  void addOnAnnotationClickListener(OnAnnotationClick listener) =>
      _listeners.add(NaxaLibreListenerKey.onAnnotationClick, listener);

  @override
  void addOnAnnotationLongClickListener(OnAnnotationLongClick listener) =>
      _listeners.add(NaxaLibreListenerKey.onAnnotationLongClick, listener);

  @override
  void addOnAnnotationDragListener(OnAnnotationDrag listener) =>
      _listeners.add(NaxaLibreListenerKey.onAnnotationDrag, listener);

  @override
  void addOnCameraIdleListener(OnCameraIdle listener) =>
      _listeners.add(NaxaLibreListenerKey.onCameraIdle, listener);

  @override
  void addOnCameraMoveListener(OnCameraMove listener) =>
      _listeners.add(NaxaLibreListenerKey.onCameraMove, listener);

  @override
  void addOnRotateListener(OnRotate listener) =>
      _listeners.add(NaxaLibreListenerKey.onRotate, listener);

  @override
  void addOnFlingListener(OnFling listener) =>
      _listeners.add(NaxaLibreListenerKey.onFling, listener);

  @override
  void addOnFpsChangedListener(OnFpsChanged listener) =>
      _listeners.add(NaxaLibreListenerKey.onFpsChanged, listener);

  @override
  void removeOnMapRenderedListener(OnMapRendered listener) =>
      _listeners.remove(NaxaLibreListenerKey.onMapRendered, listener);

  @override
  void removeOnMapLoadedListener(OnMapLoaded listener) =>
      _listeners.remove(NaxaLibreListenerKey.onMapLoaded, listener);

  @override
  void removeOnStyleLoadedListener(OnStyleLoaded listener) =>
      _listeners.remove(NaxaLibreListenerKey.onStyleLoaded, listener);

  @override
  void removeOnMapClickListener(OnMapClick listener) =>
      _listeners.remove(NaxaLibreListenerKey.onMapClick, listener);

  @override
  void removeOnMapLongClickListener(OnMapLongClick listener) =>
      _listeners.remove(NaxaLibreListenerKey.onMapLongClick, listener);

  @override
  void removeOnAnnotationClickListener(OnAnnotationClick listener) =>
      _listeners.remove(NaxaLibreListenerKey.onAnnotationClick, listener);

  @override
  void removeOnAnnotationLongClickListener(OnAnnotationLongClick listener) =>
      _listeners.remove(NaxaLibreListenerKey.onAnnotationLongClick, listener);

  @override
  void removeOnAnnotationDragListener(OnAnnotationDrag listener) =>
      _listeners.remove(NaxaLibreListenerKey.onAnnotationDrag, listener);

  @override
  void removeOnCameraIdleListener(OnCameraIdle listener) =>
      _listeners.remove(NaxaLibreListenerKey.onCameraIdle, listener);

  @override
  void removeOnCameraMoveListener(OnCameraMove listener) =>
      _listeners.remove(NaxaLibreListenerKey.onCameraMove, listener);

  @override
  void removeOnRotateListener(OnRotate listener) =>
      _listeners.remove(NaxaLibreListenerKey.onRotate, listener);

  @override
  void removeOnFlingListener(OnFling listener) =>
      _listeners.remove(NaxaLibreListenerKey.onFling, listener);

  @override
  void removeOnFpsChangedListener(OnFpsChanged listener) =>
      _listeners.remove(NaxaLibreListenerKey.onFpsChanged, listener);

  @override
  void clearOnMapRenderedListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onMapRendered);

  @override
  void clearOnMapLoadedListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onMapLoaded);

  @override
  void clearOnStyleLoadedListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onStyleLoaded);

  @override
  void clearOnMapClickListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onMapClick);

  @override
  void clearOnMapLongClickListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onMapLongClick);

  @override
  void clearOnAnnotationClickListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onAnnotationClick);

  @override
  void clearOnAnnotationLongClickListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onAnnotationLongClick);

  @override
  void clearOnAnnotationDragListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onAnnotationDrag);

  @override
  void clearOnCameraIdleListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onCameraIdle);

  @override
  void clearOnCameraMoveListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onCameraMove);

  @override
  void clearOnRotateListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onRotate);

  @override
  void clearOnFlingListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onFling);

  @override
  void clearOnFpsChangedListeners() =>
      _listeners.clear(NaxaLibreListenerKey.onFpsChanged);

  @override
  void dispose() {
    _listeners.dispose();
  }
}
