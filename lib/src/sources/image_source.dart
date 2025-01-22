import 'package:naxalibre/src/models/latlng_quad.dart';

import '../sources/source.dart';
import '../sources/source_properties.dart';

/// ImageSource Class
/// Created by Amit Chaudhary, 2022/10/6
///
/// Represents a source of image data, typically for use with map rendering.
/// It holds information about the image's coordinates (corners) and its properties.
///
/// Properties:
/// - [coordinates] : A list of longitude, latitude pairs specifying the corners
///   of the image in the form of a list of lists: ```LatLngQuad(
///     topLeft,
///     topRight,
///     bottomRight,
///     bottomLeft)```.
/// - [sourceId] : A unique identifier for the source. This is inherited from the
///   `Source` class.
/// - [url] : A URL pointing to the image source file. This is inherited from the
///   `Source` class.
/// - [sourceProperties] : Optional properties associated with the image source,
///   inherited from the `Source` class, which can be customized for this specific
///   source.

class ImageSource extends Source<ImageSourceProperties> {
  /// Corners of image specified in longitude, latitude pairs.
  /// List<List<double>> where each inner list contains the [longitude, latitude] pairs.
  final LatLngQuad coordinates;

  /// Constructor for the ImageSource class.
  ///
  /// [sourceId] - Unique identifier for the source (inherited from the `Source` class).
  /// [url] - The URL pointing to the image source.
  /// [coordinates] - List of coordinates specifying the corners of the image.
  /// [sourceProperties] - Optional properties for customizing the source, inherited
  ///   from the `Source` class.
  ImageSource({
    required super.sourceId,
    required super.url,
    required this.coordinates,
    super.sourceProperties,
  });

  /// Converts the ImageSource object to a Map.
  ///
  /// This method returns a Map<String, dynamic> that can be passed to other systems
  /// (e.g., native platform), and includes the following key-value pairs:
  /// - "sourceId" : The unique identifier for the source.
  /// - "url" : The URL pointing to the image source.
  /// - "coordinates" : The list of coordinates specifying the image's corners.
  /// - "sourceProperties" : The properties of the source, which are provided by
  ///   [ImageSourceProperties.defaultProperties] if not specified.
  @override
  Map<String, Object?> toArgs() {
    final args = <String, dynamic>{};

    // Adding source type
    args["type"] = "image";

    // Creating map for details data
    final details = <String, dynamic>{};

    // Add source id
    details["id"] = sourceId;

    // Add url
    details["url"] = url;

    // Add coordinates
    details["coordinates"] = coordinates.toArgs();

    // Add properties
    details['properties'] =
        (sourceProperties ?? ImageSourceProperties.defaultProperties).toArgs();

    // Add details to the args
    args["details"] = details;

    return args;
  }
}

/// ImageSourceProperties Class
/// Created by Amit Chaudhary, 2022/10/7
class ImageSourceProperties extends SourceProperties {
  /// When loading a map, if PrefetchZoomDelta is set to any number greater
  /// than 0, the map will first request a tile at zoom level lower than
  /// zoom - delta, but so that the zoom level is multiple of delta, in an
  /// attempt to display a full map at lower resolution as quick as possible.
  /// It will get clamped at the tile source minimum zoom.
  /// The default delta is 4.
  final int? prefetchZoomDelta;

  /// Constructor
  ImageSourceProperties({
    this.prefetchZoomDelta,
  });

  /// Getter for defaultImageSourceProperties
  static SourceProperties get defaultProperties {
    return ImageSourceProperties(
      prefetchZoomDelta: 4,
    );
  }

  /// Method to convert ImageSourceProperties Object to Map
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    if (prefetchZoomDelta != null) {
      args["prefetchZoomDelta"] = prefetchZoomDelta;
    }
    return args.isNotEmpty ? args : null;
  }
}
