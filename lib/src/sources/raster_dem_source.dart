import 'package:naxalibre/naxalibre.dart';

import '../models/tileset.dart';
import '../sources/source.dart';
import '../sources/source_properties.dart';

/// RasterDemSource Class
///
/// This class represents a source for raster Digital Elevation Model (DEM) data.
/// Raster DEM sources are used for storing elevation data on a raster grid,
/// typically in tile-based format. It supports loading tile data from a URL,
/// a list of tile URLs, or a TileSet.

class RasterDemSource extends Source<RasterDemSourceProperties> {
  /// An array of one or more tile source URLs, as specified in the TileJSON spec.
  ///
  /// Each URL can be a template that includes `{z}`, `{x}`, and `{y}` as placeholders
  /// for the corresponding zoom level, x and y coordinates of the tiles.
  final List<String>? tiles;

  /// An optional TileSet to be added to the source.
  ///
  /// A TileSet represents a collection of tiles and their associated metadata.
  final TileSet? tileSet;

  /// Constructor for creating a RasterDemSource instance.
  ///
  /// This constructor requires a unique sourceId and at least one of the following:
  /// a URL, a list of tile URLs, or a TileSet. Additionally, source properties can be
  /// provided, or they will default to RasterDemSourceProperties.
  RasterDemSource({
    required super.sourceId,
    super.url,
    this.tiles,
    this.tileSet,
    super.sourceProperties,
  }) : assert(url != null || tiles != null || tileSet != null,
            "Please provide url or tiles or tile set for raster dem source.");

  /// Method to convert RasterDemSource object into a map representation.
  ///
  /// This method converts the RasterDemSource instance into a map of key-value pairs
  /// suitable for passing to the native platform or for other uses within the
  /// application. If no valid properties are set, it returns null.
  @override
  Map<String, Object?> toArgs() {
    final args = <String, dynamic>{};

    // Adding source type
    args["type"] = "raster-dem";

    // Creating map for details data
    final details = <String, dynamic>{};

    // Add sourceId to the map
    details["id"] = sourceId;

    // Add URL if provided
    if (url != null) {
      details["url"] = url;
    }

    // Add tiles array if provided and not empty
    if (tiles != null && tiles!.isNotEmpty) {
      details["tiles"] = tiles;
    }

    // Add tileSet if provided
    if (tileSet != null) {
      details["tileSet"] = tileSet?.toArgs();
    }

    // Add source properties, or default properties if not provided
    details['properties'] =
        (sourceProperties ?? RasterDemSourceProperties.defaultProperties)
            .toArgs();

    // Add details to the args
    args["details"] = details;

    // Return the map if it's not empty
    return args;
  }
}

/// RasterDemSourceProperties Class
/// Created by Amit Chaudhary, 2022/10/7
class RasterDemSourceProperties extends SourceProperties {
  /// An array containing the longitude and latitude of
  /// the southwest and northeast corners of the source's
  /// bounding box in the following order: [sw.lng, sw.lat, ne.lng, ne.lat].
  /// When this property is included in a source, no tiles outside of
  /// the given bounds are requested by Mapbox GL.
  /// default is <double>[-180.0, -85.051129, 180.0, 85.051129]
  final LatLngBounds? bounds;

  /// Minimum zoom level for which tiles are available, as in the TileJSON spec.
  /// default is 0
  final int? minZoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON spec.
  /// Data from tiles at the max-zoom are used when displaying the map at
  /// higher zoom levels.
  /// default is 22
  final int? maxZoom;

  /// The minimum visual size to display tiles for this layer.
  /// Only configurable for raster layers.
  /// Default value is 512
  final int? tileSize;

  /// The encoding used by this source.
  /// Default is Encoding.mapbox
  final Encoding? encoding;

  /// Contains an attribution to be displayed when the map is shown to a user.
  final String? attribution;

  /// A setting to determine whether a source's tiles are cached locally
  /// default value is false
  final bool? volatile;

  /// When loading a map, if PrefetchZoomDelta is set to any number greater
  /// than 0, the map will first request a tile at zoom level lower than
  /// zoom - delta, but so that the zoom level is multiple of delta, in
  /// an attempt to display a full map at lower resolution as quick as
  /// possible. It will get clamped at the tile source minimum zoom.
  /// The default delta is 4.
  final int? prefetchZoomDelta;

  /// Minimum tile update interval in seconds, which is used to throttle
  /// the tile update network requests. If the given source supports loading
  /// tiles from a server, sets the minimum tile update interval. Update
  /// network requests that are more frequent than the minimum tile update
  /// interval are suppressed.
  /// default is 0.0
  final double? minimumTileUpdateInterval;

  /// When a set of tiles for a current zoom level is being rendered and some
  /// of the ideal tiles that cover the screen are not yet loaded, parent tile
  /// could be used instead. This might introduce unwanted rendering
  /// side-effects, especially for raster tiles that are over-scaled multiple
  /// times. This property sets the maximum limit for how much a parent tile
  /// can be over-scaled.
  final int? maxOverScaleFactorForParentTiles;

  /// For the tiled sources, this property sets the tile requests delay.
  /// The given delay comes in action only during an ongoing animation or
  /// gestures. It helps to avoid loading, parsing and rendering of the
  /// transient tiles and thus to improve the rendering performance,
  /// especially on low-end devices.
  /// default is 0.0
  final double? tileRequestsDelay;

  /// For the tiled sources, this property sets the tile network requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading the transient tiles from the network and thus to avoid redundant network requests. Note that tile-network-requests-delay value is superseded with tile-requests-delay property value, if both are provided.
  /// default is 0.0
  final double? tileNetworkRequestsDelay;

  /// Constructor
  RasterDemSourceProperties({
    this.bounds,
    this.minZoom,
    this.maxZoom,
    this.tileSize,
    this.encoding,
    this.attribution,
    this.volatile,
    this.prefetchZoomDelta,
    this.minimumTileUpdateInterval,
    this.maxOverScaleFactorForParentTiles,
    this.tileRequestsDelay,
    this.tileNetworkRequestsDelay,
  });

  /// Getter for defaultRasterDemSourceProperties
  static SourceProperties get defaultProperties {
    return RasterDemSourceProperties(
      minZoom: 0,
      maxZoom: 22,
      tileSize: 512,
      volatile: false,
    );
  }

  /// Method to convert RasterDemSourceProperties Object to Map
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    // Adding conditions as key-value pairs directly into the map
    var properties = {
      if (bounds != null) "bounds": bounds?.toArgs(),
      if (minZoom != null) "minzoom": minZoom,
      if (maxZoom != null) "maxzoom": maxZoom,
      if (tileSize != null) "tileSize": tileSize,
      if (encoding != null) "encoding": encoding?.name,
      if (attribution != null) "attribution": attribution,
      if (volatile != null) "volatile": volatile,
      if (prefetchZoomDelta != null) "prefetchZoomDelta": prefetchZoomDelta,
      if (minimumTileUpdateInterval != null)
        "minimumTileUpdateInterval": minimumTileUpdateInterval,
      if (maxOverScaleFactorForParentTiles != null)
        "maxOverScaleFactorForParentTiles": maxOverScaleFactorForParentTiles,
    };

    // Adding all properties to the map
    args.addAll(properties);

    return args.isNotEmpty ? args : null;
  }
}
