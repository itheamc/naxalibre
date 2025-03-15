import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/offline_button.dart';

// 8. Offline Management Screen
class OfflineManagementScreen extends BaseMapScreen {
  const OfflineManagementScreen({super.key})
    : super(title: 'Offline Management');

  @override
  State<OfflineManagementScreen> createState() =>
      _OfflineManagementScreenState();
}

class _OfflineManagementScreenState
    extends BaseMapScreenState<OfflineManagementScreen> {
  List<OfflineRegion>? _regions;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        Positioned(
          left: 10,
          right: 10,
          top: 100,
          child: Column(
            children: [
              if (_errorMessage != null)
                Card(
                  color: Colors.red.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              if (_statusMessage != null)
                Card(
                  color: Colors.green.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _statusMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          top: MediaQuery.of(context).padding.top + 70,
          child: Card(
            color: Colors.white.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 8.0,
                children: [
                  const Text(
                    'Offline Regions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_isDownloading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Downloading region: ${(_downloadProgress * 100).toStringAsFixed(1)}%',
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: _downloadProgress),
                        ],
                      ),
                    ),
                  if (_regions == null || _regions!.isEmpty)
                    const Text('No offline regions found')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _regions!.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final region = _regions![index];
                        return ListTile(
                          title: Text('Region ID: ${region.id}'),
                          subtitle: Text(
                            'Name: ${region.metadata?.name}\n'
                            'Downloaded At: ${region.metadata?.createdAt != null ? DateTime.fromMillisecondsSinceEpoch(region.metadata!.createdAt) : "-"}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteRegion(region.id!),
                          ),
                          isThreeLine: true,
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OfflineButton(
                label: "Download Current View",
                icon: Icons.download,
                onPressed: _downloadCurrentView,
              ),
              OfflineButton(
                label: "Refresh Regions",
                icon: Icons.refresh,
                onPressed: _loadRegions,
              ),
              OfflineButton(
                label: "Delete All Regions",
                icon: Icons.delete_forever,
                onPressed: _deleteAllRegions,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _loadRegions() async {
    setState(() {
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      final regions = await controller?.offlineManager.listRegions();
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load regions: $e';
      });
      debugPrint("[OfflineManagementScreen._loadRegions] => $e");
    }
  }

  Future<void> _downloadCurrentView() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      final cameraPosition = await controller?.getCameraPosition();
      if (cameraPosition == null || cameraPosition.target == null) {
        setState(() {
          _errorMessage = 'Could not get camera position';
          _isDownloading = false;
        });
        return;
      }

      // Create a bounding box around the current position
      final lat = cameraPosition.target!.latitude;
      final lng = cameraPosition.target!.longitude;
      final padding = 0.05; // Approximately 5km at the equator

      final definition = OfflineTilePyramidRegionDefinition(
        styleUrl: mapStyle,
        bounds: LatLngBounds(
          southwest: LatLng(lat - padding, lng - padding),
          northeast: LatLng(lat + padding, lng + padding),
        ),
        minZoom: 5.0,
        maxZoom: 10.0,
      );

      final metadata = OfflineRegionMetadata(
        name: 'Region_${DateTime.now().millisecondsSinceEpoch}',
      );

      await controller?.offlineManager.download(
        definition: definition,
        metadata: metadata,
        onInitiated: (regionId) {
          setState(() {
            _statusMessage = 'Download initiated for region ID: $regionId';
          });
        },
        onDownloading: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
        onDownloaded: (region) {
          setState(() {
            _isDownloading = false;
            _statusMessage = 'Download completed for region ID: ${region.id}';
          });
          _loadRegions(); // Refresh the regions list
        },
        onError: (error) {
          setState(() {
            _isDownloading = false;
            _errorMessage = 'Download error: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Failed to download region: $e';
      });
      debugPrint("[OfflineManagementScreen._downloadCurrentView] => $e");
    }
  }

  Future<void> _deleteRegion(int regionId) async {
    setState(() {
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      final isDeleted = await controller?.offlineManager.delete(regionId);
      if (isDeleted == true) {
        setState(() {
          _statusMessage = 'Region $regionId deleted successfully';
        });
        _loadRegions(); // Refresh the regions list
      } else {
        setState(() {
          _errorMessage = 'Failed to delete region $regionId';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting region: $e';
      });
      debugPrint("[OfflineManagementScreen._deleteRegion] => $e");
    }
  }

  Future<void> _deleteAllRegions() async {
    setState(() {
      _errorMessage = null;
      _statusMessage = null;
    });

    try {
      final result = await controller?.offlineManager.deleteAll();
      if (result != null) {
        int successCount = 0;
        result.forEach((_, isDeleted) {
          if (isDeleted) successCount++;
        });

        setState(() {
          _statusMessage =
              'Deleted $successCount out of ${result.length} regions';
        });
        _loadRegions(); // Refresh the regions list
      } else {
        setState(() {
          _errorMessage = 'Failed to delete regions';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting regions: $e';
      });
      debugPrint("[OfflineManagementScreen._deleteAllRegions] => $e");
    }
  }

  @override
  void onControllerReady(NaxaLibreController? controller) {
    super.onControllerReady(controller);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      Future.delayed(const Duration(milliseconds: 500), _loadRegions);
    });
  }
}
