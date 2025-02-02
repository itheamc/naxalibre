import 'package:naxalibre/src/models/location_component_options.dart';
import 'package:naxalibre/src/models/location_settings.dart';
import 'package:naxalibre/src/models/ui_settings.dart';

import 'src/naxalibre_platform_interface.dart';
import 'package:flutter/material.dart';

export 'src/naxalibre_platform_interface.dart';
export 'src/controller/naxalibre_controller.dart';
export 'src/controller/naxalibre_controller_impl.dart';
export 'src/models/camera_update.dart';
export 'src/models/latlng.dart';
export 'src/models/camera_position.dart';
export 'src/models/latlng_bounds.dart';
export 'src/sources/geojson_source.dart';
export 'src/sources/raster_source.dart';
export 'src/layers/circle_layer.dart';
export 'src/layers/fill_extrusion_layer.dart';
export 'src/layers/line_layer.dart';
export 'src/layers/fill_layer.dart';
export 'src/layers/symbol_layer.dart';
export 'src/layers/raster_layer.dart';
export 'src/style_images/network_style_image.dart';
export 'src/style_images/local_style_image.dart';
export 'src/models/style_transition.dart';

class NaxaLibre {
  Future<String?> getPlatformVersion() {
    return NaxaLibrePlatform.instance.getPlatformVersion();
  }
}

class MapLibreView extends StatelessWidget {
  const MapLibreView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = {
      'styleURL':
          'https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json',
      'uiSettings': UiSettings().toArgs(),
      'locationSettings': const LocationSettings(
        locationEnabled: true,
        locationComponentOptions: LocationComponentOptions(
          pulseColor: "green",
          pulseEnabled: true,
          foregroundTintColor: "red",
          backgroundTintColor: "yellow",
          pulseSingleDuration: 1000,
          accuracyColor: "pink"
        )
      ).toArgs()
    };

    return NaxaLibrePlatform.instance.buildMapView(
      creationParams: creationParams,
    );
  }
}
