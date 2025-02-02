/// A class representing the request options for a location engine.
///
/// This class encapsulates various parameters that control how frequently and
/// accurately the location engine should provide location updates. It is used
/// to configure the behavior of location tracking.
class LocationEngineRequestOptions {
  /// The interval (in milliseconds) at which location updates are requested.
  ///
  /// Defaults to `750` milliseconds.
  final int interval;

  /// The priority level for location accuracy.
  ///
  /// This determines the trade-off between accuracy and power consumption.
  /// Defaults to [LocationEngineRequestPriority.highAccuracy].
  final LocationEngineRequestPriority priority;

  /// The minimum displacement (in meters) required to trigger a location update.
  ///
  /// If the device moves less than this distance, no update will be triggered.
  /// Defaults to `0.0` meters.
  final double displacement;

  /// The maximum wait time (in milliseconds) for location updates.
  ///
  /// If a location update is not received within this time, the engine may
  /// provide a cached or less accurate location. Defaults to `1000` milliseconds.
  final int maxWaitTime;

  /// The fastest interval (in milliseconds) at which location updates can be received.
  ///
  /// This sets a lower bound on how frequently updates can occur, even if the
  /// device is moving quickly. Defaults to `750` milliseconds.
  final int fastestInterval;

  /// Creates a new instance of [LocationEngineRequestOptions].
  ///
  /// All parameters are optional and have default values:
  /// - [interval]: Defaults to `750` milliseconds.
  /// - [priority]: Defaults to [LocationEngineRequestPriority.highAccuracy].
  /// - [displacement]: Defaults to `0.0` meters.
  /// - [maxWaitTime]: Defaults to `1000` milliseconds.
  /// - [fastestInterval]: Defaults to `750` milliseconds.
  const LocationEngineRequestOptions({
    this.interval = 750,
    this.priority = LocationEngineRequestPriority.highAccuracy,
    this.displacement = 0.0,
    this.maxWaitTime = 1000,
    this.fastestInterval = 750,
  });

  /// Converts the [LocationEngineRequestOptions] object into a map.
  ///
  /// This method is useful for serialization or passing data to other layers
  /// (e.g., Kotlin/Swift). The keys in the map correspond to the property names,
  /// and the values are the current values of those properties.
  ///
  /// Returns a [Map<String, dynamic>] representing the object.
  Map<String, dynamic> toArgs() {
    return {
      "interval": interval,
      "priority": priority.index,
      "displacement": displacement,
      "maxWaitTime": maxWaitTime,
      "fastestInterval": fastestInterval,
    };
  }
}

/// An enum representing the priority levels for location accuracy.
///
/// These priorities determine the trade-off between accuracy and power consumption
/// when requesting location updates.
enum LocationEngineRequestPriority {
  /// High accuracy mode.
  ///
  /// Provides the most accurate location updates but consumes the most power.
  highAccuracy,

  /// Balanced mode.
  ///
  /// Provides a balance between accuracy and power consumption.
  balanced,

  /// Low power mode.
  ///
  /// Reduces power consumption by providing less accurate location updates.
  lowPower,

  /// No power mode.
  ///
  /// Minimizes power consumption by providing only passive location updates.
  noPower,
}
