import 'package:naxalibre/src/models/camera_update.dart';
import '../layers/layer.dart';
import '../sources/source.dart';
import '../style_images/style_image.dart';

abstract class NaxaLibreController {
  /// Method to animate camera
  /// [cameraUpdate] New camera update to move camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    int? duration,
  });

  /// Method to ease camera
  /// [cameraUpdate] New camera update to animate camera
  /// e.g.
  /// ```
  /// final cameraUpdate = CameraUpdateFactory.newLatLng((
  ///   latLng: LatLng(27.34, 85.73),
  /// );
  /// ```
  Future<void> easeCamera(
    CameraUpdate cameraUpdate, {
    int? duration,
  });

  /// Method to check if source is already existed
  Future<bool> isSourceExist(String sourceId);

  /// Method to check if layer is already existed
  Future<bool> isLayerExist(String layerId);

  /// Method to check if style image is already existed
  Future<bool> isStyleImageExist(String imageId);

  /// Generic method to add style source
  /// You can add:
  /// - GeoJsonSource
  /// - VectorSource
  /// - RasterSource
  /// - RasterDemSource
  /// - ImageSource and
  /// - VideoSource
  Future<void> addSource<T extends Source>({required T source});

  /// Generic method to add style layer
  /// You can add:
  /// - CircleLayer
  /// - FillLayer
  /// - LineLayer
  /// - RasterLayer and
  /// - SymbolLayer
  Future<void> addLayer<T extends Layer>({required T layer});

  /// Method to remove added source
  /// [sourceId] - An id of the source that you want to remove
  Future<bool> removeSource(String sourceId);

  /// Method to remove added style layer
  /// [layerId] - An id of style layer that you want to remove
  Future<bool> removeLayer(String layerId);

  /// Method to remove list of added sources
  /// [sourcesId] - List of sources id that you want to remove
  Future<bool> removeSources(List<String> sourcesId);

  /// Method to remove list of added style layers
  /// [layersId] - List of layers id that you want to remove
  Future<bool> removeLayers(List<String> layersId);

  /// Method to add style image from assets
  /// [image] - Image
  /// i.e. - NetworkStyleImage or LocalStyleImage
  Future<bool> addStyleImage<T extends StyleImage>({required T image});

  /// Method to remove style image
  /// [imageId] - An id of style image that you want to remove
  Future<bool> removeStyleImage(String imageId);
}
