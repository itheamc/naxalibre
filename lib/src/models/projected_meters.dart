/// Represents a geographic coordinate in projected meters.
///
/// This is commonly used in mapping systems to define positions
/// in a projected coordinate system, using [northing] and [easting].
class ProjectedMeters {
  /// The northing value of the coordinate.
  ///
  /// This represents the distance in meters north or south of the
  /// origin in the projected coordinate system.
  final double northing;

  /// The easting value of the coordinate.
  ///
  /// This represents the distance in meters east or west of the
  /// origin in the projected coordinate system.
  final double easting;

  /// Creates a [ProjectedMeters] instance with the specified [northing]
  /// and [easting] values.
  ///
  /// Example:
  /// ```dart
  /// const ProjectedMeters meters = ProjectedMeters(2000000.0, 500000.0);
  /// print('Northing: ${meters.northing}, Easting: ${meters.easting}');
  /// ```
  const ProjectedMeters(this.northing, this.easting);
}
