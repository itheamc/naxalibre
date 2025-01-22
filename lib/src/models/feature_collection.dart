import 'latlng_bounds.dart';
import 'feature.dart';

/// Represents a collection of geographic features.
///
/// The [FeatureCollection] class is used to group multiple [Feature] objects
/// into a single collection, often with an optional bounding box ([bbox]) that
/// defines the spatial extent of the features.
class FeatureCollection {
  /// The constant type for all feature collections: "FeatureCollection".
  static const _type = "FeatureCollection";

  /// The type of the feature collection.
  ///
  /// This will always be `"FeatureCollection"`.
  final String type;

  /// A list of geographic features included in the collection.
  final List<Feature> features;

  /// The optional bounding box of the feature collection.
  ///
  /// This represents the spatial extent of the collection, defined by
  /// [LatLngBounds].
  final LatLngBounds? bbox;

  /// A private constructor to create a [FeatureCollection] instance.
  ///
  /// Use the [fromFeatures] factory constructor to create an instance.
  FeatureCollection._(this.type, this.features, [this.bbox]);

  /// Creates a [FeatureCollection] from a list of [Feature] objects.
  ///
  /// - [features]: A required list of [Feature] objects that form the collection.
  /// - [bbox]: An optional [LatLngBounds] defining the bounding box of the collection.
  ///
  /// Example:
  /// ```dart
  /// final feature1 = Feature(...);
  /// final feature2 = Feature(...);
  /// final collection = FeatureCollection.fromFeatures(
  ///   features: [feature1, feature2],
  ///   bbox: LatLngBounds(
  ///     LatLng(27.7, 85.3),
  ///     LatLng(27.8, 85.5),
  ///   ),
  /// );
  /// ```
  factory FeatureCollection.fromFeatures({
    required List<Feature> features,
    LatLngBounds? bbox,
  }) {
    return FeatureCollection._(_type, features, bbox);
  }

  /// Converts the [FeatureCollection] to a `Map` representation.
  ///
  /// The returned map contains:
  /// - `"type"`: The type of the feature collection (always `"FeatureCollection"`).
  /// - `"features"`: A list of feature maps created by calling [Feature.toArgs].
  /// - `"bbox"`: The bounding box as a map, if present.
  ///
  /// Example:
  /// ```dart
  /// final collectionMap = collection.toMap();
  /// print(collectionMap);
  /// ```
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "type": type,
      "features": features.map((e) => e.toArgs()).toList(),
      "bbox": bbox?.toArgs(),
    };
  }
}
