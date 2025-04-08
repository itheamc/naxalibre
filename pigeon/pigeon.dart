import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon_generated.dart',
    dartPackageName: 'naxalibre',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/itheamc/naxalibre/pigeon/PigeonGenerated.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Classes/PigeonGenerated.swift',
    swiftOptions: SwiftOptions(),
  ),
)
sealed class NaxaLibreEvent {}

class IntEvent extends NaxaLibreEvent {
  IntEvent(this.data);

  final int data;
}

class DoubleEvent extends NaxaLibreEvent {
  DoubleEvent(this.data);

  final double data;
}

class StringEvent extends NaxaLibreEvent {
  StringEvent(this.data);

  final String data;
}

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
  void setLogoMargins(double left, double top, double right, double bottom);

  bool isLogoEnabled();

  void setCompassMargins(double left, double top, double right, double bottom);

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

  @async
  String getJson();

  Map<String, Object> getLight();

  bool isFullyLoaded();

  Map<Object?, Object?> getLayer(String id);

  List<Map<Object?, Object?>> getLayers();

  Map<Object?, Object?> getSource(String id);

  List<Map<Object?, Object?>> getSources();

  void addImage(String name, Uint8List bytes);

  void addImages(Map<String, Uint8List> images);

  void addLayer(Map<String, Object?> layer);

  void addSource(Map<String, Object?> source);

  void setGeoJsonData(String sourceId, String jsonString);

  void setGeoJsonUri(String sourceId, String uri);

  Map<String, Object?> addAnnotation(Map<String, Object?> annotation);

  Map<String, Object?> updateAnnotation(
    int id,
    Map<String, Object?> annotation,
  );

  Map<String, Object?>? getAnnotation(int id);

  bool removeLayer(String id);

  bool removeLayerAt(int index);

  bool removeSource(String id);

  void removeImage(String name);

  void removeAnnotation(Map<String, Object?> args);

  void removeAllAnnotations(Map<String, Object?> args);

  Uint8List getImage(String id);

  @async
  Uint8List snapshot();

  void triggerRepaint();

  void resetNorth();

  @async
  Map<Object?, Object?> downloadRegion(Map<String, Object?> args);

  @async
  bool cancelDownloadRegion(int id);

  @async
  Map<Object?, Object?> getRegion(int id);

  @async
  bool deleteRegion(int id);

  @async
  Map<int, bool> deleteAllRegions();

  @async
  List<Map<Object?, Object?>> listRegions();
}

@FlutterApi()
abstract class NaxaLibreFlutterApi {
  void onFpsChanged(double fps);

  void onMapLoaded();

  void onMapRendered();

  void onStyleLoaded();

  void onMapClick(List<double> latLng);

  void onMapLongClick(List<double> latLng);

  void onAnnotationClick(Map<String, Object?> annotation);

  void onAnnotationLongClick(Map<String, Object?> annotation);

  void onAnnotationDrag(
    int id,
    String type,
    Map<String, Object?> geometry,
    Map<String, Object?> updatedGeometry,
    String event,
  );

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

@EventChannelApi()
abstract class NaxaLibreEventChannelApi {
  NaxaLibreEvent streamEvents();
}
