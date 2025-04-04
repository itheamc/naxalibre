import '../enums/enums.dart';
import '../models/latlng.dart';
import '../typedefs/typedefs.dart';

import '../pigeon_generated.dart';
import '../utils/naxalibre_logger.dart';

/// [NaxaLibreListenerKey] is an internal enum used to categorize the
/// different types of listeners that can be registered with the
/// [NaxaLibreListeners].
///
/// Each enum value represents a specific event that can occur on the map,
/// such as the map being rendered, loaded, or a click event being detected.
///
enum NaxaLibreListenerKey {
  onMapRendered,
  onMapLoaded,
  onStyleLoaded,
  onMapClick,
  onMapLongClick,
  onAnnotationClick,
  onAnnotationLongClick,
  onAnnotationDrag,
  onCameraIdle,
  onCameraMove,
  onRotate,
  onFling,
  onFpsChanged,
}

/// [NaxaLibreListeners] is a callback handler for the NaxaLibreFlutter API that manages event listeners.
///
/// This class extends [NaxaLibreFlutterApi] and acts as an event dispatcher
/// for various map-related events.
///
/// It allows registering and unregistering listeners dynamically and ensures
/// safe execution of callback functions.
///
class NaxaLibreListeners extends NaxaLibreFlutterApi {
  /// Stores registered listeners, categorized by their type.
  final Map<NaxaLibreListenerKey, List<Function>> _listeners = {};

  /// Sets up the callback handler for the NaxaLibreFlutter API.
  ///
  NaxaLibreListeners() {
    NaxaLibreFlutterApi.setUp(this);
  }

  /// Safely executes listeners of type [T] with the given parameters.
  ///
  /// Handles any errors that occur during execution and logs them.
  ///
  /// Safely executes listeners of type [T].
  void _safeExecute<T>(NaxaLibreListenerKey key, void Function(T) executor) {
    try {
      _listeners[key]?.forEach((listener) {
        try {
          executor(listener as T);
        } catch (e) {
          NaxaLibreLogger.logError(
            "[$runtimeType._safeExecute<$key>.executor] => $e",
          );
        }
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType._safeExecute<$key>] => $e");
    }
  }

  /// Generic add listener function.
  void add<T>(NaxaLibreListenerKey key, Function listener) {
    _listeners[key] ??= [];
    _listeners[key]!.add(listener);
  }

  /// Generic remove listener function.
  void remove<T>(NaxaLibreListenerKey key, Function listener) {
    _listeners[key]?.remove(listener);
  }

  /// Generic clear listener function.
  void clear<T>(NaxaLibreListenerKey key) {
    _listeners[key]?.clear();
  }

  /// Callback when the map is rendered.
  @override
  void onMapRendered() {
    _safeExecute<OnMapRendered>(
      NaxaLibreListenerKey.onMapRendered,
      (callback) => callback.call(),
    );
  }

  /// Callback when the map is fully loaded.
  @override
  void onMapLoaded() {
    _safeExecute<OnMapLoaded>(
      NaxaLibreListenerKey.onMapLoaded,
      (callback) => callback.call(),
    );
  }

  /// Callback when the map style is loaded.
  @override
  void onStyleLoaded() {
    _safeExecute<OnStyleLoaded>(
      NaxaLibreListenerKey.onStyleLoaded,
      (callback) => callback.call(),
    );
  }

  /// Callback when the map is clicked, providing the clicked coordinates.
  @override
  void onMapClick(List<double> latLng) {
    _safeExecute<OnMapClick>(
      NaxaLibreListenerKey.onMapClick,
      (callback) => callback.call(LatLng.fromArgs(latLng)),
    );
  }

  /// Callback when the map is long-clicked, providing the clicked coordinates.
  @override
  void onMapLongClick(List<double> latLng) {
    _safeExecute<OnMapLongClick>(
      NaxaLibreListenerKey.onMapLongClick,
      (callback) => callback.call(LatLng.fromArgs(latLng)),
    );
  }

  /// Callback when an annotation is clicked.
  @override
  void onAnnotationClick(Map<String, Object?> annotation) {
    _safeExecute<OnAnnotationClick>(
      NaxaLibreListenerKey.onAnnotationClick,
      (callback) => callback.call({
        ...annotation,
        "id": num.tryParse(annotation["id"].toString())?.toInt(),
      }),
    );
  }

  /// Callback when an annotation is long-clicked.
  @override
  void onAnnotationLongClick(Map<String, Object?> annotation) {
    _safeExecute<OnAnnotationLongClick>(
      NaxaLibreListenerKey.onAnnotationLongClick,
      (callback) => callback.call({
        ...annotation,
        "id": num.tryParse(annotation["id"].toString())?.toInt(),
      }),
    );
  }

  /// Callback when an annotation is dragged.
  @override
  void onAnnotationDrag(
    int id,
    String type,
    Map<String, Object?> geometry,
    Map<String, Object?> updatedGeometry,
    String event,
  ) {
    _safeExecute<OnAnnotationDrag>(
      NaxaLibreListenerKey.onAnnotationDrag,
      (callback) => callback.call(
        id,
        type,
        {"id": num.tryParse(geometry["id"].toString())?.toInt(), ...geometry},
        {
          "id": num.tryParse(updatedGeometry["id"].toString())?.toInt(),
          ...updatedGeometry,
        },
        AnnotationDragEvent.fromStr(event),
      ),
    );
  }

  /// Callback when the camera movement stops.
  @override
  void onCameraIdle() {
    _safeExecute<OnCameraIdle>(
      NaxaLibreListenerKey.onCameraIdle,
      (callback) => callback.call(),
    );
  }

  /// Callback when camera movement starts, with an optional reason code.
  @override
  void onCameraMoveStarted(int? reason) {
    _safeExecute<OnCameraMove>(
      NaxaLibreListenerKey.onCameraMove,
      (callback) => callback.call(
        CameraMoveEvent.start,
        CameraMoveReason.fromCode(reason),
      ),
    );
  }

  /// Callback when the camera moves.
  @override
  void onCameraMove() {
    _safeExecute<OnCameraMove>(
      NaxaLibreListenerKey.onCameraMove,
      (callback) => callback.call(CameraMoveEvent.moving, null),
    );
  }

  /// Callback when the camera movement ends.
  @override
  void onCameraMoveEnd() {
    _safeExecute<OnCameraMove>(
      NaxaLibreListenerKey.onCameraMove,
      (callback) => callback.call(CameraMoveEvent.end, null),
    );
  }

  /// Callback when a rotation gesture starts.
  @override
  void onRotateStarted(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  ) {
    _safeExecute<OnRotate>(
      NaxaLibreListenerKey.onRotate,
      (callback) => callback.call(
        RotateEvent.start,
        angleThreshold,
        deltaSinceStart,
        deltaSinceLast,
      ),
    );
  }

  /// Callback when a rotation gesture is in progress.
  @override
  void onRotate(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  ) {
    _safeExecute<OnRotate>(
      NaxaLibreListenerKey.onRotate,
      (callback) => callback.call(
        RotateEvent.rotating,
        angleThreshold,
        deltaSinceStart,
        deltaSinceLast,
      ),
    );
  }

  /// Callback when a rotation gesture ends.
  @override
  void onRotateEnd(
    double angleThreshold,
    double deltaSinceStart,
    double deltaSinceLast,
  ) {
    _safeExecute<OnRotate>(
      NaxaLibreListenerKey.onRotate,
      (callback) => callback.call(
        RotateEvent.end,
        angleThreshold,
        deltaSinceStart,
        deltaSinceLast,
      ),
    );
  }

  /// Callback when a fling gesture is detected.
  @override
  void onFling() {
    _safeExecute<OnFling>(
      NaxaLibreListenerKey.onFling,
      (callback) => callback.call(),
    );
  }

  /// Callback when the FPS (frames per second) changes.
  @override
  void onFpsChanged(double fps) {
    _safeExecute<OnFpsChanged>(
      NaxaLibreListenerKey.onFpsChanged,
      (callback) => callback.call(fps),
    );
  }

  /// Disposes of all registered listeners.
  void dispose() {
    _listeners.clear();
  }
}
