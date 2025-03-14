import '../models/latlng_bounds.dart';
import '../models/geometry.dart';

part 'offline_geometry_region_definition.dart';

part 'offline_tile_pyramid_region_definition.dart';

/// An abstract class defining the parameters for an offline region,
/// specifying the area and settings for offline map downloads.
///
/// This class serves as the base for different types of offline region
/// definitions, such as tile-based regions and geometry-based regions.
abstract class OfflineRegionDefinition {
  /// The style URL of the map for the offline region.
  ///
  /// This determines the visual appearance of the map, including
  /// layers, colors, and other styling options. If `null`, the default
  /// style of the map will be used.
  final String? styleUrl;

  /// The maximum zoom level for the offline region.
  ///
  /// Defines the highest level of detail available in the downloaded
  /// offline tiles. The default value is `20`.
  final double maxZoom;

  /// The minimum zoom level for the offline region.
  ///
  /// Defines the lowest level of detail available in the offline tiles.
  /// The default value is `0`, meaning the map can be zoomed out fully.
  final double minZoom;

  /// The pixel ratio of the offline tiles, usually based on device density.
  ///
  /// This helps determine the quality of downloaded tiles, ensuring that
  /// the map appears sharp on high-DPI screens.
  final double? pixelRatio;

  /// Whether to include ideographs in downloaded fonts.
  ///
  /// Setting this to `false` may reduce storage size by excluding
  /// ideographic characters, which are common in languages such as Chinese, Japanese, and Korean.
  /// Default is true
  final bool includeIdeographs;

  /// Getter for the type of the OfflineRegionDefinition.
  ///
  /// ("tileregion", "shaperegion")
  ///
  String? get type;

  /// Creates an instance of [OfflineRegionDefinition].
  ///
  /// This constructor initializes the offline region definition with
  /// the provided values. If a value is not specified, it defaults to:
  /// - `maxZoom` = `20`
  /// - `minZoom` = `0`
  OfflineRegionDefinition({
    this.styleUrl,
    this.maxZoom = 20,
    this.minZoom = 0,
    this.pixelRatio,
    this.includeIdeographs = true,
  });

  /// Converts this [OfflineRegionDefinition] instance into a map of arguments.
  ///
  /// This method is useful for serialization when passing data
  /// between different parts of the application.
  Map<String, dynamic> toArgs();

  /// Creates an instance of [OfflineRegionDefinition] from a map of arguments.
  ///
  /// This factory method determines whether the given arguments correspond to
  /// a tile-based offline region or a geometry-based offline region and
  /// returns the appropriate instance.
  ///
  /// - If the `bounds` key exists, it creates an [OfflineTilePyramidRegionDefinition].
  /// - If the `geometry` key exists, it creates an [OfflineGeometryRegionDefinition].
  ///
  /// Throws an [Exception] if the arguments do not match any known region type.
  factory OfflineRegionDefinition.fromArgs(Map<String, dynamic> args) {
    if (args.containsKey('bounds')) {
      return OfflineTilePyramidRegionDefinition.fromArgs(args);
    }

    if (args.containsKey('geometry')) {
      return OfflineGeometryRegionDefinition.fromArgs(args);
    }

    throw Exception('Invalid offline region definition');
  }
}
