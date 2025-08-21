import 'package:naxalibre/naxalibre.dart' hide Feature, GeoJson;

import '../models/geojson.dart';

class VisibleFeaturesHandler {
  VisibleFeaturesHandler._();

  static List<Feature> filter(GeoJson geoJson, LatLngBounds bounds) {
    // South-West Coordinate of the bound
    final southwest = List<double>.from([
      bounds.southwest.latitude,
      bounds.southwest.longitude,
    ]);

    // North-West coordinate of bounds
    final northeast = List<double>.from([
      bounds.northeast.latitude,
      bounds.northeast.longitude,
    ]);

    // List of visible features
    final visibleFeatures = List<Feature>.empty(growable: true);

    // Checking if feature is with in the visible bounds
    // And filtering out these features
    for (final feature in geoJson.features) {
      // Getting the feature geometry and it's type
      final geometry = feature.geometry;
      final type = geometry?.type.toString().toLowerCase();

      // If type is not point, just continue
      if (type != 'point') continue;

      // Getting the coordinates of the feature geometry
      final coordinates = geometry?.coordinates;

      if (coordinates != null && coordinates.length == 2) {
        final point = List<double>.from([coordinates.last, coordinates.first]);
        final isInBound = _isInBound(point, southwest, northeast);

        if (isInBound) visibleFeatures.add(feature);
      }
    }

    return visibleFeatures;
  }

  /// Method to check if point is in bounds
  ///
  static bool _isInBound(
    List<double> point,
    List<double> southwest,
    List<double> northeast,
  ) {
    return point.first >= southwest.first &&
        point.first <= northeast.first &&
        point.last >= southwest.last &&
        point.last <= northeast.last;
  }
}
