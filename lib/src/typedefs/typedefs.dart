import 'package:flutter/foundation.dart';

import '../../naxalibre.dart';
import '../enums/enums.dart';

/// A callback function type that is triggered when the map is created.
///
/// This function provides access to the [NaxaLibreController],
/// which allows interaction with the map instance, such as controlling
/// the camera, layers, and other map settings.
///
/// Example usage:
/// ```dart
/// void onMapCreated(NaxaLibreController controller) {
///   print("Map has been created.");
///   controller.setZoomLevel(10.0);
/// }
/// ```
typedef OnMapCreated = void Function(NaxaLibreController);

/// A callback function type that is triggered when the map has fully loaded.
///
/// This function is called once all essential resources, such as tiles
/// and data, have been loaded and the map is ready for interaction.
///
/// Example usage:
/// ```dart
/// void onMapLoaded() {
///   print("Map has finished loading.");
/// }
/// ```
typedef OnMapLoaded = VoidCallback;

/// A callback function type that is triggered when the map has been rendered.
///
/// This function is called once the map has completed its rendering process,
/// ensuring that all visual elements have been drawn on the screen.
///
/// Example usage:
/// ```dart
/// void onMapRendered() {
///   print("Map has been rendered.");
/// }
/// ```
typedef OnMapRendered = VoidCallback;

/// A callback function type that is triggered when the map's style has been loaded.
///
/// This function is called when the map's style (including layers, symbols,
/// and visual settings) has been fully applied and is ready for interaction.
///
/// Example usage:
/// ```dart
/// void onStyleLoaded() {
///   print("Map style has been loaded.");
/// }
/// ```
typedef OnStyleLoaded = VoidCallback;

/// A callback function type that is triggered when the map is clicked.
///
/// This function provides the geographical coordinates ([LatLng])
/// of the location where the user clicked on the map.
///
/// Example usage:
/// ```dart
/// void onMapClick(LatLng position) {
///   print("Map clicked at: ${position.latitude}, ${position.longitude}");
/// }
/// ```
typedef OnMapClick = void Function(LatLng);

/// A callback function type that is triggered when the map is long-clicked.
///
/// This function provides the geographical coordinates ([LatLng])
/// of the location where the user performed a long press on the map.
///
/// Example usage:
/// ```dart
/// void onMapLongClick(LatLng position) {
///   print("Map long-clicked at: ${position.latitude}, ${position.longitude}");
/// }
/// ```
typedef OnMapLongClick = void Function(LatLng);

/// A callback function type that is triggered when the frames per second (FPS) change.
///
/// This function provides the updated FPS value, allowing performance monitoring
/// or optimizations based on rendering performance.
///
/// Example usage:
/// ```dart
/// void onFpsChanged(double fps) {
///   print("Current FPS: $fps");
/// }
/// ```
typedef OnFpsChanged = void Function(double fps);

/// A callback function type that is triggered when the camera movement comes to a stop.
///
/// This function is called when the camera has stopped moving,
/// ensuring that all animations, gestures, or programmatic movements
/// have completed.
///
/// Example usage:
/// ```dart
/// void onCameraIdle() {
///   print("Camera movement has stopped.");
/// }
/// ```
typedef OnCameraIdle = VoidCallback;

/// A callback function type for handling camera movement events.
///
/// This function is triggered whenever a camera movement event occurs,
/// such as when the camera starts moving, is in motion, or stops.
///
/// Example usage:
/// ```dart
/// void handleCameraMove(CameraMoveEvent event, CameraMoveReason? reason) {
///   if (event == CameraMoveEvent.start) {
///     print("Camera movement started.");
///   } else if (event == CameraMoveEvent.moving) {
///     print("Camera is moving.");
///   } else if (event == CameraMoveEvent.end) {
///     print("Camera movement ended.");
///   }
/// }
/// ```
///
/// This callback is useful for updating UI elements or executing
/// logic based on the camera's movement state.
typedef OnCameraMove = void Function(CameraMoveEvent event, CameraMoveReason? reason);

/// A callback function type for handling rotation events.
///
/// This function is triggered whenever a rotation event occurs,
/// such as when rotation starts, is in progress, or ends.
///
/// The parameters provide useful details about the rotation:
/// - [event]: The current rotation event state (start, rotating, or end).
/// - [angleThreshold]: The minimum angle required to trigger a rotation event.
/// - [deltaSinceStart]: The total rotation angle change since the rotation started.
/// - [deltaSinceLast]: The change in rotation angle since the last event update.
///
/// Example usage:
/// ```dart
/// void handleRotation(
///   RotateEvent event,
///   double angleThreshold,
///   double deltaSinceStart,
///   double deltaSinceLast,
/// ) {
///   if (event == RotateEvent.start) {
///     print("Rotation started.");
///   } else if (event == RotateEvent.rotating) {
///     print("Rotating... Δ: $deltaSinceLast° (Total: $deltaSinceStart°)");
///   } else if (event == RotateEvent.end) {
///     print("Rotation ended.");
///   }
/// }
/// ```
///
/// This callback is useful for implementing custom rotation behaviors,
/// UI updates, or constraints based on user interactions.
typedef OnRotate = void Function(
  RotateEvent event,
  double angleThreshold,
  double deltaSinceStart,
  double deltaSinceLast,
);

/// A callback function type for handling fling gestures.
///
/// This function is triggered when a fling gesture is detected,
/// typically when the user quickly swipes or releases a drag motion
/// with high velocity.
///
/// Example usage:
/// ```dart
/// void handleFling() {
///   print("Fling gesture detected!");
/// }
/// ```
///
/// This callback is useful for implementing momentum-based interactions,
/// such as continuing movement after a quick swipe or triggering animations.
typedef OnFling = VoidCallback;
