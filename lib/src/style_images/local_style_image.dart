part of 'style_image.dart';

/// LocalStyleImage class
///
/// A class that represents a local style image used in Map styling. This class
/// allows the use of images from local assets to define the style of map features.
///
class LocalStyleImage extends StyleImage {
  /// [imageName] - The name and path of the image asset.
  /// Example: `assets/images/icon.png`
  final String imageName;

  /// Constructor for LocalStyleImage.
  ///
  /// [imageId]: A unique identifier for the image.
  /// [imageName]: The name and path of the image file in the asset bundle.
  /// [sdf]: A boolean indicating whether the image is an SDF (Signed Distance Field) image. Defaults to false.
  LocalStyleImage({
    required super.imageId,
    required this.imageName,
    super.sdf = false,
  });

  /// Converts the LocalStyleImage object into a Map to pass to native platform.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` containing the image's ID, name, and whether it is an SDF image.
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "imageId": imageId,
      "imageName": imageName,
      "sdf": sdf,
    };
  }

  /// Retrieves the byte array for the image from the asset bundle.
  ///
  /// Returns:
  /// A `Future<Uint8List?>` that resolves to the byte array of the image, or null if an error occurs.
  ///
  /// Throws:
  /// If the image loading fails, it catches the exception and prints the error in debug mode.
  @override
  Future<Uint8List?> getByteArray() async {
    try {
      if (imageName.trim().isEmpty) return null;

      final bytes = await rootBundle.load(imageName.trim());
      final list = bytes.buffer.asUint8List();
      return list;
    } on Exception catch (e, _) {
      NaxaLibreLogger.logError("[LocalStyleImage.getByteArray] -----> $e");
    }
    return null;
  }
}
