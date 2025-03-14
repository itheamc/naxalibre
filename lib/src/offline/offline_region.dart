import 'offline_region_definition.dart';
import 'offline_region_metadata.dart';

/// Represents an offline region that can be downloaded and stored for
/// offline use in a mapping application.
class OfflineRegion {
  /// The unique identifier for the offline region. This may be `null`
  /// if the region has not been assigned an ID.
  final int? id;

  /// The definition of the offline region, including details such as
  /// the geographical area and zoom levels to be downloaded.
  final OfflineRegionDefinition? definition;

  /// The metadata associated with the offline region, which may contain
  /// additional information such as user-defined tags or timestamps.
  final OfflineRegionMetadata? metadata;

  /// Creates an instance of [OfflineRegion] with optional parameters.
  ///
  /// - [id]: The unique identifier for the offline region.
  /// - [definition]: The details of the offline region to be downloaded.
  /// - [metadata]: Additional information about the offline region.
  OfflineRegion({this.id, this.definition, this.metadata});

  /// Converts this [OfflineRegion] instance into a map of arguments.
  ///
  /// This is useful for passing data between platform channels or serialization.
  Map<String, dynamic> toArgs() {
    return {
      'id': id,
      'definition': definition?.toArgs(),
      'metadata': metadata?.toArgs(),
    };
  }

  /// Creates an instance of [OfflineRegion] from a map of arguments.
  ///
  /// This is useful when receiving data from platform channels or deserializing.
  factory OfflineRegion.fromArgs(Map<String, dynamic> args) {
    return OfflineRegion(
      id: args['id'] as int?,
      definition:
          args['definition'] != null
              ? OfflineRegionDefinition.fromArgs(
                args['definition'].map<String, dynamic>(
                  (k, v) => MapEntry(k.toString(), v),
                ),
              )
              : null,
      metadata:
          args['metadata'] != null
              ? OfflineRegionMetadata.fromArgs(
                args['metadata'].map<String, dynamic>(
                  (k, v) => MapEntry(k.toString(), v),
                ),
              )
              : null,
    );
  }
}
