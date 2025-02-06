import 'package:flutter/material.dart';
import 'package:naxalibre/src/enums/enums.dart';
import 'package:naxalibre/src/naxalibre_platform_interface.dart';

import 'models/location_component_options.dart';
import 'models/location_engine_request_options.dart';
import 'models/location_settings.dart';
import 'models/ui_settings.dart';

class NaxaLibreMap extends StatefulWidget {
  const NaxaLibreMap({super.key});

  @override
  State<NaxaLibreMap> createState() => _MapLibreViewState();
}

class _MapLibreViewState extends State<NaxaLibreMap> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = {
      'styleURL':
      'https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json',
      'uiSettings': UiSettings().toArgs(),
      'locationSettings': const LocationSettings(
        locationEnabled: true,
        cameraMode: CameraMode.none,
        renderMode: RenderMode.normal,
        maxAnimationFps: 30,
        locationComponentOptions: LocationComponentOptions(
          pulseColor: "green",
          pulseEnabled: true,
          foregroundTintColor: "red",
          backgroundTintColor: "yellow",
          accuracyColor: "pink",
        ),
        locationEngineRequestOptions: LocationEngineRequestOptions(
          provider: LocationProvider.gps
        )
      ).toArgs()
    };

    return NaxaLibrePlatform.instance.buildMapView(
      creationParams: creationParams,
      hyperComposition: false
    );
  }
}