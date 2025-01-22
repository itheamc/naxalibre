import 'dart:typed_data';

/// Abstract StyleImage class
///
/// A base class for style images, allowing for different types of images (e.g.,
/// local, network) to be used in Map styling. The `StyleImage` class provides
/// methods to convert the image to a map and fetch its byte array.
///
abstract class StyleImage {
  /// [imageId] - A unique identifier for the image, used to identify the image
  /// in a list of style images.
  final String imageId;

  /// [sdf] - A boolean flag that indicates if the image is an SDF (Signed Distance Field).
  /// SDF images preserve sharp outlines from pixel images even when resized.
  /// Defaults to `false`.
  final bool sdf;

  /// Constructor for StyleImage.
  ///
  /// [imageId]: A unique identifier for the image.
  /// [sdf]: A boolean flag indicating whether the image is an SDF. Defaults to `false`.
  StyleImage({required this.imageId, this.sdf = false});

  /// Converts the StyleImage object into a map, allowing it to be passed to native platforms.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` containing the image's ID and SDF status.
  Map<String, dynamic> toMap();

  /// Retrieves the byte array for the image.
  ///
  /// Returns:
  /// A `Future<Uint8List?>` that resolves to the byte array of the image, or `null` if an error occurs.
  Future<Uint8List?> getByteArray();
}
