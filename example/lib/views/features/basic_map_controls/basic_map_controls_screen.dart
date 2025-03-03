// 1. Basic Map Controls Screen
import 'package:flutter/material.dart';

import '../base_map/base_map_screen.dart';

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
            children: [
              FloatingActionButton(
                heroTag: "zoomIn",
                onPressed: () => controller?.zoomIn(),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: "zoomOut",
                onPressed: () => controller?.zoomOut(),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),
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
            ],
          ),
        ),
      ],
    );
  }
}
