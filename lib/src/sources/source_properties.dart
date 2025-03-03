part of 'source.dart';

/// An abstract class representing properties of a map source.
///
/// The `SourceProperties` class serves as a base for defining properties
/// associated with specific types of map sources. It provides a mechanism
/// to convert these properties into a map format, which is useful for
/// platform-specific operations.
///
abstract class SourceProperties {
  /// Converts the `SourceProperties` object to a `Map` representation.
  ///
  /// This method should be implemented by subclasses to provide a map
  /// representation of the source properties, which can be used for
  /// communication between different platforms (e.g., Flutter and native).
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` containing the source properties.
  /// - `null` if there are no properties to map.
  ///
  /// Example:
  /// ```dart
  /// class MySourceProperties extends SourceProperties {
  ///   final int maxZoom;
  ///   final bool enableClustering;
  ///
  ///   MySourceProperties(this.maxZoom, this.enableClustering);
  ///
  ///   @override
  ///   Map<String, dynamic>? toArgs() {
  ///     return {
  ///       'maxZoom': maxZoom,
  ///       'enableClustering': enableClustering,
  ///     };
  ///   }
  /// }
  ///
  /// final properties = MySourceProperties(18, true);
  /// print(properties.toArgs()); // Outputs: {maxZoom: 18, enableClustering: true}
  /// ```
  Map<String, dynamic>? toArgs();
}
