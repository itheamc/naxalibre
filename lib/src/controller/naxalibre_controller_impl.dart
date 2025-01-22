import 'package:naxalibre/src/models/camera_update.dart';
import 'package:naxalibre/src/utils/naxalibre_logger.dart';
import '../layers/layer.dart';
import '../pigeon_generated.dart';
import '../sources/source.dart';
import '../style_images/style_image.dart';
import 'naxalibre_controller.dart';

class NaxaLibreControllerImpl extends NaxaLibreController {
  final _hostApi = NaxaLibreHostApi();

  /// Method to animate camera
  /// [cameraUpdate] New camera update to move camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    int? duration,
  }) async {
    try {
      await _hostApi.animateCamera({
        ...cameraUpdate.toArgs(),
        "duration": duration,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.animateCamera] => $e");
    }
  }

  /// Method to ease camera
  /// [cameraUpdate] New camera update to animate camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  @override
  Future<void> easeCamera(
    CameraUpdate cameraUpdate, {
    int? duration,
  }) async {
    try {
      await _hostApi.easeCamera({
        ...cameraUpdate.toArgs(),
        "duration": duration,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.easeCamera] => $e");
    }
  }

  /// Method to check if source is already existed
  ///
  @override
  Future<bool> isSourceExist(String sourceId) async {
    try {
      final source = await _hostApi.getSource(sourceId);
      return source.isNotEmpty;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isSourceExist] => $e");
      return false;
    }
  }

  /// Method to check if layer is already existed
  @override
  Future<bool> isLayerExist(String layerId) async {
    try {
      final layer = await _hostApi.getLayer(layerId);
      return layer.isNotEmpty;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isLayerExist] => $e");
      return false;
    }
  }

  /// Method to check if style image is already existed
  @override
  Future<bool> isStyleImageExist(String imageId) async {
    try {
      final image = await _hostApi.getImage(imageId);
      return image.isNotEmpty;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.isStyleImageExist] => $e");
      return false;
    }
  }

  /// Generic method to add style source
  /// You can add:
  /// - [GeoJsonSource]
  /// - [VectorSource]
  /// - [RasterSource]
  /// - [RasterDemSource] and
  /// - [ImageSource]
  @override
  Future<void> addSource<T extends Source>({
    required T source,
  }) async {
    try {
      await _hostApi.addSource(source.toArgs());
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addSource] => $e");
    }
  }

  /// Generic method to add style layer
  /// You can add:
  /// - CircleLayer
  /// - FillLayer
  /// - LineLayer
  /// - RasterLayer and
  /// - SymbolLayer
  @override
  Future<void> addLayer<T extends Layer>({
    required T layer,
  }) async {
    try {
      await _hostApi.addLayer(layer.toArgs());
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayer] => $e");
    }
  }

  /// Method to remove added source
  /// [sourceId] - An id of the source that you want to remove
  @override
  Future<bool> removeSource(String sourceId) async {
    try {
      await _hostApi.removeSource(sourceId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeSource] => $e");
      return false;
    }
  }

  /// Method to remove added style layer
  /// [layerId] - An id of style layer that you want to remove
  @override
  Future<bool> removeLayer(String layerId) async {
    try {
      await _hostApi.removeLayer(layerId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeLayer] => $e");
      return false;
    }
  }

  /// Method to remove list of added sources
  /// [sourcesId] - List of sources id that you want to remove
  @override
  Future<bool> removeSources(List<String> sourcesId) async {
    try {
      for (final id in sourcesId) {
        if (await isSourceExist(id)) {
          await removeSource(id);
        }
      }
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeSources] => $e");
      return false;
    }
  }

  /// Method to remove list of added style layers
  /// [layersId] - List of layers id that you want to remove
  @override
  Future<bool> removeLayers(List<String> layersId) async {
    try {
      for (final id in layersId) {
        if (await isLayerExist(id)) {
          await removeLayer(id);
        }
      }
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeLayers] => $e");
      return false;
    }
  }

  /// Method to add style image from assets
  /// [image] - Image
  /// i.e. - NetworkStyleImage or LocalStyleImage
  @override
  Future<bool> addStyleImage<T extends StyleImage>({required T image}) async {
    try {
      final bytes = await image.getByteArray();
      await _hostApi.addImage(image.imageId, bytes!);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addStyleImage] => $e");
      return false;
    }
  }

  /// Method to remove style image
  /// [imageId] - An id of style image that you want to remove
  @override
  Future<bool> removeStyleImage(String imageId) async {
    try {
      await _hostApi.removeImage(imageId);
      return true;
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.removeStyleImage] => $e");
      return false;
    }
  }
}
