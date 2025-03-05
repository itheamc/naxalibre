part of 'source.dart';

/// Represents a GeoJSON data source for use in a map.
///
/// This class allows you to specify a GeoJSON source either via a URL or inline GeoJSON data.
class GeoJsonSource extends Source<GeoJsonSourceProperties> {
  /// A string representing the GeoJSON data.
  ///
  /// This can be [GeoJson] object containing either a URL pointing to a GeoJSON file or inline GeoJSON data.
  ///
  /// One of [geoJson] or [url] must be provided.
  final GeoJson? geoJson;

  /// Creates a [GeoJsonSource] instance.
  ///
  /// - [sourceId]: A unique identifier for the GeoJSON source (required).
  /// - [url]: An optional URL pointing to a GeoJSON file.
  /// - [geoJson]: An optional GeoJson data object containing either a feature collection pointing to a GeoJSON file or inline GeoJSON data.
  /// - [sourceProperties]: Properties associated with the source, defaulting to [GeoJsonSourceProperties.defaultProperties].
  ///
  /// Throws an [AssertionError] if neither [geoJson] nor [url] is provided.
  ///
  /// Example:
  /// ```dart
  /// final geoJsonSource = GeoJsonSource(
  ///   sourceId: "geojson-source",
  ///   data: '{"type": "FeatureCollection", "features": [...]}',
  ///   sourceProperties: GeoJsonSourceProperties(...),
  /// );
  /// print('GeoJSON Source ID: ${geoJsonSource.sourceId}');
  /// ```
  GeoJsonSource({
    required super.sourceId,
    super.url,
    this.geoJson,
    super.sourceProperties,
  }) : assert(
         geoJson != null || url != null,
         "Please provide geoJson data or url for geoJson data",
       );

  /// Converts the [GeoJsonSource] instance to a map for use in platform-specific implementations.
  ///
  /// The returned map includes:
  /// - `"sourceId"`: The unique identifier for the source.
  /// - `"data"`: The inline GeoJSON data, if available.
  /// - `"url"`: The URL to the GeoJSON file, if available.
  /// - `"sourceProperties"`: A map of source properties, defaulting to [GeoJsonSourceProperties.defaultProperties] if not specified.
  ///
  /// Returns `null` if the resulting map would be empty.
  ///
  /// Example:
  /// ```dart
  /// final geoJsonSource = GeoJsonSource(
  ///   sourceId: "geojson-source",
  ///   data: '{"type": "FeatureCollection", "features": [...]}',
  /// );
  /// final sourceMap = geoJsonSource.toArgs();
  /// print(sourceMap);
  /// ```
  @override
  Map<String, dynamic> toArgs() {
    final args = <String, dynamic>{};

    // Adding source type
    args["type"] = "geojson";

    // Creating map for details data
    final details = <String, dynamic>{};

    // Add id to the source
    details["id"] = sourceId;

    // Add data to the details if not null
    if (geoJson != null) {
      details["data"] = geoJson?.data;
    }

    // Add url to the details if not null
    if (url != null) {
      details["url"] = url;
    }

    // Add properties to the details
    details['properties'] =
        (sourceProperties ?? GeoJsonSourceProperties.defaultProperties)
            .toArgs();

    // Add details to the args
    args["details"] = details;

    return args;
  }
}

/// GeoJsonSourceProperties Class
///
class GeoJsonSourceProperties extends SourceProperties {
  /// Minimum zoom level at which to create vector tiles
  /// (higher means greater detail at high zoom
  /// Default value is 0
  final int? minZoom;

  /// Maximum zoom level at which to create vector tiles
  /// (higher means greater detail at high zoom
  /// Default value is 18
  final int? maxZoom;

  /// Size of the tile buffer on each side. A value of 0 produces no buffer.
  /// A value of 512 produces a buffer as wide as the tile itself.
  /// Larger values produce fewer rendering artifacts near tile edges
  /// and slower performance.
  /// Default value is 128
  final int? buffer;

  /// Douglas-Peucker simplification tolerance
  /// (higher means simpler geometries and faster performance).
  /// Default value is 0.375
  final double? tolerance;

  /// If the data is a collection of point features, setting this to true
  /// clusters the points by radius into groups. Cluster groups become
  /// new `Point` features in the source with additional properties:
  /// - `cluster` Is `true` if the point is a cluster
  /// - `cluster_id` A unique id for the cluster to be used in conjunction with the
  /// [cluster inspection methods](https://www.mapbox.com/mapbox-gl-js/api/#geojsonsource#getclusterexpansionzoom)
  /// - `point_count` Number of original points grouped into this cluster
  /// - `point_count_abbreviated` An abbreviated point count
  /// Default value is false
  final bool? cluster;

  /// Radius of each cluster if clustering is enabled.
  /// A value of 512 indicates a radius equal to the width of a tile.
  /// Default value is 50
  final int? clusterRadius;

  /// Max zoom on which to cluster points if clustering is enabled. Defaults
  /// to one zoom less than maxzoom (so that last zoom features are
  /// not clustered). Clusters are re-evaluated at integer zoom levels so
  /// setting clusterMaxZoom to 14 means the clusters will be displayed
  /// until z15.
  final int? clusterMaxZoom;

  /// Whether to calculate line distance metrics. This is required for
  /// line layers that specify `line-gradient` values.
  /// Default value is false
  final bool? lineMetrics;

  /// Constructor
  GeoJsonSourceProperties({
    this.minZoom,
    this.maxZoom,
    this.buffer,
    this.tolerance,
    this.cluster,
    this.clusterRadius,
    this.clusterMaxZoom,
    this.lineMetrics,
  });

  /// Getter for defaultGeoJonSourceProperties
  static SourceProperties get defaultProperties {
    return GeoJsonSourceProperties(
      cluster: false,
      clusterMaxZoom: 14,
      clusterRadius: 50,
    );
  }

  /// Method to convert GeoJsonSourceProperties object to map
  @override
  Map<String, Object?>? toArgs() {
    final args = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) args[key] = value;
    }

    addIfNotNull("minzoom", minZoom);
    addIfNotNull("maxzoom", maxZoom);
    addIfNotNull("buffer", buffer);
    addIfNotNull("lineMetrics", lineMetrics);
    addIfNotNull("tolerance", tolerance);
    addIfNotNull("cluster", cluster);
    addIfNotNull("clusterRadius", clusterRadius);
    addIfNotNull("clusterMaxZoom", clusterMaxZoom);

    return args.isNotEmpty ? args : null;
  }
}
