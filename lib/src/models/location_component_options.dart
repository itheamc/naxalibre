/// A class representing the configuration options for a location component.
///
/// This class encapsulates various properties that control the appearance and behavior
/// of a location component, such as pulse animations, colors, elevation, and layer settings.
/// It also provides a method to convert the object into a map for serialization or
/// communication with other layers (e.g., Kotlin/Java).
class LocationComponentOptions {
  /// Whether the pulse animation is enabled.
  final bool? pulseEnabled;

  /// Whether the pulse fade effect is enabled.
  final bool? pulseFadeEnabled;

  /// The color of the pulse animation.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic pulseColor;

  /// The alpha (transparency) value of the pulse animation.
  ///
  /// This value should be between 0.0 (fully transparent) and 1.0 (fully opaque).
  final double? pulseAlpha;

  /// The duration of a single pulse animation in milliseconds.
  final double? pulseSingleDuration;

  /// The maximum radius of the pulse animation in pixels.
  final double? pulseMaxRadius;

  /// The tint color for the foreground icon.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic foregroundTintColor;

  /// The tint color for the stale state of the foreground icon.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic foregroundStaleTintColor;

  /// The tint color for the background icon.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic backgroundTintColor;

  /// The tint color for the stale state of the background icon.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic backgroundStaleTintColor;

  /// Whether the accuracy animation is enabled.
  final bool? accuracyAnimationEnabled;

  /// The color of the accuracy circle.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic accuracyColor;

  /// The alpha (transparency) value of the accuracy circle.
  ///
  /// This value should be between 0.0 (fully transparent) and 1.0 (fully opaque).
  final double? accuracyAlpha;

  /// The tint color for the bearing icon.
  ///
  /// This can be an integer representing an ARGB color or a string representing a
  /// hexadecimal color (e.g., "#RRGGBBAA").
  final dynamic bearingTintColor;

  /// Whether the compass animation is enabled.
  final bool? compassAnimationEnabled;

  /// The elevation of the location component in pixels.
  final double? elevation;

  /// The maximum scale of the icon when zooming in.
  final double? maxZoomIconScale;

  /// The minimum scale of the icon when zooming out.
  final double? minZoomIconScale;

  /// The layer ID above which the location component should be displayed.
  final String? layerAbove;

  /// The layer ID below which the location component should be displayed.
  final String? layerBelow;

  /// Creates a new instance of [LocationComponentOptions].
  ///
  /// All parameters are optional and can be set to `null` if not needed.
  const LocationComponentOptions({
    this.pulseEnabled,
    this.pulseFadeEnabled,
    this.pulseColor,
    this.pulseAlpha,
    this.pulseSingleDuration,
    this.pulseMaxRadius,
    this.foregroundTintColor,
    this.foregroundStaleTintColor,
    this.backgroundTintColor,
    this.backgroundStaleTintColor,
    this.accuracyAnimationEnabled,
    this.accuracyColor,
    this.accuracyAlpha,
    this.bearingTintColor,
    this.compassAnimationEnabled,
    this.elevation,
    this.maxZoomIconScale,
    this.minZoomIconScale,
    this.layerAbove,
    this.layerBelow,
  });

  /// Converts the [LocationComponentOptions] object into a map.
  ///
  /// This method is useful for serialization or passing data to other layers
  /// (e.g., Kotlin/Java). The keys in the map correspond to the property names,
  /// and the values are the current values of those properties.
  ///
  /// Returns a [Map<String, dynamic>] representing the object.
  Map<String, dynamic> toArgs() {
    return {
      'pulseEnabled': pulseEnabled,
      'pulseFadeEnabled': pulseFadeEnabled,
      'pulseColor': pulseColor,
      'pulseAlpha': pulseAlpha,
      'pulseSingleDuration': pulseSingleDuration,
      'pulseMaxRadius': pulseMaxRadius,
      'foregroundTintColor': foregroundTintColor,
      'foregroundStaleTintColor': foregroundStaleTintColor,
      'backgroundTintColor': backgroundTintColor,
      'backgroundStaleTintColor': backgroundStaleTintColor,
      'accuracyAnimationEnabled': accuracyAnimationEnabled,
      'accuracyColor': accuracyColor,
      'accuracyAlpha': accuracyAlpha,
      'bearingTintColor': bearingTintColor,
      'compassAnimationEnabled': compassAnimationEnabled,
      'elevation': elevation,
      'maxZoomIconScale': maxZoomIconScale,
      'minZoomIconScale': minZoomIconScale,
      'layerAbove': layerAbove,
      'layerBelow': layerBelow,
    };
  }
}
