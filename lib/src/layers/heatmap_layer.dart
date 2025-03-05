part of 'layer.dart';

/// HeatmapLayer class
///
/// Represents a layer that visualizes data points as a heatmap. Heatmaps are
/// often used to depict intensity or density of data, such as population
/// distribution or event frequency. This class inherits from the [Layer] class
/// and provides specific properties for heatmap styling.
///
class HeatmapLayer extends Layer<HeatmapLayerProperties> {
  /// Constructor for HeatmapLayer
  ///
  /// Initializes a new instance of the HeatmapLayer with the specified
  /// [layerId], [sourceId], and optional [layerProperties].
  ///
  /// Parameters:
  /// - [layerId]: The unique identifier for this layer.
  /// - [sourceId]: The identifier of the source to which this layer is applied.
  /// - [layerProperties]: Optional properties specific to the HeatmapLayer.
  ///   Defaults to [HeatmapLayerProperties.defaultProperties] if not provided.
  HeatmapLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "heatmap-layer");

  /// Method to convert the HeatmapLayer Object to the
  /// Map data to pass to the native platform through args
  ///
  /// Converts the HeatmapLayer object and its properties into a map that can
  /// be passed to the native platform. It includes the `layerId`, `sourceId`,
  /// and the serialized `layerProperties`. If no custom properties are provided,
  /// default properties are used.
  ///
  /// Returns:
  /// A `Map[String, dynamic]` representing the serialized HeatmapLayer.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? HeatmapLayerProperties.defaultProperties)
              .toArgs(),
    };
  }
}

/// HeatmapLayerProperties class
/// It contains all the properties for the heatmap layer
/// e.g.
/// final heatmapLayerProperties = HeatmapLayerProperties(
///                             heatmapIntensity: 1.0,
///                         );
class HeatmapLayerProperties extends LayerProperties {
  /// Defines the color of each pixel based on its density value in a heatmap.
  /// Should be an expression that uses `["heatmap-density"]` as input.
  /// Accepted data type:
  /// - Expression
  final dynamic heatmapColor;

  /// Similar to `heatmap-weight` but controls the intensity of the heatmap
  /// globally. Primarily used for adjusting the heatmap based on zoom level.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic heatmapIntensity;

  /// Transition for similar to `heatmap-weight` but controls the intensity of the heatmap
  /// globally. Primarily used for adjusting the heatmap based on zoom level.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? heatmapIntensityTransition;

  /// The global opacity at which the heatmap layer will be drawn.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic heatmapOpacity;

  /// Transition for the global opacity at which the heatmap layer will be drawn.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? heatmapOpacityTransition;

  /// Radius of influence of one heatmap point in pixels.
  /// Increasing the value makes the heatmap smoother, but less detailed.
  /// `queryRenderedFeatures` on heatmap layers will return points within
  /// this radius.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 30.0
  final dynamic heatmapRadius;

  /// Transition for radius of influence of one heatmap point in pixels.
  /// Increasing the value makes the heatmap smoother, but less detailed.
  /// `queryRenderedFeatures` on heatmap layers will return points within
  /// this radius.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? heatmapRadiusTransition;

  /// A measure of how much an individual point contributes to the heatmap.
  /// A value of 10 would be equivalent to having 10 points of weight 1 in
  /// the same spot. Especially useful when combined with clustering.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic heatmapWeight;

  /// A filter is a property at the layer level that determines which features
  /// should be rendered in a style layer.
  /// Filters are written as expressions, which give you fine-grained control
  /// over which features to include: the style layer only displays the
  /// features that match the filter condition that you define.
  /// Note: Zoom expressions in filters are only evaluated at integer zoom
  /// levels. The feature-state expression is not supported in filter
  /// expressions.
  /// Accepted data type - Expression
  final dynamic filter;

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
  HeatmapLayerProperties({
    this.heatmapColor,
    this.heatmapIntensity,
    this.heatmapIntensityTransition,
    this.heatmapOpacity,
    this.heatmapOpacityTransition,
    this.heatmapRadius,
    this.heatmapRadiusTransition,
    this.heatmapWeight,
    this.filter,
    this.sourceLayer,
    this.visibility,
    this.minZoom,
    this.maxZoom,
  });

  /// Default HeatmapLayerProperties
  static HeatmapLayerProperties get defaultProperties {
    return HeatmapLayerProperties(
      heatmapIntensity: 1.0,
      heatmapIntensityTransition: StyleTransition.build(
        delay: 275,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Method to proceeds the heatmap layer properties for native
  /// Converts the properties of the HeatmapLayer into a map format.
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
    insert('filter', filter);

    // Layout properties
    final layoutArgs = _heatmapLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _heatmapPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _heatmapTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _heatmapLayoutArgs() {
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
  Map<String, dynamic> _heatmapPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('heatmap-color', heatmapColor);
    insert('heatmap-intensity', heatmapIntensity);
    insert('heatmap-opacity', heatmapOpacity);
    insert('heatmap-radius', heatmapRadius);
    insert('heatmap-weight', heatmapWeight);

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _heatmapTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('heatmap-intensity-transition', heatmapIntensityTransition);
    insert('heatmap-opacity-transition', heatmapOpacityTransition);
    insert('heatmap-radius-transition', heatmapRadiusTransition);

    return transitionsArgs;
  }
}
