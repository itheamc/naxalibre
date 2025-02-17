import 'feature.dart';

/// Represents a feature returned from a query on a map.
///
/// A [QueriedFeature] contains details about the feature source, source layer,
/// feature properties, and its state.
class QueriedFeature {
  /// The source ID for the queried feature.
  ///
  /// This identifies the map source where the feature originates.
  final String source;

  /// The source layer ID for the queried feature.
  ///
  /// This is applicable only if the source supports layers (e.g., vector tile layers).
  /// It will be `null` for sources that do not support layers, such as GeoJSON sources.
  final String? sourceLayer;

  /// The feature returned by the query.
  ///
  /// This is represented as a [Feature] object.
  final Feature feature;

  /// The state of the queried feature.
  ///
  /// This can contain additional dynamic properties specific to the queried feature.
  final dynamic state;

  /// Creates a [QueriedFeature] instance.
  ///
  /// - [source]: The source ID for the feature (required).
  /// - [sourceLayer]: The optional source layer ID if the source supports layers.
  /// - [feature]: The feature returned by the query (required).
  /// - [state]: The dynamic state associated with the feature.
  ///
  /// Example:
  /// ```dart
  /// final queriedFeature = QueriedFeature(
  ///   source: "composite",
  ///   sourceLayer: "layer-1",
  ///   feature: Feature(...),
  ///   state: {"hovered": true},
  /// );
  /// print('Source: ${queriedFeature.source}');
  /// ```
  QueriedFeature({
    required this.source,
    this.sourceLayer,
    required this.feature,
    this.state,
  });

  /// Creates a [QueriedFeature] from arguments returned by the native platform.
  ///
  /// The [args] parameter is expected to be a map containing:
  /// - `"source"`: The source ID of the queried feature.
  /// - `"sourceLayer"`: The source layer ID (optional).
  /// - `"feature"`: The feature details (converted to a [Feature] object).
  /// - `"state"`: A JSON-encoded string representing the feature's state.
  ///
  /// Example:
  /// ```dart
  /// final args = {
  ///   "source": "composite",
  ///   "sourceLayer": "layer-1",
  ///   "feature": {"type": "Feature", "geometry": {...}, "properties": {...}},
  ///   "state": '{"hovered": true}',
  /// };
  /// final queriedFeature = QueriedFeature.fromArgs(args);
  /// print('Feature: ${queriedFeature.feature}');
  /// ```
  factory QueriedFeature.fromArgs(dynamic args) {
    return QueriedFeature(
      source: args['source'],
      sourceLayer: args['sourceLayer'],
      feature: Feature.fromArgs(args['feature']),
      state: args['state'],
    );
  }

  /// Converts this [QueriedFeature] instance into a map of arguments
  /// suitable for native platform communication.
  ///
  /// This method constructs a map where:
  /// - `"source"`: The source ID of the feature.
  /// - `"sourceLayer"`: The source layer ID (if applicable).
  /// - `"feature"`: The feature details as a map.
  /// - `"state"`: The feature's state.
  ///
  Map<String, dynamic> toArgs() {
    return {
      'source': source,
      'sourceLayer': sourceLayer,
      'feature': feature.toArgs(),
      'state': state,
    };
  }
}
