import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/naxalibre_logger.dart';
import 'style_image.dart';

/// NetworkStyleImage class
///
/// A class that represents a network style image used in Map styling. This class
/// allows the use of images from URLs to define the style of map features.
///
class NetworkStyleImage extends StyleImage {
  /// [url] - The URL to load the image from the network.
  final String url;

  /// Constructor for NetworkStyleImage.
  ///
  /// [imageId]: A unique identifier for the image.
  /// [url]: The URL of the image to load.
  /// [sdf]: A boolean indicating whether the image is an SDF (Signed Distance Field) image. Defaults to false.
  NetworkStyleImage({
    required super.imageId,
    required this.url,
    super.sdf = false,
  });

  /// Converts the NetworkStyleImage object into a Map to pass to native platform.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` containing the image's ID, URL, and whether it is an SDF image.
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "imageId": imageId,
      "url": url,
      "sdf": sdf,
    };
  }

  /// Retrieves the byte array for the image from the network.
  ///
  /// Returns:
  /// A `Future<Uint8List?>` that resolves to the byte array of the image, or null if an error occurs.
  ///
  /// Throws:
  /// If the URL is invalid or the image loading fails, it catches the exception and prints the error in debug mode.
  @override
  Future<Uint8List?> getByteArray() async {
    try {
      if (url.trim().isEmpty || !url.contains("http")) return null;

      final uri = Uri.tryParse(url.trim());

      if (uri == null) return null;

      final client = HttpClient();
      final request = await client.getUrl(uri);
      final response = await request.close();

      // Collect all data chunks into a single byte array
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }

      return Uint8List.fromList(bytes);
    } on Exception catch (e, _) {
      NaxaLibreLogger.logError("[NetworkStyleImage.getByteArray] -----> $e");
    }
    return null;
  }
}
