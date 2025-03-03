import 'dart:math';
import 'dart:ui';

import 'latlng.dart';

/// A class representing rendered coordinates of a point or a rectangle.
///
/// This class provides a structured way to store coordinate data for rendering
/// purposes. It supports two types of coordinates:
/// - `point`: A single coordinate point (x, y).
/// - `rect`: A rectangular boundary (left, top, right, bottom).
class RenderedCoordinates {
  /// The type of coordinates stored (`point` or `rect`).
  final String type;

  /// The coordinate values.
  /// - If [type] is `point`, this contains [x, y].
  /// - If [type] is `rect`, this contains [left, top, right, bottom].
  final List<double> coordinates;

  /// Private constructor for creating a [RenderedCoordinates] instance.
  RenderedCoordinates._(this.coordinates, this.type);

  /// Creates a [RenderedCoordinates] instance from a [Point].
  ///
  /// The generated coordinate type will be `point` with values `[x, y]`.
  factory RenderedCoordinates.fromPoint(Point<double> point) {
    return RenderedCoordinates._(
      [point.x, point.y],
      'point',
    );
  }

  /// Creates a [RenderedCoordinates] instance from a [LatLng].
  ///
  /// The generated coordinate type will be `latLng` with values `[latitude, longitude]`.
  factory RenderedCoordinates.fromLatLng(LatLng latLng) {
    return RenderedCoordinates._(
      [latLng.latitude, latLng.longitude],
      'latLng',
    );
  }

  /// Creates a [RenderedCoordinates] instance from a [Rect].
  ///
  /// The generated coordinate type will be `rect` with values `[left, top, right, bottom]`.
  factory RenderedCoordinates.fromRect(Rect rect) {
    return RenderedCoordinates._(
      [
        rect.left,
        rect.top,
        rect.right,
        rect.bottom,
      ],
      'rect',
    );
  }

  /// Converts the [RenderedCoordinates] instance into a map of arguments.
  ///
  /// The returned map contains the type as the key and the coordinates as the value.
  Map<String, dynamic> toArgs() {
    return {
      type: coordinates,
    };
  }
}
