/// The `StyleTransition` class represents a transition style that can be applied
/// to various map elements, defining how they change over time.
///
/// This includes options for specifying the delay and duration of the transition.
class StyleTransition {
  /// The delay for the transition, in milliseconds.
  final int delay;

  /// The duration of the transition.
  final Duration duration;

  /// Constructs a `StyleTransition` instance.
  ///
  /// This constructor is internal and should not be used directly. Instead,
  /// use the [StyleTransition.build] factory method to create an instance.
  StyleTransition._(this.delay, this.duration);

  /// Factory method to create a `StyleTransition` instance with optional parameters.
  ///
  /// [delay]: The delay of the transition in milliseconds. Defaults to `0`.
  /// [duration]: The duration of the transition as a [Duration]. Defaults to
  /// `Duration(milliseconds: 300)`.
  ///
  /// Example:
  /// ```dart
  /// final transition = StyleTransition.build(
  ///   delay: 500,
  ///   duration: Duration(seconds: 1),
  /// );
  /// ```
  factory StyleTransition.build({int? delay, Duration? duration}) {
    return StyleTransition._(
      delay ?? 0,
      duration ?? const Duration(milliseconds: 300),
    );
  }

  /// Converts the `StyleTransition` instance into a map representation.
  ///
  /// This map can be used for passing transition data to native platforms
  /// or for other serialization purposes.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` containing:
  ///   - `"delay"`: The transition delay in milliseconds.
  ///   - `"duration"`: The transition duration in milliseconds.
  ///
  /// Example:
  /// ```dart
  /// final args = transition.toArgs();
  /// ```
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "delay": delay,
      "duration": duration.inMilliseconds,
    };
  }
}
