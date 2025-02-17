/// A class representing a geographic coordinate with optional altitude.
class LatLng {
  /// The latitude of the coordinate.
  final double latitude;

  /// The longitude of the coordinate.
  final double longitude;

  /// The optional altitude of the coordinate, which may be null.
  final double? altitude;

  /// Creates a new `LatLng` instance with the given [latitude] and [longitude].
  ///
  /// Optionally, an [altitude] can be provided.
  ///
  /// Example:
  /// ```dart
  /// const LatLng point = LatLng(27.7172, 85.3240, altitude: 1400);
  /// ```
  const LatLng(
    this.latitude,
    this.longitude, {
    this.altitude,
  });

  /// Creates a `LatLng` instance from a dynamic argument [args].
  ///
  /// The [args] must be a `List` containing at least two elements:
  /// - The first element corresponds to the latitude.
  /// - The second element corresponds to the longitude.
  /// - An optional third element corresponds to the altitude.
  ///
  /// Throws an [ArgumentError] if [args] is not a `List`.
  ///
  /// Example:
  /// ```dart
  /// final LatLng point = LatLng.fromArgs([27.7172, 85.3240, 1400]);
  /// ```
  factory LatLng.fromArgs(dynamic args) {
    if (args is! List || args.length < 2) {
      throw ArgumentError.value("Args is not a valid list");
    }
    return LatLng(
      args[0],
      args[1],
      altitude: args.length > 2 ? args[2] : null,
    );
  }

  /// Returns a list containing the latitude and longitude.
  ///
  /// Example:
  /// ```dart
  /// final LatLng point = LatLng(27.7172, 85.3240);
  /// print(point.latLngList()); // [27.7172, 85.3240]
  /// ```
  List<double> latLngList() {
    return [latitude, longitude, if (altitude != null) altitude!];
  }

  /// Returns a list containing the longitude and latitude.
  ///
  /// Example:
  /// ```dart
  /// final LatLng point = LatLng(27.7172, 85.3240);
  /// print(point.lngLatList()); // [27.7172, 85.3240]
  /// ```
  List<double> lngLatList() {
    return [longitude, latitude, if (altitude != null) altitude!];
  }

  /// Returns a list containing the latitude and longitude for args.
  ///
  /// Example:
  /// ```dart
  /// final LatLng point = LatLng(27.7172, 85.3240);
  /// print(point.toArgs()); // [27.7172, 85.3240]
  /// ```
  List<double> toArgs() {
    return [latitude, longitude, if (altitude != null) altitude!];
  }
}
