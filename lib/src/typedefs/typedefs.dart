import 'package:flutter/foundation.dart';

import '../controller/naxalibre_controller.dart';
import '../enums/enums.dart';
import '../models/latlng.dart';

/// A callback function type that is triggered when the map is created.
///
/// This function provides access to the [NaxaLibreController],
/// which allows interaction with the map instance, such as controlling
/// the camera, layers, and other map settings.
///
typedef OnMapCreated = void Function(NaxaLibreController);

/// A callback function type that is triggered when the map has fully loaded.
///
/// This function is called once all essential resources, such as tiles
/// and data, have been loaded and the map is ready for interaction.
///
typedef OnMapLoaded = VoidCallback;

/// A callback function type that is triggered when the map has been rendered.
///
/// This function is called once the map has completed its rendering process,
/// ensuring that all visual elements have been drawn on the screen.
///
typedef OnMapRendered = VoidCallback;

/// A callback function type that is triggered when the map's style has been loaded.
///
/// This function is called when the map's style (including layers, symbols,
/// and visual settings) has been fully applied and is ready for interaction.
///
typedef OnStyleLoaded = VoidCallback;

/// A callback function type that is triggered when the map is clicked.
///
/// This function provides the geographical coordinates ([LatLng])
/// of the location where the user clicked on the map.
///
typedef OnMapClick = void Function(LatLng);

/// A callback function type that is triggered when the map is long-clicked.
///
/// This function provides the geographical coordinates ([LatLng])
/// of the location where the user performed a long press on the map.
///
typedef OnMapLongClick = void Function(LatLng);

/// A callback function type that is triggered when an annotation is clicked.
///
/// This function provides a map of annotation properties
/// that contains details about the clicked annotation.
///
typedef OnAnnotationClick = void Function(Map<String, Object?> annotation);

/// A callback function type that is triggered when an annotation is long-clicked.
///
/// This function provides a map of annotation properties
/// that contains details about the annotation that was long-pressed.
///
typedef OnAnnotationLongClick = void Function(Map<String, Object?> annotation);

/// A callback function type that is triggered when an annotation is dragged.
///
/// This function provides details about the dragged annotation,
/// including its ID, type, geometry, updated geometry, and the event type.
///
typedef OnAnnotationDrag =
    void Function(
      int id,
      String type,
      Map<String, Object?> geometry,
      Map<String, Object?> updatedGeometry,
      AnnotationDragEvent event,
    );

/// A callback function type that is triggered when the frames per second (FPS) change.
///
/// This function provides the updated FPS value, allowing performance monitoring
/// or optimizations based on rendering performance.
///
typedef OnFpsChanged = void Function(double fps);

/// A callback function type that is triggered when the camera movement comes to a stop.
///
/// This function is called when the camera has stopped moving,
/// ensuring that all animations, gestures, or programmatic movements
/// have completed.
///
typedef OnCameraIdle = VoidCallback;

/// A callback function type for handling camera movement events.
///
/// This function is triggered whenever a camera movement event occurs,
/// such as when the camera starts moving, is in motion, or stops.
///
/// This callback is useful for updating UI elements or executing
/// logic based on the camera's movement state.
typedef OnCameraMove =
    void Function(CameraMoveEvent event, CameraMoveReason? reason);

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
/// This callback is useful for implementing custom rotation behaviors,
/// UI updates, or constraints based on user interactions.
typedef OnRotate =
    void Function(
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
/// This callback is useful for implementing momentum-based interactions,
/// such as continuing movement after a quick swipe or triggering animations.
typedef OnFling = VoidCallback;
