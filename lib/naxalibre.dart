import 'src/naxalibre_platform_interface.dart';

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
export 'src/naxalibre.dart';
export 'src/models/rendered_coordinates.dart';
export 'src/models/location_settings.dart';
export 'src/models/location_component_options.dart';
export 'src/models/location_engine_request_options.dart';
export 'src/models/naxalibre_map_options.dart';

class NaxaLibre {
  Future<String?> getPlatformVersion() {
    return NaxaLibrePlatform.instance.getPlatformVersion();
  }
}
