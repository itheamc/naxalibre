import '../utils/naxalibre_logger.dart';
import '../pigeon_generated.dart';

import 'offline_region.dart';
import 'offline_region_definition.dart';
import 'offline_region_metadata.dart';

/// A manager class for handling offline map regions in NaxaLibre application.
///
/// This class provides functionality to download, retrieve, list, and delete
/// offline map regions for offline use of maps.
class NaxaLibreOfflineManager {
  /// The host API for communicating with the native side.
  final _hostApi = NaxaLibreHostApi();

  /// Downloads a map region for offline use.
  ///
  /// This method initiates the download of a specified map region based on the provided
  /// definition and metadata. It reports progress through callback functions.
  ///
  /// Parameters:
  /// - [definition]: The definition of the region to download, including boundaries and zoom levels.
  /// - [metadata]: Additional metadata for the offline region.
  /// - [onInitiated]: Callback function called when the download is initiated, providing the region ID.
  /// - [onDownloading]: Callback function called during download with the download progress (0.0 to 1.0).
  /// - [onDownloaded]: Callback function called when download is completed, providing the downloaded region.
  /// - [onError]: Optional callback function called if an error occurs during the download process.
  ///
  /// Throws:
  /// Various exceptions that might occur during the download process, which are caught
  /// and passed to the onError callback.
  Future<void> download({
    required OfflineRegionDefinition definition,
    required OfflineRegionMetadata metadata,
    required void Function(int) onInitiated,
    required void Function(double) onDownloading,
    required void Function(OfflineRegion) onDownloaded,
    void Function(String)? onError,
  }) async {
    try {
      // Convert the definition and metadata to arguments
      final args = {
        "definition": definition.toArgs(),
        "metadata": metadata.toArgs(),
      };

      // Create a stream of events
      final Stream<NaxaLibreEvent> events = streamEvents();

      // Download the region
      final regionArgs = await _hostApi.downloadRegion(args);

      // Getting the region from regionArgs
      final region = OfflineRegion.fromArgs(
        regionArgs.map<String, dynamic>((k, v) => MapEntry(k.toString(), v)),
      );

      // Triggering on Downloading started
      onInitiated(region.id!);

      // Listen for events
      events.listen(
        (event) {
          switch (event) {
            case DoubleEvent():
              onDownloading(event.data);
              break;
            case StringEvent():
              onError?.call(event.data);
              break;
            case IntEvent():
              break;
          }
        },
        onDone: () async {
          onDownloaded(region);
        },
        onError: (error) {
          onError?.call(error.toString());
          NaxaLibreLogger.logError("[$runtimeType.download] => $error");
        },
      );
    } catch (e) {
      onError?.call(e.toString());
      NaxaLibreLogger.logError("[$runtimeType.download] => $e");
    }
  }

  /// Retrieves a specific offline region by its ID.
  ///
  /// Parameters:
  /// - [regionId]: The unique identifier of the region to retrieve.
  ///
  /// Returns:
  /// The requested [OfflineRegion] if found, null otherwise or if an error occurs.
  Future<OfflineRegion?> get(int regionId) async {
    try {
      final regionArgs = await _hostApi.getRegion(regionId);
      final region = OfflineRegion.fromArgs(
        regionArgs.map<String, dynamic>((k, v) => MapEntry(k.toString(), v)),
      );
      return region;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.get] => $e");
      return null;
    }
  }

  /// Lists all downloaded offline regions.
  ///
  /// Returns:
  /// A list of all available [OfflineRegion] objects if successful, null if an error occurs.
  Future<List<OfflineRegion>?> listRegions() async {
    try {
      final regionListArgs = await _hostApi.listRegions();
      final regions =
          regionListArgs
              .map(
                (args) => OfflineRegion.fromArgs(
                  args.map<String, dynamic>(
                    (k, v) => MapEntry(k.toString(), v),
                  ),
                ),
              )
              .toList();
      return regions;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.listRegions] => $e");
      return null;
    }
  }

  /// Deletes a specific offline region by its ID.
  ///
  /// Parameters:
  /// - [regionId]: The unique identifier of the region to delete.
  ///
  /// Returns:
  /// true if the region was successfully deleted, false otherwise or if an error occurs.
  Future<bool> delete(int regionId) async {
    try {
      final isDeleted = await _hostApi.deleteRegion(regionId);
      return isDeleted;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.delete] => $e");
      return false;
    }
  }

  /// Deletes all downloaded offline regions.
  ///
  /// Returns:
  /// A map with region IDs as keys and boolean values indicating whether each region
  /// was successfully deleted. Returns null if an error occurs.
  Future<Map<int, bool>?> deleteAll() async {
    try {
      final deletedArgs = await _hostApi.deleteAllRegions();
      return deletedArgs;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.deleteAll] => $e");
      return null;
    }
  }
}
