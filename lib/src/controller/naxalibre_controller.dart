import 'package:flutter/foundation.dart';
import 'package:naxalibre/src/models/camera_update.dart';
import 'package:naxalibre/src/models/latlng.dart';
import '../layers/layer.dart';
import '../pigeon_generated.dart';
import '../sources/source.dart';
import '../style_images/style_image.dart';

abstract class NaxaLibreController extends NaxaLibreFlutterApi {

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

  /// Check if a source with the given ID already exists in the map.
  ///
  /// [sourceId]: The ID of the source to check.
  ///
  /// Returns `true` if a source with the specified ID exists; `false` otherwise.
  Future<bool> isSourceExist(String sourceId);

  /// Check if a layer with the given ID already exists in the map.
  ///
  /// [layerId]: The ID of the layer to check.
  ///
  /// Returns `true` if a layer with the specified ID exists; `false` otherwise.
  Future<bool> isLayerExist(String layerId);

  /// Check if a style image with the given ID already exists in the map.
  ///
  /// [imageId]: The ID of the style image to check.
  ///
  /// Returns `true` if a style image with the specified ID exists; `false` otherwise.
  Future<bool> isStyleImageExist(String imageId);

  /// Adds a new source to the map style.
  ///
  /// [source]: The source object to add.
  ///
  /// This method allows you to add various types of sources to the map, such as:
  /// *   [GeoJsonSource]
  /// *   [VectorSource]
  /// *   [RasterSource]
  /// *   [RasterDemSource]
  /// *   [ImageSource]
  /// *   [VideoSource]
  ///
  /// Make sure the source ID is unique.
  ///
  /// Note: Before adding a source, consider checking if a source with the same ID already exists using [isSourceExist].
  ///
  /// This generic method uses a generic type `T` which should be a class that extends the `Source` class.
  /// You should provide a concrete `Source` class instance as argument.
  ///
  /// Throws an error if the input source ID is not unique.
  ///
  /// Throws an exception if the sourceId is duplicate.
  Future<void> addSource<T extends Source>({required T source});

  /// Adds a style layer in the map.
  ///
  /// This method allows you to insert a new style layer
  ///
  /// [layer]: The style layer to be added.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayer<T extends Layer>({required T layer});

  /// Adds a style layer below another layer in the map.
  ///
  /// This method allows you to insert a new style layer underneath an existing one,
  /// allowing for layering effects and control over the drawing order.
  ///
  /// [layer]: The style layer to be added.
  /// [below]: The ID of the existing layer below which the new layer will be placed.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayerBelow<T extends Layer>(
      {required T layer, required String below});

  /// Adds a style layer above another layer in the map.
  ///
  /// This method allows you to insert a new style layer above an existing one,
  /// allowing for layering effects and control over the drawing order.
  ///
  /// [layer]: The style layer to be added.
  /// [above]: The ID of the existing layer above which the new layer will be placed.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  Future<void> addLayerAbove<T extends Layer>(
      {required T layer, required String above});

  /// Adds a style layer at a specific index within the map's layer stack.
  ///
  /// This method allows you to insert a new style layer at a particular index,
  /// giving you precise control over the drawing order and stacking of layers.
  ///
  /// [layer]: The style layer to be added.
  /// [index]: The index at which to insert the new layer.
  ///          The index is zero-based, where 0 represents the bottommost layer.
  ///
  /// Supported Layer Types:
  ///   - [CircleLayer]
  ///   - [FillLayer]
  ///   - [LineLayer]
  ///   - [RasterLayer]
  ///   - [SymbolLayer]
  ///
  /// This method allows you to insert a new style layer at a particular index,
  /// giving you precise control over the drawing order and stacking of layers.
  Future<void> addLayerAt<T extends Layer>(
      {required T layer, required int index});

  /// Removes a previously added source from the map style.
  ///
  /// [sourceId]: The ID of the source to be removed.
  Future<bool> removeSource(String sourceId);

  /// Removes a previously added style layer from the map style.
  ///
  /// [layerId]: The ID of the layer to be removed.
  Future<bool> removeLayer(String layerId);

  /// Removes multiple sources from the map style.
  ///
  /// [sourcesId]: A list of source IDs to be removed.
  Future<bool> removeSources(List<String> sourcesId);

  /// Removes multiple style layers from the map style.
  ///
  /// [layersId]: A list of layer IDs to be removed.
  Future<bool> removeLayers(List<String> layersId);

  /// Adds a style image to the map style.
  ///
  /// The image can be a network image or a local image.
  ///
  /// [image]: The style image to be added.
  ///  i.e., - NetworkStyleImage or LocalStyleImage
  Future<bool> addStyleImage<T extends StyleImage>({required T image});

  /// Removes a previously added style image from the map.
  ///
  /// [imageId]: The ID of the style image to be removed.
  Future<bool> removeStyleImage(String imageId);

  /// Method to get the user's last known location
  ///
  Future<LatLng?> lastKnownLocation();

  /// Method to get snapshot of the map
  ///
  Future<Uint8List?> snapshot();

  /// Method to trigger repaint
  ///
  Future<void> triggerRepaint();
}
