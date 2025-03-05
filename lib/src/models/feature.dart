import 'latlng_bounds.dart';
import 'geometry.dart';

/// Represents a geographic feature with geometry, properties, and optional metadata.
class Feature {
  /// The type of the feature.
  ///
  final String type;

  /// The optional bounding box of the feature.
  ///
  /// This defines the spatial extent of the feature, represented by [LatLngBounds].
  final LatLngBounds? bbox;

  /// The unique identifier of the feature.
  ///
  /// This can be used to distinguish this feature from others.
  final String? id;

  /// The geometric representation of the feature.
  ///
  /// This is stored as a dynamic type, typically in GeoJSON format.
  final Geometry geometry;

  /// The properties associated with the feature.
  ///
  /// This is stored as a dynamic type and can include additional metadata or attributes for the feature.
  final dynamic properties;

  /// A private constructor for creating a [Feature] instance.
  ///
  /// Use the [fromArgs] factory method to create an instance from platform-specific arguments.
  Feature._(this.id, this.geometry, this.bbox, this.properties)
    : type = "Feature";

  /// Creates a [Feature] instance from arguments provided by the native platform.
  ///
  /// The [args] parameter is expected to be a JSON-encoded string that contains:
  /// - `"type"`: The feature type.
  /// - `"bbox"`: The bounding box (optional, currently set to `null`).
  /// - `"id"`: The unique identifier of the feature.
  /// - `"geometry"`: The geometric representation of the feature.
  /// - `"properties"`: The metadata or attributes of the feature.
  ///
  /// Example:
  /// ```dart
  /// final featureArgs = '{"type": "Point", "id": "1", "geometry": {...}, "properties": {...}}';
  /// final feature = Feature.fromArgs(featureArgs);
  /// print('Feature Type: ${feature.type}');
  /// ```
  factory Feature.fromArgs(dynamic args) {
    return Feature._(
      args['id'],
      Geometry.fromArgs(args['geometry']),
      null, // Currently bbox is not decoded
      args['properties'],
    );
  }

  /// Creates a [Feature] instance from the geometry and other given params
  ///
  /// - [geometry]: The geometry object
  /// - [id]: The id of the feature to be created.
  /// - [bbox]: The bounding box.
  /// - [properties]: The metadata or attributes of the feature.
  ///
  factory Feature.fromGeometry(
    Geometry geometry, {
    String? id,
    LatLngBounds? bbox,
    Map<String, dynamic> properties = const {},
  }) {
    return Feature._(id, geometry, bbox, properties);
  }

  /// Converts the [Feature] instance to a map.
  ///
  /// The returned map includes:
  /// - `"id"`: The feature's unique identifier.
  /// - `"type"`: The feature type.
  /// - `"geometry"`: The geometric representation of the feature.
  /// - `"properties"`: The feature's metadata or attributes.
  /// - `"bbox"`: The bounding box, if available.
  ///
  /// Example:
  /// ```dart
  /// final featureMap = feature.toArgs();
  /// print(featureMap);
  /// ```
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "id": id,
      "type": type,
      "geometry": geometry.toArgs(),
      "properties": properties,
      if (bbox != null) "bbox": bbox?.toArgs(),
    };
  }
}
