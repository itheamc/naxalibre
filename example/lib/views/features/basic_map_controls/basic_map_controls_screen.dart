import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

import '../base_map/base_map_screen.dart';

// 1. Basic Map Controls Screen
class BasicMapControlsScreen extends BaseMapScreen {
  const BasicMapControlsScreen({super.key})
    : super(title: 'Basic Map Controls');

  @override
  State<BasicMapControlsScreen> createState() => _BasicMapControlsScreenState();
}

class _BasicMapControlsScreenState
    extends BaseMapScreenState<BasicMapControlsScreen> {
  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8.0,
            children: [
              FloatingActionButton(
                heroTag: "zoomIn",
                onPressed: () => controller?.zoomIn(),
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                heroTag: "zoomOut",
                onPressed: () => controller?.zoomOut(),
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                heroTag: "toggleStyle",
                onPressed: () async {
                  final style = await controller?.getUri();

                  if (style == mapStyle) {
                    await controller?.setStyle(darkMapStyle);
                  } else {
                    await controller?.setStyle(mapStyle);
                  }
                },
                child: const Icon(Icons.style),
              ),

              FloatingActionButton(
                heroTag: "download",
                onPressed: () async {
                  await controller?.offlineManager.download(
                    definition: OfflineTilePyramidRegionDefinition(
                      bounds: LatLngBounds.fromLatLongs(
                        85.74,
                        27.14,
                        86.23,
                        27.62,
                      ),
                    ),
                    metadata: OfflineRegionMetadata(name: "Kathmandu Region"),
                    onInitiated: (id) {
                      debugPrint("Download Started: with id $id");
                    },
                    onDownloading: (progress) {
                      debugPrint("Downloading: $progress");
                    },
                    onDownloaded: (region) {
                      debugPrint("Downloaded: Region ${region.toArgs()}");
                    },
                  );
                },
                child: const Icon(Icons.download),
              ),
              FloatingActionButton(
                heroTag: "get",
                onPressed: () async {
                  final regions = await controller?.offlineManager.get(5);
                  debugPrint("Get: ${regions?.toArgs()}");
                },
                child: const Icon(Icons.get_app_outlined),
              ),
              FloatingActionButton(
                heroTag: "delete",
                onPressed: () async {
                  final deleted = await controller?.offlineManager.delete(5);
                  debugPrint("Deleted: $deleted");
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
