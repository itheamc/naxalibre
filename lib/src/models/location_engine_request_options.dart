/// A class representing the request options for a location engine.
///
/// This class encapsulates various parameters that control how frequently and
/// accurately the location engine should provide location updates. It is used
/// to configure the behavior of location tracking.
class LocationEngineRequestOptions {
  /// The interval (in milliseconds) at which location updates are requested.
  ///
  /// Defaults to `750` milliseconds.
  /// Note: No effect on iOS
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
  /// Note: No effect on iOS
  final int maxWaitTime;

  /// The fastest interval (in milliseconds) at which location updates can be received.
  ///
  /// This sets a lower bound on how frequently updates can occur, even if the
  /// device is moving quickly. Defaults to `750` milliseconds.
  /// Note: No effect on iOS
  final int fastestInterval;

  /// The type of location provider to use for retrieving location updates.
  ///
  /// This parameter determines the data source for location information,
  /// such as GPS, network, or a combination of sources.
  /// Note: No effect on iOS
  final LocationProvider provider;

  /// Creates a new instance of [LocationEngineRequestOptions].
  ///
  /// All parameters are optional and have default values:
  /// - [interval]: Defaults to `1000` milliseconds.
  /// - [priority]: Defaults to [LocationEngineRequestPriority.highAccuracy].
  /// - [displacement]: Defaults to `20.0` meters.
  /// - [maxWaitTime]: Defaults to `1000` milliseconds.
  /// - [fastestInterval]: Defaults to `1000` milliseconds.
  /// - [priority]: Defaults to [LocationProvider.fused].
  const LocationEngineRequestOptions({
    this.interval = 1000,
    this.priority = LocationEngineRequestPriority.highAccuracy,
    this.displacement = 40.0,
    this.maxWaitTime = 1000,
    this.fastestInterval = 1000,
    this.provider = LocationProvider.fused,
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
      "provider": provider.name,
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

/// Represents different location data sources available in mobile and web applications.
///
/// Each provider offers unique characteristics for obtaining geographic location information:
///
/// [gps] Global Positioning System provider
///  - Most accurate location method
///  - Requires direct line of sight to GPS satellites
///  - Works best outdoors
///  - Highest battery consumption
///  - Slowest to provide initial location
///  - Provides precise latitude/longitude
///  - Accuracy: 4-20 meters typically
///  - Requires GPS hardware
///
/// [network] Location derived from cellular tower triangulation
///  - Uses mobile network infrastructure
///  - Less accurate than GPS
///  - Works indoors and in urban areas
///  - Lower battery consumption
///  - Faster initial location
///  - Rough location estimation
///  - Accuracy: 100-1000 meters
///  - Requires active network connection
///
/// [fused] Combines multiple location sources intelligently
///  - Dynamically selects best provider
///  - Balances accuracy and battery efficiency
///  - Can quickly switch between GPS, network, and sensors
///  - Recommended for most modern applications
///  - Adaptive to current context and device capabilities
///  - Most battery-efficient option
///
/// [passive] Receives location updates from other apps
///  - Lowest battery consumption
///  - No direct location requests
///  - Uses location data already retrieved by other applications
///  - Useful for background services
///  - Unpredictable update frequency
///  - Best for non-critical location tracking
enum LocationProvider {
  /// Satellite-based precise location
  gps,

  /// Cell tower-based approximate location
  network,

  /// Intelligent multi-source location
  fused,

  /// Background location listening
  passive
}
