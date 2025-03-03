import '../models/latlng_bounds.dart';
import '../models/tileset.dart';
import '../models/latlng_quad.dart';

part 'geojson_source.dart';
part 'image_source.dart';
part 'raster_source.dart';
part 'raster_dem_source.dart';
part 'source_properties.dart';
part 'vector_source.dart';

/// An abstract class representing a generic map source.
///
/// The `Source` class serves as the base class for all map data sources.
/// It provides properties and methods that are common to different types of map sources.
///
abstract class Source<T> {
  /// A unique identifier for the source.
  ///
  /// This `sourceId` is used to reference the source in map-related operations.
  final String sourceId;

  /// An optional URL pointing to the source file.
  ///
  /// This can be a URL to a TileJSON resource. Supported protocols are:
  /// - `http:`
  /// - `https:`
  /// - `mapbox://<Tileset ID>`
  ///
  /// Example:
  /// ```dart
  /// final source = TileSource(
  ///   sourceId: 'my-tileset',
  ///   url: 'https://example.com/tileset.json',
  /// );
  /// print(source.url);
  /// ```
  final String? url;

  /// Source-specific properties.
  ///
  /// This is a generic property, allowing the `Source` class to be extended
  /// for different types of map sources with their own specific properties.
  final T? sourceProperties;

  /// Constructs a `Source` instance.
  ///
  /// - [sourceId]: A required unique identifier for the source.
  /// - [url]: An optional URL pointing to a TileJSON resource.
  /// - [sourceProperties]: Optional source-specific properties.
  ///
  /// Example:
  /// ```dart
  /// final source = MyCustomSource(
  ///   sourceId: 'custom-source',
  ///   url: 'https://example.com/data.json',
  ///   sourceProperties: MyCustomProperties(...),
  /// );
  /// print(source.sourceId);
  /// ```
  Source({
    required this.sourceId,
    this.url,
    this.sourceProperties,
  });

  /// Converts the `Source` object to a `Map` for platform-specific usage.
  ///
  /// This method should be overridden by subclasses to provide a map representation
  /// of the specific source type and its properties.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` representing the source.
  /// - `null` if the source has no properties to map.
  ///
  /// Example:
  /// ```dart
  /// final map = source.toMap();
  /// print(map?['sourceId']); // Outputs: custom-source
  /// ```
  Map<String, Object?> toArgs();
}
