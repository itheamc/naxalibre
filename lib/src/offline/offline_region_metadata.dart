/// Represents metadata associated with an offline map region.
///
/// This metadata provides additional information about the offline
/// region, such as its **name, creation timestamp, and custom attributes**.
/// The **size** is unknown at creation and can be updated later.
class OfflineRegionMetadata {
  /// The name of the offline region.
  ///
  /// This is a **user-defined label** to identify the region.
  final String name;

  /// The timestamp (in milliseconds since epoch) when the offline region was created.
  ///
  /// This helps in tracking when the region was downloaded.
  final int createdAt;

  /// Custom metadata values for the offline region.
  ///
  /// This can store **additional properties**, such as a **description, version,**
  /// or other user-defined data.
  final Map<String, dynamic> customAttributes;

  /// Creates an instance of [OfflineRegionMetadata].
  ///
  /// - `name` is required and represents the **region identifier**.
  /// - `createdAt` defaults to the **current timestamp** if not provided.
  /// - `customAttributes` allows storing additional **key-value pairs**.
  ///
  /// Example:
  /// ```dart
  /// OfflineRegionMetadata(
  ///   name: "San Francisco Downtown",
  ///   createdAt: DateTime.now().millisecondsSinceEpoch,
  ///   customAttributes: {
  ///     "region_type": "urban",
  ///     "downloaded_by": "User123"
  ///   }
  /// )
  /// ```
  OfflineRegionMetadata({
    required this.name,
    DateTime? createdAt,
    Map<String, dynamic>? customAttributes,
  }) : createdAt =
           createdAt?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch,
       customAttributes = customAttributes ?? {};

  /// Converts this [OfflineRegionMetadata] instance into a map.
  ///
  /// This method is useful for serialization when passing data
  /// between components or storing it in a database.
  Map<String, dynamic> toArgs() {
    return {
      'name': name,
      'createdAt': createdAt,
      'customAttributes': customAttributes,
    };
  }

  /// Creates an instance of [OfflineRegionMetadata] from a map of arguments.
  ///
  /// This factory method reconstructs an instance from a serialized
  /// map representation, typically received from a storage system or
  /// method channel.
  ///
  /// - `args['name']` must be a `String`.
  /// - `args['createdAt']` must be an `int` (timestamp).
  /// - `args['size']` is optional and should be an `int?`.
  /// - `args['customAttributes']` should be a JSON-encoded string and is
  ///   decoded into a `Map<String, dynamic>`.
  factory OfflineRegionMetadata.fromArgs(Map<String, dynamic> args) {
    return OfflineRegionMetadata(
      name: args['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(args['createdAt'] as int),
      customAttributes:
          args.containsKey('customAttributes')
              ? args['customAttributes'].map<String, dynamic>(
                (k, v) => MapEntry(k.toString(), v),
              )
              : {},
    );
  }
}
