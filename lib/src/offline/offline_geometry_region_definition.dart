part of 'offline_region_definition.dart';

/// A concrete implementation of [OfflineRegionDefinition] that defines
/// a custom-shaped geographic area for offline map downloads.
///
/// This class is used when an offline region is based on a **geometry**
/// (e.g., polygon, multi-polygon) rather than a rectangular bounding box.
class OfflineGeometryRegionDefinition extends OfflineRegionDefinition {
  /// The geometry that defines the offline region.
  ///
  /// This can be a **polygon, multi-polygon, or line geometry** that specifies
  /// the area for offline tile downloads.
  final Geometry geometry;

  /// Getter for the type of the OfflineRegionDefinition.
  @override
  String? get type => "shaperegion";

  /// Creates an instance of [OfflineGeometryRegionDefinition].
  ///
  /// This constructor allows customization of offline map settings, including:
  /// - The region's **geometry** (mandatory).
  /// - The **style Url** of the map (optional).
  /// - The **zoom levels** defining the detail range (default: `0` to `20`).
  /// - The **device pixel ratio** for adjusting tile quality.
  /// - Whether to include **ideographs** in fonts.
  ///
  /// Example:
  /// ```dart
  /// OfflineGeometryRegionDefinition(
  ///   geometry: Geometry.polygon([
  ///     LatLng(37.7749, -122.4194),
  ///     LatLng(37.8049, -122.3894),
  ///     LatLng(37.7649, -122.4094),
  ///   ]),
  ///   styleUrl: "mapbox://styles/mapbox/streets-v11",
  ///   maxZoom: 16.0,
  ///   minZoom: 10.0,
  ///   pixelRatio: 2.0,
  ///   includeIdeographs: true,
  /// )
  /// ```
  OfflineGeometryRegionDefinition({
    required this.geometry,
    super.styleUrl,
    super.maxZoom = 20,
    super.minZoom = 0,
    super.pixelRatio,
    super.includeIdeographs = true,
  });

  /// Converts this [OfflineGeometryRegionDefinition] instance into a map of arguments.
  ///
  /// This method is useful for serializing the object when passing
  /// data between different components of the application.
  ///
  /// Returns a `Map<String, dynamic>` representation of the object.
  @override
  Map<String, dynamic> toArgs() {
    return {
      'geometry': geometry.toArgs(),
      'styleUrl': styleUrl,
      'maxZoom': maxZoom,
      'minZoom': minZoom,
      'pixelRatio': pixelRatio,
      'includeIdeographs': includeIdeographs,
    };
  }

  /// Creates an instance of [OfflineGeometryRegionDefinition] from a map of arguments.
  ///
  /// This factory method reconstructs an instance from a serialized
  /// map representation, typically received from a method channel or
  /// local storage.
  ///
  /// - `args['geometry']` must be a valid [Geometry] map.
  /// - `args['maxZoom']` and `args['minZoom']` are converted to `double`.
  /// - `args['pixelRatio']` is converted to `double` (default: `1.0`).
  /// - `args['includeIdeographs']` is expected to be a `bool`.
  ///
  /// Throws an exception if required parameters are missing or invalid.
  factory OfflineGeometryRegionDefinition.fromArgs(Map<String, dynamic> args) {
    return OfflineGeometryRegionDefinition(
      geometry: Geometry.fromArgs(
        args['geometry'].map<String, dynamic>(
          (k, v) => MapEntry(k.toString(), v),
        ),
      ),
      styleUrl: args['styleUrl'] as String?,
      maxZoom: (args['maxZoom'] as num).toDouble(),
      minZoom: (args['minZoom'] as num).toDouble(),
      pixelRatio: (args['pixelRatio'] as num?)?.toDouble(),
      includeIdeographs: args['includeIdeographs'] as bool? ?? false,
    );
  }
}
