import 'camera_position.dart';
import 'latlng.dart';
import 'latlng_bounds.dart';

/// Abstract class for Camera Update
///
/// Defines the basic structure for camera updates that modify the map’s camera
/// position, bounds, or zoom level. Specific updates are implemented by
/// subclasses that define how to apply each update to the camera.
///
abstract class CameraUpdate {
  /// Internal field to store the update type
  String? _type;

  /// Converts the CameraUpdate object to a Map.
  ///
  /// Returns:
  /// A `Map` representing the serialized CameraUpdate.
  Map<String, dynamic> toArgs();
}

/// Camera position update
///
/// Used to update the camera’s position to a new `CameraPosition` on the map.
class _CameraPositionUpdate extends CameraUpdate {
  /// The new camera position.
  final CameraPosition cameraPosition;

  /// Constructor to initialize the camera position update.
  _CameraPositionUpdate(this.cameraPosition);

  /// Converts the CameraPositionUpdate object to a Map.
  @override
  Map<String, dynamic> toArgs() {
    return {
      "type": _type,
      "camera_position": cameraPosition.toArgs(),
    };
  }
}

/// Camera bounds update
///
/// Used to update the camera’s bounds to fit the given `LatLngBounds` with optional
/// parameters for padding, bearing, and tilt.
class _CameraBoundsUpdate extends CameraUpdate {
  /// The bounds to fit the camera.
  final LatLngBounds bounds;

  /// Optional padding for the camera view.
  final double? padding;

  /// Optional bearing for the camera view.
  final double? bearing;

  /// Optional tilt for the camera view.
  final double? tilt;

  /// Constructor to initialize the camera bounds update with optional parameters.
  _CameraBoundsUpdate(
    this.bounds, {
    this.padding,
    this.bearing,
    this.tilt,
  });

  /// Converts the CameraBoundsUpdate object to a Map.
  @override
  Map<String, dynamic> toArgs() {
    return {
      "type": _type,
      "bounds": bounds.toArgs(),
      "padding": padding,
      "bearing": bearing,
      "tilt": tilt,
    };
  }
}

/// LatLng update
///
/// Used to update the camera’s position to a specific `LatLng` point on the map.
class _LatLngUpdate extends CameraUpdate {
  /// The target latitude/longitude.
  final LatLng latLng;

  /// Constructor to initialize the LatLng update.
  _LatLngUpdate(this.latLng);

  /// Converts the LatLngUpdate object to a Map.
  @override
  Map<String, dynamic> toArgs() {
    return {
      "type": _type,
      "latLng": latLng.toArgs(),
    };
  }
}

/// Zoom update
///
/// Used to update the camera’s zoom level either to a specific value or by a
/// specific amount.
class _ZoomUpdate extends CameraUpdate {
  /// The zoom level or zoom increment.
  final double zoom;

  /// Constructor to initialize the zoom update.
  _ZoomUpdate(this.zoom);

  /// Converts the ZoomUpdate object to a Map.
  @override
  Map<String, dynamic> toArgs() {
    return {
      "type": _type,
      "zoom": zoom,
    };
  }
}

/// Factory class for creating CameraUpdate objects
///
/// Provides static methods to generate specific `CameraUpdate` objects
/// like changing camera position, updating camera bounds, or zooming.
class CameraUpdateFactory {
  CameraUpdateFactory._();

  /// Creates a CameraUpdate to move to a new camera position.
  ///
  /// Parameters:
  /// - [cameraPosition]: The new camera position to move to.
  ///
  /// Returns:
  /// A `CameraUpdate` for the new camera position.
  static CameraUpdate newCameraPosition(CameraPosition cameraPosition) {
    return _CameraPositionUpdate(
      cameraPosition,
    ).._type = "newCameraPosition";
  }

  /// Creates a CameraUpdate to move to new camera bounds.
  ///
  /// Parameters:
  /// - [bounds]: The new bounds to fit the camera to.
  /// - [padding]: Optional padding to adjust the camera view.
  /// - [bearing]: Optional bearing (rotation) for the camera.
  /// - [tilt]: Optional tilt for the camera.
  ///
  /// Returns:
  /// A `CameraUpdate` for the new camera bounds.
  static CameraUpdate newLatLngBounds(
    LatLngBounds bounds, {
    double? padding,
    double? bearing,
    double? tilt,
  }) {
    return _CameraBoundsUpdate(
      bounds,
      padding: padding,
      bearing: bearing,
      tilt: tilt,
    ).._type = "newLatLngBounds";
  }

  /// Creates a CameraUpdate to move to a specific LatLng point.
  ///
  /// Parameters:
  /// - [latLng]: The new LatLng to move the camera to.
  ///
  /// Returns:
  /// A `CameraUpdate` for the new LatLng.
  static CameraUpdate newLatLng(LatLng latLng) {
    return _LatLngUpdate(
      latLng,
    ).._type = "newLatLng";
  }

  /// Creates a CameraUpdate to zoom to a specific zoom level.
  ///
  /// Parameters:
  /// - [zoom]: The zoom level to set.
  ///
  /// Returns:
  /// A `CameraUpdate` for the new zoom level.
  static CameraUpdate zoomTo(double zoom) {
    return _ZoomUpdate(
      zoom,
    ).._type = "zoomTo";
  }

  /// Creates a CameraUpdate to zoom by a specific amount.
  ///
  /// Parameters:
  /// - [by]: The amount by which to zoom.
  ///
  /// Returns:
  /// A `CameraUpdate` to zoom by the specified amount.
  static CameraUpdate zoomBy(double by) {
    return _ZoomUpdate(
      by,
    ).._type = "zoomBy";
  }
}
