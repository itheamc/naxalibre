import 'dart:convert';

import 'feature.dart';
import 'feature_collection.dart';
import 'geometry.dart';

/// A class that represents a GeoJSON object.
///
/// This class provides multiple factory constructors to create a GeoJSON
/// representation from different data sources, including JSON maps,
/// strings, and feature collections.
class GeoJson {
  /// The raw GeoJSON data as a string or url.
  final String data;

  /// Private constructor to initialize the GeoJSON data.
  GeoJson._(this.data);

  /// Creates a [GeoJson] instance from a raw GeoJSON string.
  ///
  /// This constructor converts the given GeoJSON string to GeoJson.
  factory GeoJson.fromJsonString(String data) {
    return GeoJson._(data);
  }

  /// Creates a [GeoJson] instance from a JSON map.
  ///
  /// This constructor converts the given JSON [Map] to a GeoJSON string.
  factory GeoJson.fromJson(Map<String, dynamic> json) {
    return GeoJson._(jsonEncode(json));
  }

  /// Creates a [GeoJson] instance from a single [Geometry].
  ///
  /// The feature is converted into a `FeatureCollection` before being
  /// encoded as a GeoJSON string.
  factory GeoJson.fromGeometry(Geometry geometry) {
    final collection = FeatureCollection.fromFeature(
      feature: Feature.fromGeometry(geometry),
    );
    return GeoJson._(jsonEncode(collection.toArgs()));
  }

  /// Creates a [GeoJson] instance from a single [Feature].
  ///
  /// The feature is converted into a `FeatureCollection` before being
  /// encoded as a GeoJSON string.
  factory GeoJson.fromFeature(Feature feature) {
    final collection = FeatureCollection.fromFeature(feature: feature);
    return GeoJson._(jsonEncode(collection.toArgs()));
  }

  /// Creates a [GeoJson] instance from a list of [Feature] objects.
  ///
  /// The features are wrapped in a `FeatureCollection` and then
  /// converted into a GeoJSON string.
  factory GeoJson.fromFeatures(List<Feature> features) {
    final collection = FeatureCollection.fromFeatures(features: features);
    return GeoJson._(jsonEncode(collection.toArgs()));
  }

  /// Creates a [GeoJson] instance from an existing [FeatureCollection].
  ///
  /// This constructor directly encodes the feature collection into
  /// a GeoJSON string.
  factory GeoJson.fromFeatureCollection(FeatureCollection collection) {
    return GeoJson._(jsonEncode(collection.toArgs()));
  }
}
