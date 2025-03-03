import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/utility_button.dart';

// 6. Map Utilities Screen
class MapUtilitiesScreen extends BaseMapScreen {
  const MapUtilitiesScreen({super.key}) : super(title: 'Map Utilities');

  @override
  State<MapUtilitiesScreen> createState() => _MapUtilitiesScreenState();
}

class _MapUtilitiesScreenState extends BaseMapScreenState<MapUtilitiesScreen> {
  Uint8List? snapshot;
  String? lightInfo;

  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        if (snapshot != null)
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Image.memory(snapshot!, width: 200),
            ),
          ),
        if (lightInfo != null)
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.white.withValues(alpha: 0.8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(lightInfo!),
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
              UtilityButton(
                label: "Take Snapshot",
                icon: Icons.camera_alt,
                onPressed: _takeSnapshot,
              ),
              UtilityButton(
                label: "Get Light Info",
                icon: Icons.lightbulb_outline,
                onPressed: _getLightInfo,
              ),
              UtilityButton(
                label: "Get Map JSON",
                icon: Icons.data_object,
                onPressed: _getMapJson,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _takeSnapshot() async {
    final image = await controller?.snapshot();

    setState(() {
      snapshot = image;
    });

    // Auto-hide snapshot after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          snapshot = null;
        });
      }
    });
  }

  Future<void> _getLightInfo() async {
    final light = await controller?.getLight();

    setState(() {
      lightInfo = """
Light Data:
Intensity: ${light?.intensity}
Color: ${light?.color}
      """;
    });

    // Auto-hide light info after 3 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          lightInfo = null;
        });
      }
    });
  }

  Future<void> _getMapJson() async {
    final json = await controller?.getJson();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map JSON retrieved (check console output)'),
        duration: Duration(seconds: 2),
      ),
    );

    print("Map JSON: $json");
  }
}
