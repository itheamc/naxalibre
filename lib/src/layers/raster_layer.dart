part of 'layer.dart';

/// RasterLayer class
///
/// A class representing a raster layer in a Map. It extends the `Layer` class
/// and is used to display raster data, such as images or textures, on the map.
/// This layer is typically used for displaying aerial imagery, terrain data,
/// or other types of raster-based information.
///
class RasterLayer extends Layer<RasterLayerProperties> {
  /// Constructor for RasterLayer
  ///
  /// Creates a new RasterLayer with the provided [layerId] and [sourceId].
  /// The [layerProperties] are optional, and if not provided, default properties
  /// will be used.
  ///
  /// [layerId] - A unique identifier for the layer.
  /// [sourceId] - The source identifier, typically a reference to the raster data source.
  /// [layerProperties] - An optional property object to configure the layer's behavior.
  RasterLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "raster-layer");

  /// Method to convert the RasterLayer object to a map data structure
  /// for communication with the native platform.
  ///
  /// This method serializes the layer's properties into a `Map[String, dynamic]`
  /// format, which can then be passed to the native platform via method channels.
  ///
  /// Returns:
  /// A map with the keys:
  /// - "layerId" (String): The unique identifier of the layer.
  /// - "sourceId" (String): The source identifier, typically a reference to the raster data.
  /// - "layerProperties" (Map[String, dynamic]): The properties of the layer, or default properties if not provided.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? RasterLayerProperties.defaultProperties).toArgs(),
    };
  }
}

/// RasterLayerProperties class
/// It contains all the properties for the raster layer
/// e.g.
/// final rasterLayerProperties = RasterLayerProperties(
///                             rasterBrightnessMax: 0.88,
///                         );
class RasterLayerProperties extends LayerProperties {
  /// Increase or reduce the brightness of the image.
  /// The value is the maximum brightness.
  /// Accepted data type - double or expression
  /// default value is 1.0
  final dynamic rasterBrightnessMax;

  /// Increase or reduce the brightness of the image.
  /// The value is the maximum brightness.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterBrightnessMaxTransition;

  /// Increase or reduce the brightness of the image.
  /// The value is the minimum brightness.
  /// Accepted data type - double or expression
  /// default value is 0.0
  final dynamic rasterBrightnessMin;

  /// Increase or reduce the brightness of the image.
  /// The value is the minimum brightness.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterBrightnessMinTransition;

  /// Increase or reduce the contrast of the image.
  /// Accepted data type - double or expression
  /// default value is 0.0
  final dynamic rasterContrast;

  /// Increase or reduce the contrast of the image.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterContrastTransition;

  /// Fade duration when a new tile is added.
  /// Accepted data type - double or expression
  /// default value is 300.0
  final dynamic rasterFadeDuration;

  /// Rotates hues around the color wheel.
  /// Accepted data type - double or expression
  /// default value is 0.0
  final dynamic rasterHueRotate;

  /// Rotates hues around the color wheel.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterHueRotateTransition;

  /// The opacity at which the image will be drawn.
  /// Accepted data type - double or expression
  /// default value is 1.0
  final dynamic rasterOpacity;

  /// The opacity at which the image will be drawn.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterOpacityTransition;

  /// The resampling/interpolation method to use for overscaling,
  /// also known as texture magnification filter
  /// Accepted data type - RasterResampling ro Expression
  /// default value is RasterResampling.linear
  final dynamic rasterResampling;

  /// Increase or reduce the saturation of the image.
  /// Accepted data type - double or expression
  /// default value is 0.0
  final dynamic rasterSaturation;

  /// Increase or reduce the saturation of the image.
  /// Accepted data type - StyleTransition
  final StyleTransition? rasterSaturationTransition;

  /// A source layer is an individual layer of data within a vector source.
  /// Accepted data type - String
  final dynamic sourceLayer;

  /// Whether this layer is displayed.
  /// Accepted data type - bool
  /// default value is true
  final dynamic visibility;

  /// The minimum zoom level for the layer. At zoom levels less than
  /// the min-zoom, the layer will be hidden.
  /// Accepted data type - double
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  ///
  final dynamic minZoom;

  /// The maximum zoom level for the layer. At zoom levels equal to or
  /// greater than the max-zoom, the layer will be hidden.
  /// Accepted data type - double
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  ///
  final dynamic maxZoom;

  /// Constructor
  RasterLayerProperties({
    this.rasterBrightnessMax,
    this.rasterBrightnessMaxTransition,
    this.rasterBrightnessMin,
    this.rasterBrightnessMinTransition,
    this.rasterContrast,
    this.rasterContrastTransition,
    this.rasterFadeDuration,
    this.rasterHueRotate,
    this.rasterHueRotateTransition,
    this.rasterOpacity,
    this.rasterOpacityTransition,
    this.rasterResampling,
    this.rasterSaturation,
    this.rasterSaturationTransition,
    this.sourceLayer,
    this.visibility,
    this.minZoom,
    this.maxZoom,
  });

  /// Default RasterLayerProperties
  static RasterLayerProperties get defaultProperties {
    return RasterLayerProperties(
      rasterBrightnessMax: 1.0,
      rasterBrightnessMaxTransition: StyleTransition.build(
        delay: 300,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Method to proceeds the fill layer properties for native
  /// Converts the properties of the RasterLayer into a map format.
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        args[key] = value is List ? jsonEncode(value) : value;
      }
    }

    // Add layer-specific properties
    insert('source-layer', sourceLayer);
    insert('maxzoom', maxZoom);
    insert('minzoom', minZoom);

    // Layout properties
    final layoutArgs = _rasterLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _rasterPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _rasterTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _rasterLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('visibility', visibility);

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _rasterPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('raster-brightness-max', rasterBrightnessMax);
    insert('raster-brightness-min', rasterBrightnessMin);
    insert('raster-contrast', rasterContrast);
    insert('raster-fade-duration', rasterFadeDuration);
    insert('raster-hue-rotate', rasterHueRotate);
    insert('raster-opacity', rasterOpacity);
    insert('raster-saturation', rasterSaturation);

    if (rasterResampling != null) {
      paintArgs['raster-resampling'] = rasterResampling is RasterResampling
          ? rasterResampling.name
          : jsonEncode(rasterResampling);
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _rasterTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('raster-brightness-max-transition', rasterBrightnessMaxTransition);
    insert('raster-brightness-min-transition', rasterBrightnessMinTransition);
    insert('raster-saturation-transition', rasterSaturationTransition);
    insert('raster-opacity-transition', rasterOpacityTransition);
    insert('raster-hue-rotate-transition', rasterHueRotateTransition);
    insert('raster-contrast-transition', rasterContrastTransition);

    return transitionsArgs;
  }
}
