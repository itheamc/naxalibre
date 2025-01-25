import 'package:naxalibre/src/models/camera_update.dart';
import 'package:naxalibre/src/utils/naxalibre_logger.dart';
import '../layers/layer.dart';
import '../pigeon_generated.dart';
import '../sources/source.dart';
import '../style_images/style_image.dart';
import 'naxalibre_controller.dart';

class NaxaLibreControllerImpl extends NaxaLibreController {
  final _hostApi = NaxaLibreHostApi();

  NaxaLibreControllerImpl() {
    NaxaLibreFlutterApi.setUp(this);
  }

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

  @override
  Future<void> addLayerAbove<T extends Layer>({
    required T layer,
    required String above,
  }) async {
    try {
      await _hostApi.addLayer({
        ...layer.toArgs(),
        "above": above,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerAbove] => $e");
    }
  }

  @override
  Future<void> addLayerAt<T extends Layer>({
    required T layer,
    required int index,
  }) async {
    try {
      await _hostApi.addLayer({
        ...layer.toArgs(),
        "index": index,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerAt] => $e");
    }
  }

  @override
  Future<void> addLayerBelow<T extends Layer>({
    required T layer,
    required String below,
  }) async {
    try {
      await _hostApi.addLayer({
        ...layer.toArgs(),
        "below": below,
      });
    } catch (e) {
      NaxaLibreLogger.logError("[$runtimeType.addLayerBelow] => $e");
    }
  }

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

  @override
  void onCameraIdle() {
    // TODO: implement onCameraIdle
  }

  @override
  void onCameraMove() {
    // TODO: implement onCameraMove
  }

  @override
  void onCameraMoveEnd() {
    // TODO: implement onCameraMoveEnd
  }

  @override
  void onCameraMoveStarted(int? reason) {
    // TODO: implement onCameraMoveStarted
  }

  @override
  void onFling() {
    // TODO: implement onFling
  }

  @override
  void onFpsChanged(double fps) {
    // TODO: implement onFpsChanged
  }

  @override
  void onMapClick(List<double> latLng) async {
    NaxaLibreLogger.logMessage("Clicked: $latLng");
    // try {
      final point = await _hostApi.toScreenLocation(latLng);
      NaxaLibreLogger.logSuccess("[$runtimeType.onMapClick] => $point");

      final features = await _hostApi.queryRenderedFeatures(
        <String, Object?>{
          "point": point,
        },
      );

      NaxaLibreLogger.logMessage("[$runtimeType.onMapClick] => $features");
    // } catch (e) {
    //   NaxaLibreLogger.logError("[$runtimeType.onMapClick] => $e");
    // }
  }

  @override
  void onMapLoaded() {
    NaxaLibreLogger.logMessage("Map Loaded");
  }

  @override
  void onMapLongClick(List<double> latLng) {
    NaxaLibreLogger.logMessage("Long Clicked: $latLng");
  }

  @override
  void onMapRendered() {
    // TODO: implement onMapRendered
  }

  @override
  void onRotate(
      double angleThreshold, double deltaSinceStart, double deltaSinceLast) {
    // TODO: implement onRotate
  }

  @override
  void onRotateEnd(
      double angleThreshold, double deltaSinceStart, double deltaSinceLast) {
    // TODO: implement onRotateEnd
  }

  @override
  void onRotateStarted(
      double angleThreshold, double deltaSinceStart, double deltaSinceLast) {
    // TODO: implement onRotateStarted
  }

  @override
  void onStyleLoaded() {
    // TODO: implement onStyleLoaded
  }
}
