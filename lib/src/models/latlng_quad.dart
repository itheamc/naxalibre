import 'package:naxalibre/src/models/latlng.dart';

/// A class for quad bounding box (bbox), i.e., [LatLngQuad].
///
/// This class represents a quadrilateral formed by four geographical
/// coordinates, specifically the corners of a bounding box. The four
/// corners are represented as `LatLng` objects for the top-left,
/// top-right, bottom-right, and bottom-left corners.
///
/// Properties:
/// - [topLeft] : A `LatLng` object representing the top-left corner of the bounding box.
/// - [topRight] : A `LatLng` object representing the top-right corner of the bounding box.
/// - [bottomRight] : A `LatLng` object representing the bottom-right corner of the bounding box.
/// - [bottomLeft] : A `LatLng` object representing the bottom-left corner of the bounding box.
///
/// Constructor:
/// - The constructor takes four `LatLng` objects, which represent the four corners
///   of the bounding box: top-left, top-right, bottom-right, and bottom-left.
///
/// Factory Method:
/// - [LatLngQuad.fromArgs] - A factory method to create an instance of `LatLngQuad`
///   from a list of four `LatLng` arguments. If the list does not contain exactly four
///   elements, an error is thrown.
class LatLngQuad {
  final LatLng topLeft;
  final LatLng topRight;
  final LatLng bottomRight;
  final LatLng bottomLeft;

  /// Constructor to create a LatLngQuad instance with four corners (LatLng objects).
  const LatLngQuad(
    this.topLeft,
    this.topRight,
    this.bottomRight,
    this.bottomLeft,
  );

  /// Factory method to create a LatLngQuad instance from a list of arguments.
  ///
  /// [args] - A list containing four elements that represent the four corners of
  ///         the bounding box. Each element should be a `LatLng` object.
  ///
  /// Throws [ArgumentError] if the input list does not contain exactly four elements.
  factory LatLngQuad.fromArgs(dynamic args) {
    if (args is! List || args.length != 4) {
      throw ArgumentError(
          'LatLngQuad must contain exactly 4 elements: [topLeft, topRight, bottomRight, bottomLeft]');
    }
    final tl = LatLng.fromArgs(args[0]);
    final tr = LatLng.fromArgs(args[1]);
    final br = LatLng.fromArgs(args[2]);
    final bl = LatLng.fromArgs(args[3]);

    return LatLngQuad(tl, tr, br, bl);
  }

  /// Method to convert [LatLngQuad] to a Map.
  ///
  /// This method returns a Map<String, dynamic> with the keys "top_left",
  /// "top_right", "bottom_right", and "bottom_left", each mapping to the
  /// respective `LatLng` object's list representation.
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "top_left": topLeft.latLngList(),
      "top_right": topRight.latLngList(),
      "bottom_right": bottomRight.latLngList(),
      "bottom_left": bottomLeft.latLngList(),
    };
  }
}
