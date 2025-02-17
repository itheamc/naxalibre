import 'package:flutter/widgets.dart';
import 'latlng.dart';

/// Represents a camera position on a map, including zoom, tilt, bearing,
/// target coordinates, and padding.
///
/// The [CameraPosition] class is primarily used to animate the map camera
/// to a specific geographic coordinate or customize the map view.
///
/// Example:
/// ```dart
/// const CameraPosition position = CameraPosition(
///   target: LatLng(27.7172, 85.3240),
///   zoom: 14.0,
///   tilt: 45.0,
///   bearing: 90.0,
///   padding: EdgeInsets.all(16.0),
/// );
/// ```
class CameraPosition {
  /// The tilt angle of the camera in degrees.
  ///
  /// This defines the angle between the camera's line of sight and the ground plane.
  final double? tilt;

  /// The zoom level of the camera.
  ///
  /// Higher values indicate closer zoom, while lower values zoom out.
  final double? zoom;

  /// The bearing of the camera in degrees.
  ///
  /// This defines the direction that the camera is facing, measured clockwise
  /// from north.
  final double? bearing;

  /// The target geographic coordinates that the camera points to.
  ///
  /// If null, the camera does not have a specific target.
  final LatLng? target;

  /// The padding around the map insets.
  ///
  /// This is useful for adding space around the visible map area,
  /// measured in pixels. The default value is [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Creates a [CameraPosition] with the specified [tilt], [zoom], [bearing],
  /// [target], and [padding].
  ///
  /// All parameters are optional. If not provided, [padding] defaults to [EdgeInsets.zero].
  const CameraPosition({
    this.tilt,
    this.zoom,
    this.bearing,
    this.target,
    this.padding = EdgeInsets.zero,
  });

  /// Converts the [CameraPosition] instance into a map representation (args).
  ///
  /// This method is primarily used for passing the [CameraPosition] object
  /// to native platform code via platform channels.
  ///
  /// The returned map includes:
  /// - `"target"`: The target coordinates as a list [latitude, longitude].
  /// - `"zoom"`: The zoom level.
  /// - `"bearing"`: The camera's bearing.
  /// - `"tilt"`: The camera's tilt.
  /// - `"padding"`: The padding values as a list [left, top, right, bottom].
  ///
  /// Example:
  /// ```dart
  /// final CameraPosition position = CameraPosition(
  ///   target: LatLng(27.7172, 85.3240),
  ///   zoom: 14.0,
  ///   tilt: 45.0,
  ///   bearing: 90.0,
  /// );
  ///
  /// final Map<String, dynamic> positionMap = position.toMap();
  /// print(positionMap);
  /// ```
  Map<String, dynamic> toArgs() {
    return {
      "target": target?.latLngList(),
      "zoom": zoom,
      "bearing": bearing,
      "tilt": tilt,
      "padding": [padding.left, padding.top, padding.right, padding.bottom],
    };
  }

  /// Create [CameraPosition] from `args`
  ///
  /// The `args` must be:
  /// - `"target"`: The target coordinates as a list [latitude, longitude].
  /// - `"zoom"`: The zoom level.
  /// - `"bearing"`: The camera's bearing.
  /// - `"tilt"`: The camera's tilt.
  /// - `"padding"`: The padding values as a list [left, top, right, bottom].
  factory CameraPosition.fromArgs(Map<String, dynamic> args) {
    return CameraPosition(
      target: args["target"] == null || args["target"] is! List
          ? null
          : LatLng.fromArgs(args["target"]),
      zoom: args["zoom"],
      bearing: args["bearing"],
      tilt: args["tilt"],
      padding: args["padding"] != null &&
              args["padding"] is List &&
              (args["padding"] as List).length == 4
          ? EdgeInsets.fromLTRB(
              args["padding"][0],
              args["padding"][1],
              args["padding"][2],
              args["padding"][3],
            )
          : EdgeInsets.zero,
    );
  }
}
