import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/pigeon_generated.dart',
  dartPackageName: 'naxalibre',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/np/com/naxa/naxalibre/pigeon/PigeonGenerated.kt',
  kotlinOptions: KotlinOptions(),
  swiftOut: 'ios/Classes/PigeonGenerated.swift',
  swiftOptions: SwiftOptions(),
))
@HostApi()
abstract class NaxaLibreHostApi {
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

  List<Map<Object?, Object?>> queryRenderedFeatures(Map<String, Object?> args);

  List<double> lastKnownLocation();

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

  void addLayer(Map<String, Object?> layer);

  void addSource(Map<String, Object?> source);

  bool removeLayer(String id);

  bool removeLayerAt(int index);

  bool removeSource(String id);

  void removeImage(String name);

  Uint8List getImage(String id);

  @async
  Uint8List snapshot();

  void triggerRepaint();
}

@FlutterApi()
abstract class NaxaLibreFlutterApi {
  void onFpsChanged(double fps);

  void onMapLoaded();

  void onMapRendered();

  void onStyleLoaded();

  void onMapClick(List<double> latLng);

  void onMapLongClick(List<double> latLng);

  void onCameraIdle();

  void onCameraMoveStarted(int? reason);

  void onCameraMove();

  void onCameraMoveEnd();

  void onFling();

  void onRotateStarted(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  );

  void onRotate(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  );

  void onRotateEnd(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  );
}
