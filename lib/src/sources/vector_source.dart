part of 'source.dart';

/// VectorSource Class
/// Represents a vector data source for rendering map tiles.
///
class VectorSource extends Source<VectorSourceProperties> {
  /// [tileSet] - A TileSet object to add to the source, containing tile configuration details.
  final TileSet? tileSet;

  /// Constructor for the VectorSource class.
  ///
  /// [sourceId] - A unique identifier for the source.
  /// [url] - A URL to a vector tile source.
  /// [tileSet] - A TileSet object containing additional tile configuration.
  /// [sourceProperties] - Optional source-specific properties.
  ///
  /// At least one of [url], [tiles], or [tileSet] must be provided; otherwise,
  /// an assertion error is thrown.
  VectorSource({
    required super.sourceId,
    super.url,
    this.tileSet,
    super.sourceProperties,
  }) : assert(
         url != null || tileSet != null,
         "Please provide url or tile set for vector source.",
       );

  /// Method to convert the `VectorSource` object into a `Map`.
  ///
  /// This method is primarily used for serialization to pass the object
  /// to the native platform.
  ///
  /// Returns a json map containing the VectorSource properties,
  /// or `null` if no properties are set.
  @override
  Map<String, Object?> toArgs() {
    final args = <String, dynamic>{};

    // Adding source type
    args["type"] = "vector";

    // Creating map for details data
    final details = <String, dynamic>{};

    // Add the source ID
    details["id"] = sourceId;

    // Add optional properties if they are set
    if (url != null) {
      details["url"] = url;
    }

    // Add tile set if not null
    if (tileSet != null) {
      details["tileSet"] = tileSet?.toArgs();
    }

    // Add source properties or default properties
    details['properties'] =
        (sourceProperties ?? VectorSourceProperties.defaultProperties).toArgs();

    // Add details to the args
    args['details'] = details;

    return args;
  }
}

/// VectorSourceProperties Class
///
class VectorSourceProperties extends SourceProperties {
  /// An array containing the longitude and latitude of
  /// the southwest and northeast corners of the source's
  /// bounding box in the following order: [sw.lng, sw.lat, ne.lng, ne.lat].
  /// When this property is included in a source, no tiles outside of
  /// the given bounds are requested by Mapbox GL.
  /// default is [-180.0, -85.051129, 180.0, 85.051129]
  final LatLngBounds? bounds;

  /// Influences the y direction of the tile coordinates.
  /// The global-mercator (aka Spherical Mercator) profile is assumed.
  /// default is Scheme.xyz
  final Scheme? scheme;

  /// Minimum zoom level for which tiles are available, as in the TileJSON spec.
  /// default is 0
  final int? minZoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON spec.
  /// Data from tiles at the max-zoom are used when displaying the map at
  /// higher zoom levels.
  /// default is 22
  final int? maxZoom;

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
  VectorSourceProperties({
    this.bounds,
    this.minZoom,
    this.maxZoom,
    this.scheme,
    this.attribution,
    this.volatile,
    this.prefetchZoomDelta,
    this.minimumTileUpdateInterval,
    this.maxOverScaleFactorForParentTiles,
  });

  /// Getter for defaultVectorSourceProperties
  static SourceProperties get defaultProperties {
    return VectorSourceProperties(
      scheme: Scheme.xyz,
      maxZoom: 22,
      volatile: false,
    );
  }

  /// Method to convert VectorSourceProperties object to Map
  @override
  Map<String, dynamic>? toArgs() {
    final args = {
      if (bounds != null) "bounds": bounds?.toArgs(),
      if (minZoom != null) "minzoom": minZoom,
      if (maxZoom != null) "maxzoom": maxZoom,
      if (scheme != null) "scheme": scheme?.name,
      if (attribution != null) "attribution": attribution,
      if (volatile != null) "volatile": volatile,
      if (prefetchZoomDelta != null) "prefetchZoomDelta": prefetchZoomDelta,
      if (minimumTileUpdateInterval != null)
        "minimumTileUpdateInterval": minimumTileUpdateInterval,
      if (maxOverScaleFactorForParentTiles != null)
        "maxOverScaleFactorForParentTiles": maxOverScaleFactorForParentTiles,
    };

    return args.isNotEmpty ? args : null;
  }
}
