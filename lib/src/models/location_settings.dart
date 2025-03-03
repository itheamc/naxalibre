import 'package:naxalibre/src/enums/enums.dart';
import 'package:naxalibre/src/models/location_component_options.dart';
import 'package:naxalibre/src/models/location_engine_request_options.dart';

/// A class representing the settings for a location component.
///
/// This class encapsulates the configuration for enabling or disabling the location
/// component and provides additional options for customizing its appearance and behavior
/// using the [LocationComponentOptions] class.
class LocationSettings {
  /// Whether the location component is enabled.
  ///
  /// When set to `true`, the location component is active and visible.
  /// When set to `false`, the location component is disabled and hidden.
  final bool locationEnabled;

  /// Whether the permission or authorization request should be made automatically.
  ///
  /// When set to `true`, the permission or authorization request will be made
  /// When set to `false`, the permission or authorization request will not be made
  final bool shouldRequestAuthorizationOrPermission;

  /// The camera mode for tracking the user's location.
  ///
  /// Determines how the camera follows the user's position on the map.
  /// Defaults to `none`, meaning no specific camera tracking behavior is applied.
  final CameraMode cameraMode;

  /// The rendering mode for the location component.
  ///
  /// Defines how the location indicator is displayed on the map.
  /// Defaults to `normal`, meaning the default rendering mode is used.
  final RenderMode renderMode;

  /// The maximum frames per second (FPS) for location animations.
  ///
  /// Limits the rendering speed of location updates to optimize performance.
  /// Defaults to `null`, meaning the system determines the FPS automatically.
  /// Note: No effect on iOS
  final int? maxAnimationFps;

  /// The tilt of the map while tracking the location.
  ///
  /// Adjusts the map's tilt (pitch) when the camera is in a tracking mode.
  /// A higher value results in a more angled view. Defaults to `null`, meaning no tilt adjustment.
  /// Note: No effect on iOS
  final double? tiltWhileTracking;

  /// The zoom level of the map while tracking the location.
  ///
  /// Defines how closely the map zooms in when following the user's movement.
  /// Defaults to `null`, meaning no specific zoom level is enforced.
  /// Note: No effect on iOS
  final double? zoomWhileTracking;

  /// The configuration options for the location component.
  ///
  /// This includes settings such as pulse animations, colors, elevation, and layer
  /// positioning. Defaults to an instance of [LocationComponentOptions] with default values.
  final LocationComponentOptions locationComponentOptions;

  /// The configuration options for the location engine.
  ///
  /// Determines how frequently location updates are requested and processed.
  /// Defaults to an instance of [LocationEngineRequestOptions] with default values.
  final LocationEngineRequestOptions locationEngineRequestOptions;

  /// Creates a new instance of [LocationSettings].
  ///
  /// - [locationEnabled]: Whether the location component is enabled. Defaults to `false`.
  /// - [shouldRequestAuthorizationOrPermission]: Whether the permission or authorization request should be made automatically. Defaults to `false`.
  /// - [cameraMode]: The camera tracking mode for following the user's location.
  /// - [renderMode]: The rendering mode for displaying the location indicator.
  /// - [maxAnimationFps]: The maximum frame rate for location animations.
  /// - [tiltWhileTracking]: The tilt angle of the map while tracking.
  /// - [zoomWhileTracking]: The zoom level of the map while tracking.
  /// - [locationComponentOptions]: Configuration for the visual appearance of the location component.
  /// - [locationEngineRequestOptions]: Configuration for how location updates are requested.
  const LocationSettings({
    this.locationEnabled = false,
    this.shouldRequestAuthorizationOrPermission = false,
    this.cameraMode = CameraMode.none,
    this.renderMode = RenderMode.normal,
    this.maxAnimationFps,
    this.tiltWhileTracking,
    this.zoomWhileTracking,
    this.locationComponentOptions = const LocationComponentOptions(),
    this.locationEngineRequestOptions = const LocationEngineRequestOptions(),
  });

  /// Converts the [LocationSettings] object into a map.
  ///
  /// This method is useful for serialization or passing data to other layers
  /// (e.g., Kotlin/Swift). The keys in the map correspond to the property names,
  /// and the values are the current values of those properties.
  ///
  /// Returns a [Map<String, dynamic>] representing the object.
  Map<String, dynamic> toArgs() {
    return {
      'locationEnabled': locationEnabled,
      'shouldRequestAuthorizationOrPermission': shouldRequestAuthorizationOrPermission,
      'cameraMode': cameraMode.value,
      'renderMode': renderMode.value,
      'maxAnimationFps': maxAnimationFps,
      'tiltWhileTracking': tiltWhileTracking,
      'zoomWhileTracking': zoomWhileTracking,
      'locationComponentOptions': locationComponentOptions.toArgs(),
      'locationEngineRequestOptions': locationEngineRequestOptions.toArgs(),
    };
  }
}
