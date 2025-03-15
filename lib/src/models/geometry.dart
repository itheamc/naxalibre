import 'dart:convert';

/// An abstract class representing a geometric shape or structure.
///
/// This class serves as a base for defining various geometric shapes
/// and provides a common interface for serializing them into a map.
class Geometry {
  /// The type of the geometric shape (e.g., "Point", "LineString", " "Polygon" and "MultiPolygon".).
  final String type;

  /// The coordinates of the geometric shape.
  ///
  final dynamic coordinates;

  /// Constructor for the [Geometry] class.
  ///
  /// Parameters:
  /// - [type]: A string representing the type of the geometric shape.
  Geometry._(this.type, this.coordinates);

  /// Factory constructor for creating a [Point] geometry.
  ///
  /// This factory creates a [Geometry] object of type "Point" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<double>` representing the [x, y] coordinates of the point.
  ///
  /// Returns:
  /// A [Geometry] object of type "Point".
  factory Geometry.point({required List<double> coordinates}) {
    return Geometry._('Point', coordinates);
  }

  /// Factory constructor for creating a [MultiPoint] geometry.
  ///
  /// This factory creates a [Geometry] object of type "MultiPoint" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<List<double>>` representing the list of points in the multi point geometry.
  ///
  /// Returns:
  /// A [Geometry] object of type "MultiPoint".
  factory Geometry.multiPoint({required List<List<double>> coordinates}) {
    return Geometry._('MultiPoint', coordinates);
  }

  /// Factory constructor for creating a [LineString] geometry.
  ///
  /// This factory creates a [Geometry] object of type "LineString" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<List<double>>` representing the list of points in the line string.
  ///
  /// Returns:
  /// A [Geometry] object of type "LineString".
  factory Geometry.lineString({required List<List<double>> coordinates}) {
    return Geometry._('LineString', coordinates);
  }

  /// Factory constructor for creating a [MultiLineString] geometry.
  ///
  /// This factory creates a [Geometry] object of type "MultiLineString" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<List<List<double>>>` representing the list of rings in the multi line string.
  ///
  /// Returns:
  /// A [Geometry] object of type "MultiLineString".
  factory Geometry.multiLineString({
    required List<List<List<double>>> coordinates,
  }) {
    return Geometry._('MultiLineString', coordinates);
  }

  /// Factory constructor for creating a [Polygon] geometry.
  ///
  /// This factory creates a [Geometry] object of type "Polygon" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<List<List<double>>>` representing the list of rings in the polygon.
  ///
  /// Returns:
  /// A [Geometry] object of type "Polygon".
  factory Geometry.polygon({required List<List<List<double>>> coordinates}) {
    return Geometry._('Polygon', coordinates);
  }

  /// Factory constructor for creating a [MultiPolygon] geometry.
  ///
  /// This factory creates a [Geometry] object of type "MultiPolygon" with the provided coordinates.
  ///
  /// Parameters:
  /// - [coordinates]: A `List<List<List<List<double>>>>` representing multiple polygons,
  ///   where each polygon is a list of rings, and each ring is a list of points.
  ///
  /// Returns:
  /// A [Geometry] object of type "MultiPolygon".
  factory Geometry.multiPolygon({
    required List<List<List<List<double>>>> coordinates,
  }) {
    return Geometry._('MultiPolygon', coordinates);
  }

  /// Converts the [Geometry] object into a serialized map representation.
  ///
  /// This method is intended to be implemented by subclasses to provide
  /// a way to serialize the geometric shape and its properties into a map.
  ///
  /// Returns:
  /// A `Map` containing the serialized properties of the geometry.
  Map<String, Object?> toArgs() {
    return {'type': type, 'coordinates': coordinates};
  }

  /// Creates a [Geometry] object from a serialized JSON representation.
  ///
  /// This factory method serves as an entry point for deserializing a JSON map
  /// into a specific geometric shape. It delegates the deserialization process
  /// to `Geometry.fromArgs`, allowing subclasses to define their own
  /// deserialization logic.
  ///
  /// ### Parameters:
  /// - [json]: A key-value map containing the serialized
  ///   properties of a geometric shape, including its type and coordinates.
  ///
  /// ### Returns:
  /// A [Geometry] instance corresponding to the deserialized geometric shape.
  ///
  /// ### Throws:
  /// - [UnsupportedError] if the `type` field in the JSON map is unrecognized or
  ///   does not correspond to a known geometry type.
  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry.fromArgs(json);
  }

  /// Creates a [Geometry] object from a serialized JSON string representation.
  ///
  /// This factory method parses a JSON string into a map / dictionary and
  /// then delegates the deserialization process to `Geometry.fromArgs()`.
  ///
  /// ### Parameters:
  /// - [jsonString] (`String`): A string containing the serialized JSON representation
  ///   of a geometric shape. It must be a valid JSON object.
  ///
  /// ### Returns:
  /// A [Geometry] instance corresponding to the deserialized geometric shape.
  ///
  /// ### Throws:
  /// - [UnsupportedError] if the input string is not a valid Geometry Json object or does not
  ///   adhere to the expected GeoJSON format.
  factory Geometry.fromJsonString(String jsonString) {
    if (jsonString.startsWith('{') && jsonString.endsWith('}')) {
      return Geometry.fromArgs(jsonDecode(jsonString));
    }

    throw UnsupportedError('Invalid Geometry GeoJson format: $jsonString');
  }

  /// Creates a [Geometry] object from a serialized map representation.
  ///
  /// This factory method is intended to be implemented by subclasses to provide
  /// a way to deserialize a map into a specific geometric shape.
  ///
  /// Parameters:
  /// - [args]: A dictionary (map) containing the serialized properties of the geometry.
  ///
  /// Returns:
  /// A [Geometry] object representing the deserialized geometric shape.
  ///
  /// Throws:
  /// - [UnsupportedError] if the `type` in the map does not match any known geometry type.
  static Geometry fromArgs(dynamic args) {
    final type = args['type'];
    final coordinatesArgs = args['coordinates'];

    switch (type) {
      case 'Point':
        return Geometry.point(
          coordinates:
              (coordinatesArgs as List)
                  .map((e) => (e as num).toDouble())
                  .toList(),
        );
      case 'MultiPoint':
        return Geometry.multiPoint(
          coordinates:
              (coordinatesArgs as List)
                  .map(
                    (e) =>
                        (e as List)
                            .map((e1) => (e1 as num).toDouble())
                            .toList(),
                  )
                  .toList(),
        );
      case 'LineString':
        return Geometry.lineString(
          coordinates:
              (coordinatesArgs as List)
                  .map(
                    (e) =>
                        (e as List)
                            .map((e1) => (e1 as num).toDouble())
                            .toList(),
                  )
                  .toList(),
        );
      case 'MultiLineString':
        return Geometry.multiLineString(
          coordinates:
              (coordinatesArgs as List)
                  .map(
                    (e) =>
                        (e as List)
                            .map(
                              (e1) =>
                                  (e1 as List)
                                      .map((e2) => (e2 as num).toDouble())
                                      .toList(),
                            )
                            .toList(),
                  )
                  .toList(),
        );
      case 'Polygon':
        return Geometry.polygon(
          coordinates:
              (coordinatesArgs as List)
                  .map(
                    (e) =>
                        (e as List)
                            .map(
                              (e1) =>
                                  (e1 as List)
                                      .map((e2) => (e2 as num).toDouble())
                                      .toList(),
                            )
                            .toList(),
                  )
                  .toList(),
        );
      case 'MultiPolygon':
        return Geometry.multiPolygon(
          coordinates:
              (coordinatesArgs as List)
                  .map(
                    (e) =>
                        (e as List)
                            .map(
                              (e1) =>
                                  (e1 as List)
                                      .map(
                                        (e2) =>
                                            (e2 as List)
                                                .map(
                                                  (e3) =>
                                                      (e3 as num).toDouble(),
                                                )
                                                .toList(),
                                      )
                                      .toList(),
                            )
                            .toList(),
                  )
                  .toList(),
        );
      default:
        throw UnsupportedError('Unsupported geometry type: $type');
    }
  }
}
