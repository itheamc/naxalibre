import 'package:flutter/material.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/fps_button.dart';

// 5. Map Performance Screen
class MapPerformanceScreen extends BaseMapScreen {
  const MapPerformanceScreen({super.key}) : super(title: 'Map Performance');

  @override
  State<MapPerformanceScreen> createState() => _MapPerformanceScreenState();
}

class _MapPerformanceScreenState
    extends BaseMapScreenState<MapPerformanceScreen> {
  int currentFps = 60;

  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        Positioned(
          top: 100,
          left: 16,
          child: Card(
            color: Colors.white.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Current FPS: $currentFps',
                style: const TextStyle(fontWeight: FontWeight.bold),
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
              FpsButton(
                fps: 60,
                currentFps: currentFps,
                onPressed: () => _setFps(60),
              ),
              FpsButton(
                fps: 120,
                currentFps: currentFps,
                onPressed: () => _setFps(120),
              ),
              FpsButton(
                fps: 240,
                currentFps: currentFps,
                onPressed: () => _setFps(240),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setFps(int fps) async {
    await controller?.setMaximumFps(fps);

    setState(() {
      currentFps = fps;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('FPS set to $fps')));
  }
}
