import 'package:flutter/material.dart';

import '../base_map/base_map_screen.dart';

// 4. Location Features Screen
class LocationFeaturesScreen extends BaseMapScreen {
  const LocationFeaturesScreen({super.key}) : super(title: 'Location Features');

  @override
  State<LocationFeaturesScreen> createState() => _LocationFeaturesScreenState();
}

class _LocationFeaturesScreenState
    extends BaseMapScreenState<LocationFeaturesScreen> {
  String? locationInfo;
  bool value = true;

  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        if (locationInfo != null)
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.white.withValues(alpha: 0.8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(locationInfo!),
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8.0,
            children: [
              FloatingActionButton.extended(
                heroTag: "getLocation",
                onPressed: _getLastKnownLocation,
                label: const Text("Get Location"),
                icon: const Icon(Icons.location_searching),
              ),
              FloatingActionButton.extended(
                heroTag: "toggleLocation",
                onPressed: _toggleLocation,
                label: const Text("Toggle Location"),
                icon: const Icon(Icons.location_searching),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _getLastKnownLocation() async {
    final location = await controller?.lastKnownLocation();

    setState(() {
      locationInfo = location?.toArgs().toString() ?? "Location not available";
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Location fetched')));
  }

  Future<void> _toggleLocation() async {
    value = !value;
    await controller?.enableLocation(value);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location ${value ? 'enabled' : 'disabled'}')),
    );
  }
}
