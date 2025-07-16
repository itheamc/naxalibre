import 'latlng.dart';
import 'latlng_bounds.dart';

/// Represents the visible region on a map.
///
/// The [VisibleRegion] class defines the corners of the current
/// visible area on the map along with its bounding box.
class VisibleRegion {
  /// The top-left corner of the visible region on the map.
  final LatLng? farLeft;

  /// The top-right corner of the visible region on the map.
  final LatLng? farRight;

  /// The bottom-left corner of the visible region on the map.
  final LatLng? nearLeft;

  /// The bottom-right corner of the visible region on the map.
  final LatLng? nearRight;

  /// The bounding box that encompasses the visible region.
  ///
  /// This is represented as a [LatLngBounds] object.
  final LatLngBounds latLngBounds;

  /// Creates a [VisibleRegion] instance with the specified corner coordinates
  /// and bounding box.
  ///
  /// - [farLeft], [farRight], [nearLeft], and [nearRight] represent the visible
  ///   region's corners. These are optional.
  /// - [latLngBounds] is required and represents the bounding box of the region.
  ///
  /// Example:
  /// ```dart
  /// final VisibleRegion region = VisibleRegion(
  ///   farLeft: LatLng(27.8, 85.3),
  ///   farRight: LatLng(27.8, 85.5),
  ///   nearLeft: LatLng(27.7, 85.3),
  ///   nearRight: LatLng(27.7, 85.5),
  ///   latLngBounds: LatLngBounds(
  ///     LatLng(27.7, 85.3),
  ///     LatLng(27.8, 85.5),
  ///   ),
  /// );
  ///
  /// print('Far Left: ${region.farLeft}');
  /// print('Bounding Box: ${region.latLngBounds}');
  /// ```
  VisibleRegion({
    this.farLeft,
    this.farRight,
    this.nearLeft,
    this.nearRight,
    required this.latLngBounds,
  });

  factory VisibleRegion.fromArgs(dynamic args) {
    if (args == null || args['bounds'] == null) {
      throw Exception('Invalid arguments');
    }

    return VisibleRegion(
      farLeft:
          args['farLeft'] is List ? LatLng.fromArgs(args['farLeft']) : null,
      farRight:
          args['farRight'] is List ? LatLng.fromArgs(args['farRight']) : null,
      nearLeft:
          args['nearLeft'] is List ? LatLng.fromArgs(args['nearLeft']) : null,
      nearRight:
          args['nearRight'] is List ? LatLng.fromArgs(args['nearRight']) : null,
      latLngBounds: LatLngBounds.fromArgs(args['bounds']),
    );
  }
}
