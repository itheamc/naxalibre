import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'naxalibre_method_channel.dart';

abstract class NaxaLibrePlatform extends PlatformInterface {
  /// Constructs a NaxaLibrePlatform.
  NaxaLibrePlatform() : super(token: _token);

  static final Object _token = Object();

  static NaxaLibrePlatform _instance = MethodChannelNaxaLibre();

  /// The default instance of [NaxaLibrePlatform] to use.
  ///
  /// Defaults to [MethodChannelNaxaLibre].
  static NaxaLibrePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NaxaLibrePlatform] when
  /// they register themselves.
  static set instance(NaxaLibrePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    bool hyperComposition = false,
  });

  List<double> fromScreenLocation(List<double> point);

  List<double> toScreenLocation(List<double> latLng);

  List<double> getLatLngForProjectedMeters(double northing, double easting);

  List<List<double>> getVisibleRegion(bool ignorePadding);

  List<double> getProjectedMetersForLatLng(List<double> latLng);

  Map<String, Object> getCameraPosition();

  double getZoom();

  double getHeight();

  double getWidth();

  double getMinimumZoom();

  double getMaximumZoom();

  double getMinimumPitch();

  double getMaximumPitch();

  double getPixelRatio();

  bool isDestroyed();

  void setMaximumFps(int fps);

  void setStyle(String style);

  void setSwapBehaviorFlush(bool flush);

  void animateCamera(Map<String, Object?> args);

  void easeCamera(Map<String, Object?> args);

  void zoomBy(int by);

  void zoomIn();

  void zoomOut();

  Map<String, Object?> getCameraForLatLngBounds(Map<String, Object?> bounds);

  List<Map<String, Object?>> queryRenderedFeatures(Map<String, Object?> args);

  // Method from UiSettings i.e. mapboxMap.uiSettings
  void setLogoMargins(
      double left,
      double top,
      double right,
      double bottom,
      );

  bool isLogoEnabled();

  void setCompassMargins(
      double left,
      double top,
      double right,
      double bottom,
      );

  void setCompassImage(Uint8List bytes);

  void setCompassFadeFacingNorth(bool compassFadeFacingNorth);

  bool isCompassEnabled();

  bool isCompassFadeWhenFacingNorth();

  void setAttributionMargins(
      double left,
      double top,
      double right,
      double bottom,
      );

  bool isAttributionEnabled();

  void setAttributionTintColor(int color);

  // Methods from style
  //
  String getUri();

  String getJson();

  Map<String, Object> getLight();

  bool isFullyLoaded();

  // {"id": "layerId", "max_zoom": 22, "min_zoom": 10, "is_detached": true}
  Map<String, Object?> getLayer(String id);

  List<Map<String, Object?>> getLayers(String id);

  // {"id": "sourceId", "attribution": "thi is attributions", "is_volatile": false}
  Map<String, Object?> getSource(String id);

  List<Map<String, Object?>> getSources();

  void addImage(String name, Uint8List bytes);

  void addImages(Map<String, Uint8List> images);

  void addLayer(Map<String, Object> layer);

  void addSource(Map<String, Object> source);

  bool removeLayer(String id);

  bool removeLayerAt(int index);

  bool removeSource(String id);

  void removeImage(String name);

  Uint8List getImage(String id);
}
