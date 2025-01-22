import 'package:naxalibre/src/models/latlng.dart';

/// A class for bounding box (bbox) i.e. [LatLngBounds]
///
class LatLngBounds {
  /// [southwest] – represents the bottom left corner of the bounding box
  /// when the camera is pointing due north
  ///
  final LatLng southwest;

  /// [northeast] – represents the top right corner of the bounding box
  /// when the camera is pointing due north
  ///
  final LatLng northeast;

  /// Method to create bounding box from the points
  /// [northeast] – represents the top right corner of the bounding box
  /// when the camera is pointing due north
  /// [northeast] – represents the top right corner of the bounding box
  /// when the camera is pointing due north
  ///
  const LatLngBounds({
    required this.southwest,
    required this.northeast,
  });

  /// Factory constructor method to create [LatLngBounds] from the LatLongs
  /// [west] – the left side of the bounding box when
  /// the map is facing due north
  /// [south] – the bottom side of the bounding box when
  /// the map is facing due north
  /// [east] – the right side of the bounding box when
  /// the map is facing due north
  /// [north] – the top side of the bounding box when
  /// the map is facing due north
  ///
  factory LatLngBounds.fromLatLongs(
    double west,
    double south,
    double east,
    double north,
  ) {
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  /// Factory constructor to create [LatLngBounds] from the args
  /// [bbox] – the list of latitude and longitude containing southwest and
  /// northeast coordinates.
  /// It must contain exactly 4 elements: [west, south, east, north]
  ///
  factory LatLngBounds.fromArgs(dynamic args) {
    if (args is! List || args.length != 4) {
      throw ArgumentError(
          'bbox must contain exactly 4 elements: [west, south, east, north]');
    }
    final west = args[0];
    final south = args[1];
    final east = args[2];
    final north = args[3];

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  /// Factory constructor to create [LatLngBounds] from the bounding box
  /// [bbox] – the list of latitude and longitude containing southwest and
  /// northeast coordinates.
  /// It must contain exactly 4 elements: [west, south, east, north]
  ///
  factory LatLngBounds.fromBBox(List<double> bbox) {
    if (bbox.length != 4) {
      throw ArgumentError(
          'bbox must contain exactly 4 elements: [west, south, east, north]');
    }
    final west = bbox[0];
    final south = bbox[1];
    final east = bbox[2];
    final north = bbox[3];

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  /// Method to convert [LatLngBounds] to map
  ///
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "southwest": southwest.latLngList(),
      "northeast": northeast.latLngList(),
    };
  }

}
