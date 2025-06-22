import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/geojson.dart';
import '../offline/naxalibre_offline_manager.dart';
import '../models/camera_position.dart';
import '../models/camera_update.dart';
import '../models/latlng.dart';
import '../models/latlng_bounds.dart';
import '../models/light.dart';
import '../models/projected_meters.dart';
import '../models/rendered_coordinates.dart';
import '../models/visible_region.dart';
import '../sources/source.dart';
import '../layers/layer.dart';
import '../style_images/style_image.dart';
import '../typedefs/typedefs.dart';
import '../annotations/annotation.dart';

/// An abstract class representing a map interface with methods for interacting
/// with map features, camera positions, styles, and settings.

abstract class NaxaLibreController {
  /// Initialize and provide offline manager instance.
  ///
  NaxaLibreOfflineManager offlineManager = NaxaLibreOfflineManager();

  /// Method to animate camera
  /// [cameraUpdate] New camera update to move camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  Future<void> animateCamera(CameraUpdate cameraUpdate, {Duration? duration});

  /// Method to ease camera
  /// [cameraUpdate] New camera update to animate camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  Future<void> easeCamera(CameraUpdate cameraUpdate, {Duration? duration});

  /// Method to animate camera to users current location provided by maplibre
  /// location engine / location manager
  Future<void> animateCameraToCurrentLocation({Duration duration});

  /// Check if a source with the given ID already exists in the map.
  ///
  /// [sourceId]: The ID of the source to check.
  ///
  /// Returns `true` if a source with the specified ID exists; `false` otherwise.
  Future<bool> isSourceExist(String sourceId);

  /// Check if a layer with the given ID already exists in the map.
  ///
  /// [layerId]: The ID of the layer to check.
  ///
  /// Returns `true` if a layer with the specified ID exists; `false` otherwise.
  Future<bool> isLayerExist(String layerId);

  /// Check if a style image with the given ID already exists in the map.
  ///
  /// [imageId]: The ID of the style image to check.
  ///
  /// Returns `true` if a style image with the specified ID exists; `false` otherwise.
  Future<bool> isStyleImageExist(String imageId);

  /// Adds a new source to the map style.
  ///
  /// [source]: The source object to add.
  ///
  /// This method allows you to add various types of sources to the map, such as:
  /// *   [GeoJsonSource]
  /// *   [VectorSource]
  /// *   [RasterSource]
  /// *   [RasterDemSource]
  /// *   [ImageSource]
  /// *   [VideoSource]
  ///
  /// Make sure the source ID is unique.
  ///
  /// Note: Before adding a source, consider checking if a source with the same ID already exists using [isSourceExist].
  ///
  /// This generic method uses a generic type `T` which should be a class that extends the `Source` class.
  /// You should provide a concrete `Source` class instance as argument.
  ///
  /// Throws an error if the input source ID is not unique.
  ///
  /// Throws an exception if the sourceId is duplicate.
  Future<void> addSource<T extends Source>({required T source});

  /// Adds a new source along with its associated layers and optional style images to the map style.
  ///
  /// [source]: The source object to add. Must extend the [Source] class and have a unique ID.
  /// [layers]: A list of [Layer] objects to add on top of the source.
  /// [styleImages]: A list of [StyleImage]s that are needed by the layers.
  /// [replace]: If `true`, any existing source with the same ID will be replaced.
  ///            If `false`, and a source with the same ID exists, the method will throw an error.
  ///
  /// This method is a convenient way to add a source, its layers, and related style images in one step.
  /// It is especially useful when you are initializing complex sources like vector tiles or image overlays
  /// that require multiple components to render correctly.
  ///
  /// Throws:
  /// * [Exception] if the source ID already exists and [replace] is set to `false`.
  /// * [Exception] if any of the layers are invalid or improperly configured.
  Future<void> addSourceWithLayers<T extends Source>({
    required T source,
    required List<Layer> layers,
    List<StyleImage> styleImages = const [],
    bool replace = true,
  });

  /// Sets the data for a [GeoJsonSource] from a [GeoJson] object.
  ///
  /// [sourceId]: The unique identifier of the GeoJSON source you want to update.
  /// [geoJson]: The GeoJSON data to be applied to the source.
  ///
  /// This method allows you to dynamically update a GeoJSON source with fresh data.
  ///
  /// Throws:
  /// * [Exception] if the specified source ID does not exist or is not a [GeoJsonSource].
  Future<void> setGeoJson({required String sourceId, required GeoJson geoJson});

  /// Sets the data for a [GeoJsonSource] from a remote GeoJSON file URL.
  ///
  /// [sourceId]: The unique identifier of the GeoJSON source to update.
  /// [geoJsonUrl]: The URL pointing to a valid GeoJSON file.
  ///
  /// This is useful for loading data from an external resource rather than embedding it directly.
  ///
  /// Throws:
  /// * [Exception] if the source ID does not exist or the source is not compatible.
  /// * [FormatException] if the URL is not valid or the remote data is not proper GeoJSON.
  Future<void> setGeoJsonUrl({
    required String sourceId,
    required String geoJsonUrl,
  });

  /// Adds an annotation to the map.
  ///
  /// [annotation]: The annotation object to add.
  ///
  /// This method allows you to add various types of annotations to the map, such as:
  /// *   [PointAnnotation]
  /// *   [CircleAnnotation]
  /// *   [PolylineAnnotation]
  /// *   [PolygonAnnotation]
  ///
  /// Make sure the annotation properties are valid.
  Future<Map<String, Object?>?> addAnnotation<T extends Annotation>({
    required T annotation,
  });

  /// Update an annotation to the map.
  ///
  /// [id]: The ID of the annotation to update.
  /// [annotation]: The annotation object to update.
  ///
  /// This method allows you to update various types of annotations to the map, such as:
  /// *   [PointAnnotation]
  /// *   [CircleAnnotation]
  /// *   [PolylineAnnotation]
  /// *   [PolygonAnnotation]
  ///
  /// Make sure the annotation properties are valid.
  Future<Map<String, Object?>?> updateAnnotation<T extends Annotation>({
    required int id,
    required T annotation,
  });

  /// Removes a previously added annotations from the map.
  ///
  /// [annotationId]: The ID of the annotation to be removed.
  Future<bool> removeAnnotation<T extends Annotation>(int annotationId);

  /// Removes a previously added annotations from the map.
  ///
  /// [annotationId]: The ID of the annotation to be removed.
  Future<bool> removeAllAnnotations<T extends Annotation>();

  /// Adds a style layer in the map.
  ///
  /// This method allows you to insert a new style layer
  ///
  /// [layer]: The style layer to be added.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayer<T extends Layer>({required T layer});

  /// Adds a style layer below another layer in the map.
  ///
  /// This method allows you to insert a new style layer underneath an existing one,
  /// allowing for layering effects and control over the drawing order.
  ///
  /// [layer]: The style layer to be added.
  /// [below]: The ID of the existing layer below which the new layer will be placed.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayerBelow<T extends Layer>({
    required T layer,
    required String below,
  });

  /// Adds a style layer above another layer in the map.
  ///
  /// This method allows you to insert a new style layer above an existing one,
  /// allowing for layering effects and control over the drawing order.
  ///
  /// [layer]: The style layer to be added.
  /// [above]: The ID of the existing layer above which the new layer will be placed.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayerAbove<T extends Layer>({
    required T layer,
    required String above,
  });

  /// Adds a style layer at a specific index within the map's layer stack.
  ///
  /// This method allows you to insert a new style layer at a particular index,
  /// giving you precise control over the drawing order and stacking of layers.
  ///
  /// [layer]: The style layer to be added.
  /// [index]: The index at which to insert the new layer.
  ///          The index is zero-based, where 0 represents the bottommost layer.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  /// This method allows you to insert a new style layer at a particular index,
  /// giving you precise control over the drawing order and stacking of layers.
  Future<void> addLayerAt<T extends Layer>({
    required T layer,
    required int index,
  });

  /// Update a style layer in the map.
  ///
  /// This method allows you to update a already added style layer
  ///
  /// [layer]: The style layer to be updated.
  ///
  Future<void> updateLayer<T extends Layer>({required T layer});

  /// Apply filter to a style layer in the map.
  ///
  /// This method allows you to apply filter on given layer
  ///
  /// [layerId]: The style layer id to apply filter
  /// [filter]: The filter to apply e.g. [">=", ["get", "pop_max"], 75000]
  ///
  Future<void> applyFilter({required String layerId, required dynamic filter});

  /// Remove applied filter from a style layer in the map.
  ///
  /// This method allows you to remove applied filter from a style layer
  ///
  /// [layerId]: The style layer id to apply filter
  ///
  Future<void> removeFilter({required String layerId});

  /// Removes a previously added source from the map style.
  ///
  /// [sourceId]: The ID of the source to be removed.
  Future<bool> removeSource(String sourceId);

  /// Removes a previously added style layer from the map style.
  ///
  /// [layerId]: The ID of the layer to be removed.
  Future<bool> removeLayer(String layerId);

  /// Removes a previously added style layer from the map style.
  /// at given index
  /// [index] index of the layer to be removed
  Future<bool> removeLayerAt(int index);

  /// Removes multiple sources from the map style.
  ///
  /// [sourcesId]: A list of source IDs to be removed.
  Future<bool> removeSources(List<String> sourcesId);

  /// Removes multiple style layers from the map style.
  ///
  /// [layersId]: A list of layer IDs to be removed.
  Future<bool> removeLayers(List<String> layersId);

  /// Adds a style image to the map style.
  ///
  /// The image can be a network image or a local image.
  ///
  /// [image]: The style image to be added.
  ///  i.e., - NetworkStyleImage or LocalStyleImage
  Future<bool> addStyleImage<T extends StyleImage>({required T image});

  /// Removes a previously added style image from the map.
  ///
  /// [imageId]: The ID of the style image to be removed.
  Future<bool> removeStyleImage(String imageId);

  /// Method to get the user's last known location
  ///
  Future<LatLng?> lastKnownLocation();

  /// Method to get snapshot of the map
  ///
  Future<Uint8List?> snapshot();

  /// Method to trigger repaint
  ///
  Future<void> triggerRepaint();

  /// Method to reset north
  ///
  Future<void> resetNorth();

  /// Converts a screen location (in pixels) to a geographic coordinate (latitude and longitude).
  ///
  /// - [point]: The screen location as a [Point<double>].
  /// - Returns: A [Future] that resolves to a [LatLng] object representing the geographic
  ///   coordinate, or `null` if the conversion fails.
  Future<LatLng?> fromScreenLocation(Point<double> point);

  /// Converts a screen locations (in pixels) to a geographic coordinates (latitude and longitude).
  ///
  /// - [points]: The list of screen location
  /// - Returns: A [Future] that resolves to a list of [LatLng] object representing the geographic
  ///   coordinates, or `null` if the conversion fails.
  Future<List<LatLng>?> fromScreenLocations(List<Point<double>> points);

  /// Converts a geographic coordinate (latitude and longitude) to a screen location (in pixels).
  ///
  /// - [latLng]: The geographic coordinate as a [LatLng].
  /// - Returns: A [Future] that resolves to a [Point<double>] representing the screen location,
  ///   or `null` if the conversion fails.
  Future<Point<double>?> toScreenLocation(LatLng latLng);

  /// Converts a geographic coordinates (latitude and longitude) to a screen locations (in pixels).
  ///
  /// - [list]: The list of  geographic coordinates.
  /// - Returns: A [Future] that resolves to a list of screen point representing the screen locations,
  ///   or `null` if the conversion fails.
  Future<List<Point<double>>?> toScreenLocations(List<LatLng> list);

  /// Converts projected meters (northing and easting) to a geographic coordinate (latitude and longitude).
  /// - [meters] ProjectedMeters containing northing and easting value
  /// - Returns: A [Future] that resolves to a [LatLng] object representing the geographic
  ///   coordinate, or `null` if the conversion fails.
  Future<LatLng?> getLatLngForProjectedMeters(ProjectedMeters meters);

  /// Retrieves the visible region of the map.
  ///
  /// - [ignorePadding]: If `true`, ignores any padding applied to the map.
  /// - Returns: A [Future] that resolves to a [VisibleRegion] object representing the visible
  ///   region, or `null` if the operation fails.
  Future<VisibleRegion?> getVisibleRegion(bool ignorePadding);

  /// Converts a geographic coordinate (latitude and longitude) to projected meters.
  ///
  /// - [latLng]: The geographic coordinate as a [LatLng].
  /// - Returns: A [Future] that resolves to a [ProjectedMeters]
  ///   or `null` if the conversion fails.
  Future<ProjectedMeters?> getProjectedMetersForLatLng(LatLng latLng);

  /// Retrieves the current camera position of the map.
  ///
  /// - Returns: A [Future] that resolves to a [CameraPosition] object representing the camera
  ///   position, or `null` if the operation fails.
  Future<CameraPosition?> getCameraPosition();

  /// Retrieves the current zoom level of the map.
  ///
  /// - Returns: A [Future] that resolves to the zoom level as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getZoom();

  /// Retrieves the height of the map in pixels.
  ///
  /// - Returns: A [Future] that resolves to the height as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getHeight();

  /// Retrieves the width of the map in pixels.
  ///
  /// - Returns: A [Future] that resolves to the width as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getWidth();

  /// Retrieves the minimum zoom level allowed for the map.
  ///
  /// - Returns: A [Future] that resolves to the minimum zoom level as a [double], or `null` if
  ///   the operation fails.
  Future<double?> getMinimumZoom();

  /// Retrieves the maximum zoom level allowed for the map.
  ///
  /// - Returns: A [Future] that resolves to the maximum zoom level as a [double], or `null` if
  ///   the operation fails.
  Future<double?> getMaximumZoom();

  /// Retrieves the minimum pitch allowed for the map.
  ///
  /// - Returns: A [Future] that resolves to the minimum pitch as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getMinimumPitch();

  /// Retrieves the maximum pitch allowed for the map.
  ///
  /// - Returns: A [Future] that resolves to the maximum pitch as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getMaximumPitch();

  /// Retrieves the pixel ratio of the map.
  ///
  /// - Returns: A [Future] that resolves to the pixel ratio as a [double], or `null` if the
  ///   operation fails.
  Future<double?> getPixelRatio();

  /// Checks if the map is destroyed.
  ///
  /// - Returns: A [Future] that resolves to `true` if the map is destroyed, `false` otherwise,
  ///   or `null` if the operation fails.
  Future<bool?> isDestroyed();

  /// Sets the maximum frames per second (FPS) for the map.
  ///
  /// - [fps]: The maximum FPS to set.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setMaximumFps(int fps);

  /// Sets the style of the map.
  ///
  /// - [style]: The style to set as a [String].
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setStyle(String style);

  /// Sets the swap behavior for the map.
  ///
  /// - [flush]: If `true`, flushes the swap behavior.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setSwapBehaviorFlush(bool flush);

  /// Method to enabled or disabled all map gestures
  ///
  /// - [enabled]: If `true`, all gestures will be enabled otherwise they will be disabled.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setAllGesturesEnabled(bool enabled);

  /// Zooms the map by a specified amount.
  ///
  /// - [by]: The amount to zoom by.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> zoomBy(double by);

  /// Zooms the map in.
  ///
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> zoomIn();

  /// Zooms the map out.
  ///
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> zoomOut();

  /// Retrieves the camera position for a given latitude-longitude bounds.
  ///
  /// - [bounds]: The bounds as a [LatLngBounds].
  /// - Returns: A [Future] that resolves to a [CameraPosition] object representing the camera
  ///   position, or `null` if the operation fails.
  Future<CameraPosition?> getCameraForLatLngBounds(LatLngBounds bounds);

  /// Queries rendered features at a specific point in a MapLibre map.
  ///
  /// - [coordinates]: The point to query.
  /// - [layerIds]: Optional list of layer IDs to filter the query.
  /// - [filter]: A filter expression to refine the query results.
  /// e.g. `filter: ["==", ["get", "name"], "New York"]`
  Future<List<Map<Object?, Object?>>> queryRenderedFeatures(
    RenderedCoordinates coordinates, {
    List<String> layerIds = const [],
    dynamic filter,
  });

  /// Sets the margins for the map logo.
  ///
  /// - [margin]: The left, top, right, and bottom margin.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setLogoMargins(EdgeInsets margin);

  /// Checks if the map logo is enabled.
  ///
  /// - Returns: A [Future] that resolves to `true` if the logo is enabled, `false` otherwise,
  ///   or `null` if the operation fails.
  Future<bool?> isLogoEnabled();

  /// Sets the margins for the compass.
  ///
  /// - [margin]: The left, top, right, and bottom margin.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setCompassMargins(EdgeInsets margin);

  /// Sets the compass image using a byte array.
  ///
  /// - [bytes]: The compass image as a [Uint8List].
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setCompassImage(Uint8List bytes);

  /// Sets whether the compass fades when facing north.
  ///
  /// - [compassFadeFacingNorth]: If `true`, the compass fades when facing north.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setCompassFadeFacingNorth(bool compassFadeFacingNorth);

  /// Checks if the compass is enabled.
  ///
  /// - Returns: A [Future] that resolves to `true` if the compass is enabled, `false` otherwise,
  ///   or `null` if the operation fails.
  Future<bool?> isCompassEnabled();

  /// Checks if the compass fades when facing north.
  ///
  /// - Returns: A [Future] that resolves to `true` if the compass fades when facing north,
  ///   `false` otherwise, or `null` if the operation fails.
  Future<bool?> isCompassFadeWhenFacingNorth();

  /// Sets the margins for the attribution.
  ///
  /// - [margin]: The left, top, right, and bottom margin.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setAttributionMargins(EdgeInsets margin);

  /// Checks if the attribution is enabled.
  ///
  /// - Returns: A [Future] that resolves to `true` if the attribution is enabled, `false` otherwise,
  ///   or `null` if the operation fails.
  Future<bool?> isAttributionEnabled();

  /// Sets the tint color for the attribution.
  ///
  /// - [color]: The tint color as an integer.
  /// - Returns: A [Future] that completes when the operation is done.
  Future<void> setAttributionTintColor(int color);

  /// Retrieves the URI of the current map style.
  ///
  /// - Returns: A [Future] that resolves to the style URI as a [String], or `null` if the
  ///   operation fails.
  Future<String?> getUri();

  /// Retrieves the JSON representation of the current map style.
  ///
  /// - Returns: A [Future] that resolves to the style JSON as a [String], or `null` if the
  ///   operation fails.
  Future<String?> getJson();

  /// Retrieves the light settings of the map.
  ///
  /// - Returns: A [Future] that resolves to a [Light] object representing the light settings,
  ///   or `null` if the operation fails.
  Future<Light?> getLight();

  /// Checks if the map style is fully loaded.
  ///
  /// - Returns: A [Future] that resolves to `true` if the style is fully loaded, `false` otherwise,
  ///   or `null` if the operation fails.
  Future<bool?> isFullyLoaded();

  /// Retrieves a layer by its ID.
  ///
  /// - [id]: The ID of the layer.
  /// - Returns: A [Future] that resolves to a map representing the layer, or `null` if the
  ///   layer is not found.
  Future<Map<String, Object?>?> getLayer(String id);

  /// Retrieves all layers matching the given ID.
  ///
  /// - Returns: A [Future] that resolves to a list of maps representing the layers, or `null` if
  ///   no layers are found.
  Future<List<Map<String, Object?>>?> getLayers();

  /// Retrieves a source by its ID.
  ///
  /// - [id]: The ID of the source.
  /// - Returns: A [Future] that resolves to a map representing the source, or `null` if the
  ///   source is not found.
  Future<Map<String, Object?>?> getSource(String id);

  /// Retrieves all sources.
  ///
  /// - Returns: A [Future] that resolves to a list of maps representing the sources, or `null` if
  ///   no sources are found.
  Future<List<Map<String, Object?>>?> getSources();

  /// Retrieves an image by its ID.
  ///
  /// - [id]: The ID of the image.
  /// - Returns: A [Future] that resolves to the image as a [Uint8List], or `null` if the
  ///   image is not found.
  Future<Uint8List?> getImage(String id);

  /// Retrieves an annotation by its ID.
  ///
  /// - [id]: The ID of the annotation.
  /// - Returns: A [Future] that resolves to the annotation as a dictionary / map, or `null` if the
  ///   annotation is not found.
  Future<Map<String, Object?>?> getAnnotation(int id);

  ///-----------------------------------------------------------------------
  /// Methods from NaxaLibreFlutterHostApi
  ///-----------------------------------------------------------------------

  /// Adds a listener that is triggered when the map is rendered.
  ///
  /// - [listener]: The listener to add.
  void addOnMapRenderedListener(OnMapRendered listener);

  /// Adds a listener that is triggered when the map is fully loaded.
  ///
  /// - [listener]: The listener to add.
  void addOnMapLoadedListener(OnMapLoaded listener);

  /// Adds a listener that is triggered when the style of the map is fully loaded.
  ///
  /// - [listener]: The listener to add.
  void addOnStyleLoadedListener(OnStyleLoaded listener);

  /// Adds a listener that is triggered when the map is clicked.
  ///
  /// - [listener]: The listener to add.
  void addOnMapClickListener(OnMapClick listener);

  /// Adds a listener that is triggered when the map is long-clicked.
  ///
  /// - [listener]: The listener to add.
  void addOnMapLongClickListener(OnMapLongClick listener);

  /// Adds a listener that is triggered when an annotation is clicked.
  ///
  /// - [listener]: The listener to add.
  void addOnAnnotationClickListener(OnAnnotationClick listener);

  /// Adds a listener that is triggered when an annotation is long-clicked.
  ///
  /// - [listener]: The listener to add.
  void addOnAnnotationLongClickListener(OnAnnotationLongClick listener);

  /// Adds a listener that is triggered when an annotation is dragged.
  ///
  /// - [listener]: The listener to add.
  void addOnAnnotationDragListener(OnAnnotationDrag listener);

  /// Adds a listener that is triggered when the camera becomes idle.
  ///
  /// - [listener]: The listener to add.
  void addOnCameraIdleListener(OnCameraIdle listener);

  /// Adds a listener that is triggered when the camera is moving.
  ///
  /// - [listener]: The listener to add.
  void addOnCameraMoveListener(OnCameraMove listener);

  /// Adds a listener that is triggered when the map is being rotated.
  ///
  /// - [listener]: The listener to add.
  void addOnRotateListener(OnRotate listener);

  /// Adds a listener that is triggered when the map is flinged.
  ///
  /// - [listener]: The listener to add.
  void addOnFlingListener(OnFling listener);

  /// Adds a listener that is triggered when the frames per second (FPS) changes.
  ///
  /// - [listener]: The listener to add.
  void addOnFpsChangedListener(OnFpsChanged listener);

  /// Removes a previously added map rendered listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnMapRenderedListener(OnMapRendered listener);

  /// Removes a previously added map loaded listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnMapLoadedListener(OnMapLoaded listener);

  /// Removes a previously added style loaded listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnStyleLoadedListener(OnStyleLoaded listener);

  /// Removes a previously added map click listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnMapClickListener(OnMapClick listener);

  /// Removes a previously added map long-click listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnMapLongClickListener(OnMapLongClick listener);

  /// Removes a previously added annotation click listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnAnnotationClickListener(OnAnnotationClick listener);

  /// Removes a previously added annotation long-click listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnAnnotationLongClickListener(OnAnnotationLongClick listener);

  /// Removes a previously added annotation drag listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnAnnotationDragListener(OnAnnotationDrag listener);

  /// Removes a previously added camera idle listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnCameraIdleListener(OnCameraIdle listener);

  /// Removes a previously added camera move listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnCameraMoveListener(OnCameraMove listener);

  /// Removes a previously added rotation listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnRotateListener(OnRotate listener);

  /// Removes a previously added fling listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnFlingListener(OnFling listener);

  /// Removes a previously added FPS change listener.
  ///
  /// - [listener]: The listener to remove.
  void removeOnFpsChangedListener(OnFpsChanged listener);

  /// Clears all the map rendered listeners.
  void clearOnMapRenderedListeners();

  /// Clears all the map loaded listeners.
  void clearOnMapLoadedListeners();

  /// Clears all the style loaded listeners.
  void clearOnStyleLoadedListeners();

  /// Clears all the map click listeners.
  void clearOnMapClickListeners();

  /// Clears all the map long-click listeners.
  void clearOnMapLongClickListeners();

  /// Clears all the annotation click listeners.
  void clearOnAnnotationClickListeners();

  /// Clears all the annotation long-click listeners.
  void clearOnAnnotationLongClickListeners();

  /// Clears all the annotation drag listeners.
  void clearOnAnnotationDragListeners();

  /// Clears all the camera idle listeners.
  void clearOnCameraIdleListeners();

  /// Clears all the camera move listeners.
  void clearOnCameraMoveListeners();

  /// Clears all the rotation listeners.
  void clearOnRotateListeners();

  /// Clears all the fling listeners.
  void clearOnFlingListeners();

  /// Clears all the FPS change listeners.
  void clearOnFpsChangedListeners();

  /// Method to dispose the controller
  ///
  void dispose();
}
