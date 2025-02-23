import 'package:naxalibre/src/utils/naxalibre_logger.dart';

/// Represents a light source with a specific color and intensity.
class Light {
  /// The color of the light.
  ///
  /// This defines the color of the light source. It is represented
  /// as a [String] object.
  final String color;

  /// The intensity of the light.
  ///
  /// This defines how bright the light source is, represented as an double.
  final double intensity;

  /// Creates a [Light] instance with the given [color] and [intensity].
  ///
  /// Both [color] and [intensity] are required parameters.
  ///
  /// Example:
  /// ```dart
  /// final Light light = Light(
  ///   color: #FF0000, // Red color
  ///   intensity: 0.70,
  /// );
  /// ```
  Light({required this.color, required this.intensity});

  /// Creates a [Light] instance from a [Map] of arguments.
  ///
  /// The [args] map must include:
  /// - `"color"`: A color value (e.g., an integer representing a color in ARGB format).
  /// - `"intensity"`: An integer value representing the light's intensity.
  ///
  /// Example:
  /// ```dart
  /// final Light light = Light.fromArgs({
  ///   'color': "#FF0000", // Red color in ARGB format
  ///   'intensity': 75,
  /// });
  /// ```
  factory Light.fromArgs(Map<String, dynamic> args) {
    if (!args.containsKey('color') || !args.containsKey('intensity')) {
      throw ArgumentError('Missing required arguments: color, intensity');
    }
    NaxaLibreLogger.logMessage(args);
    return Light(
      color: args['color'],
      intensity: args['intensity'],
    );
  }
}
