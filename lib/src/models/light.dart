import 'dart:ui';

/// Represents a light source with a specific color and intensity.
class Light {
  /// The color of the light.
  ///
  /// This defines the color of the light source. It is represented
  /// as a [Color] object.
  final Color color;

  /// The intensity of the light.
  ///
  /// This defines how bright the light source is, represented as an integer.
  final int intensity;

  /// Creates a [Light] instance with the given [color] and [intensity].
  ///
  /// Both [color] and [intensity] are required parameters.
  ///
  /// Example:
  /// ```dart
  /// final Light light = Light(
  ///   color: Color(0xFFFF0000), // Red color
  ///   intensity: 75,
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
  ///   'color': 0xFFFF0000, // Red color in ARGB format
  ///   'intensity': 75,
  /// });
  /// ```
  factory Light.fromArgs(Map<String, dynamic> args) {
    return Light(
      color: Color(args['color']),
      intensity: args['intensity'],
    );
  }
}
