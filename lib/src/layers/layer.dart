import 'dart:convert';

import '../enums/enums.dart';
import '../models/style_transition.dart';

part 'background_layer.dart';
part 'circle_layer.dart';
part 'fill_layer.dart';
part 'fill_extrusion_layer.dart';
part 'heatmap_layer.dart';
part 'hill_shade_layer.dart';
part 'layer_properties.dart';
part 'line_layer.dart';
part 'raster_layer.dart';
part 'symbol_layer.dart';

/// Abstract Layer class
///
/// A base class for map layers. This class defines common properties for layers
/// in a map style, such as the `sourceId`, `layerId`, and `layerProperties`.
/// It provides an abstract method `toArgs()` that should be implemented by
/// subclasses to convert the layer into a map format suitable for communication
/// with the native platform.
///
abstract class Layer<T> {
  /// [sourceId] - Id of the source on which you apply to this layer
  ///
  /// Represents the unique identifier for the data source that this layer
  /// is associated with. It is used to link the layer to a specific data source.
  final String sourceId;

  /// [layerId] - An unique identifier for the style layer
  ///
  /// A unique identifier for the layer itself. It is used to differentiate
  /// layers within the map style and is essential for managing layer visibility
  /// and other properties.
  final String layerId;

  /// LayerProperties
  ///
  /// The properties of the layer, which can vary depending on the type of layer
  /// (e.g., symbol layer, raster layer). The default value is
  /// `<T>LayerProperties.defaultProperties` if no custom properties are provided.
  final T? layerProperties;

  /// [type] - Type of the layer
  ///
  /// (e.g., symbol layer, raster layer)
  ///
  final String type;

  /// Constructor
  ///
  /// Creates a new instance of the Layer with the specified [layerId], [sourceId],
  /// and optional [layerProperties].
  Layer({
    required this.layerId,
    required this.sourceId,
    required this.type,
    this.layerProperties,
  });

  /// Method to convert Layer object to Map
  ///
  /// Converts the layer object, including its properties, to a map format that
  /// can be passed to the native platform. The map includes information like
  /// the `layerId`, `sourceId`, and serialized `layerProperties`.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the serialized layer and its properties.
  Map<String, Object?> toArgs();
}
