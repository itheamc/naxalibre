part of 'offline_region_definition.dart';

/// A concrete implementation of [OfflineRegionDefinition] that defines
/// a rectangular geographic area for offline map downloads.
///
/// This class is used to specify a tile-based offline region,
/// where the map tiles are downloaded for a bounded region.
class OfflineTilePyramidRegionDefinition extends OfflineRegionDefinition {
  /// The geographical bounds of the offline region.
  ///
  /// Defines the area for which the offline map tiles should be downloaded.
  /// This is specified using a [LatLngBounds] object, which includes
  /// the southwest and northeast corners of the bounding box.
  final LatLngBounds bounds;

  /// Getter for the type of the OfflineRegionDefinition.
  @override
  String? get type => "tileregion";

  /// Creates an instance of [OfflineTilePyramidRegionDefinition].
  ///
  /// This constructor allows customization of offline map settings, including:
  /// - The region's **geographical bounds** (mandatory).
  /// - The **style URL** of the map (optional).
  /// - The **zoom levels** defining the detail range (default: `0` to `20`).
  /// - The **device pixel ratio** for adjusting tile quality.
  /// - Whether to include **ideographs** in fonts.
  ///
  /// Example:
  /// ```dart
  /// OfflineTilePyramidRegionDefinition(
  ///   bounds: LatLngBounds(
  ///     southwest: LatLng(37.7749, -122.4194),
  ///     northeast: LatLng(37.8049, -122.3894),
  ///   ),
  ///   styleUrl: "mapbox://styles/mapbox/streets-v11",
  ///   maxZoom: 16.0,
  ///   minZoom: 10.0,
  ///   pixelRatio: 2.0,
  ///   includeIdeographs: false,
  /// )
  /// ```
  OfflineTilePyramidRegionDefinition({
    required this.bounds,
    super.styleUrl,
    super.maxZoom = 20,
    super.minZoom = 0,
    super.pixelRatio,
    super.includeIdeographs = true,
  });

  /// Converts this [OfflineTilePyramidRegionDefinition] instance into a map of arguments.
  ///
  /// This method is useful for serializing the object when passing
  /// data between different components of the application.
  ///
  /// Returns a `Map<String, dynamic>` representation of the object.
  @override
  Map<String, dynamic> toArgs() {
    return {
      'bounds': bounds.toArgs(),
      'styleUrl': styleUrl,
      'maxZoom': maxZoom,
      'minZoom': minZoom,
      'pixelRatio': pixelRatio,
      'includeIdeographs': includeIdeographs,
    };
  }

  /// Creates an instance of [OfflineTilePyramidRegionDefinition] from a map of arguments.
  ///
  /// This factory method reconstructs an instance from a serialized
  /// map representation, typically received from a method channel or
  /// local storage.
  ///
  /// - `args['bounds']` must be a valid [LatLngBounds] map.
  /// - `args['maxZoom']` and `args['minZoom']` are converted to `double`.
  /// - `args['pixelRatio']` is converted to `double` (default: `1.0`).
  /// - `args['includeIdeographs']` is expected to be a `bool`.
  ///
  /// Throws an exception if required parameters are missing or invalid.
  factory OfflineTilePyramidRegionDefinition.fromArgs(
    Map<String, dynamic> args,
  ) {
    return OfflineTilePyramidRegionDefinition(
      bounds: LatLngBounds.fromArgs(args['bounds']),
      styleUrl: args['styleUrl'] as String?,
      maxZoom: (args['maxZoom'] as num).toDouble(),
      minZoom: (args['minZoom'] as num).toDouble(),
      pixelRatio: (args['pixelRatio'] as num?)?.toDouble(),
      includeIdeographs: args['includeIdeographs'] as bool? ?? false,
    );
  }
}
