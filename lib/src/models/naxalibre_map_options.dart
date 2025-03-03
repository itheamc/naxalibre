import 'camera_position.dart';

/// A class that defines various configuration options for the NaxaLibreMap.
///
/// This class allows customization of zoom levels, pitch limits, camera position,
/// rendering behavior, and debug options.
class NaxaLibreMapOptions {
  /// The minimum zoom level allowed for the map.
  /// Default is 0.0
  ///
  final double minZoom;

  /// The maximum zoom level allowed for the map.
  /// Default is 25.0
  ///
  final double maxZoom;

  /// The minimum pitch (tilt) angle allowed for the map.
  /// Default is 0.0
  ///
  final double minPitch;

  /// The maximum pitch (tilt) angle allowed for the map.
  /// Default is 60.0
  ///
  final double maxPitch;

  /// The initial camera position of the map.
  final CameraPosition position;

  /// The pixel ratio for rendering, useful for handling high-density displays.
  final double? pixelRatio;

  /// Whether to use texture mode for rendering. This can improve performance on some devices.
  /// Default is false
  ///
  final bool textureMode;

  /// Whether debugging features (e.g., tile borders, FPS display) are enabled.
  /// Default is false
  ///
  final bool debugActive;

  /// Whether cross-source collisions are enabled for symbol placement.
  /// Default is true
  ///
  final bool crossSourceCollisions;

  /// Whether the render surface is placed on top of other UI elements.
  /// Default is false
  ///
  final bool renderSurfaceOnTop;

  /// Creates a [NaxaLibreMapOptions] instance with the specified properties.
  ///
  /// All parameters have required named arguments to enforce explicit configuration.
  const NaxaLibreMapOptions({
    this.minZoom = 0.0,
    this.maxZoom = 25.5,
    this.minPitch = 0.0,
    this.maxPitch = 60.0,
    this.position = const CameraPosition(),
    this.pixelRatio = 0.0,
    this.textureMode = false,
    this.debugActive = false,
    this.crossSourceCollisions = true,
    this.renderSurfaceOnTop = false,
  });

  /// Converts the options into a map of arguments that can be passed to the platform channel.
  Map<String, dynamic> toArgs() {
    return {
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'minPitch': minPitch,
      'maxPitch': maxPitch,
      'position': position.toArgs(),
      'pixelRatio': pixelRatio,
      'textureMode': textureMode,
      'debugActive': debugActive,
      'crossSourceCollisions': crossSourceCollisions,
      'renderSurfaceOnTop': renderSurfaceOnTop,
    };
  }
}
