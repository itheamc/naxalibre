part of 'source.dart';

/// [RasterSource] Class
///
/// This class represents a Raster source in a mapping application, which can be
/// either a tile-based source or a source from a TileSet. It defines how raster
/// data is sourced, and provides methods to convert the object to a map for
/// further use in the application or native platform.

class RasterSource extends Source<RasterSourceProperties> {

  /// An optional TileSet to be added to the source.
  ///
  /// A TileSet represents a collection of tiles and their associated metadata.
  final TileSet? tileSet;

  /// Constructor for creating a RasterSource instance.
  ///
  /// This constructor requires a unique sourceId and at least one of the following:
  /// a URL or a TileSet. Additionally, source properties can be
  /// provided, or they will default to RasterSourceProperties.
  RasterSource({
    required super.sourceId,
    super.url,
    this.tileSet,
    super.sourceProperties,
  }) : assert(
         url != null || tileSet != null,
         "Please provide url or tile set for raster source.",
       );

  /// Method to convert RasterSource object into a map representation.
  ///
  /// This method converts the RasterSource instance into a map of key-value pairs
  /// suitable for passing to the native platform or for other uses within the
  /// application. If no valid properties are set, it returns null.
  @override
  Map<String, Object?> toArgs() {
    final args = <String, dynamic>{};

    // Adding source type
    args["type"] = "raster";

    // Creating map for details data
    final details = <String, dynamic>{};

    // Add sourceId to the map
    details["id"] = sourceId;

    // Add URL if provided
    if (url != null) {
      details["url"] = url;
    }

    // Add tileSet if provided
    if (tileSet != null) {
      details["tileSet"] = tileSet?.toArgs();
    }

    // Add source properties, or default properties if not provided
    details['properties'] =
        (sourceProperties ?? RasterSourceProperties.defaultProperties).toArgs();

    // Add details to the args
    args["details"] = details;

    // Return the map if it's not empty
    return args;
  }
}

/// RasterSourceProperties Class
///
class RasterSourceProperties extends SourceProperties {
  /// An array containing the longitude and latitude of
  /// the southwest and northeast corners of the source's
  /// bounding box in the following order: [sw.lng, sw.lat, ne.lng, ne.lat].
  /// When this property is included in a source, no tiles outside of
  /// the given bounds are requested by Mapbox GL.
  /// default is [-180.0, -85.051129, 180.0, 85.051129]
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

  /// Influences the y direction of the tile coordinates.
  /// The global-mercator (aka Spherical Mercator) profile is assumed.
  /// default is Scheme.xyz
  final Scheme? scheme;

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

  /// Constructor
  RasterSourceProperties({
    this.bounds,
    this.minZoom,
    this.maxZoom,
    this.tileSize,
    this.scheme,
    this.attribution,
    this.volatile,
    this.prefetchZoomDelta,
    this.minimumTileUpdateInterval,
    this.maxOverScaleFactorForParentTiles,
  });

  /// Getter for defaultRasterSourceProperties
  static SourceProperties get defaultProperties {
    return RasterSourceProperties(
      scheme: Scheme.xyz,
      maxZoom: 22,
      tileSize: 512,
      volatile: false,
    );
  }

  /// Method to convert RasterSourceProperties Object to Map
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    // Adding conditions as key-value pairs directly into the map
    var properties = {
      if (bounds != null) "bounds": bounds?.toArgs(),
      if (minZoom != null) "minzoom": minZoom,
      if (maxZoom != null) "maxzoom": maxZoom,
      if (tileSize != null) "tileSize": tileSize,
      if (scheme != null) "scheme": scheme?.name,
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
