part of 'layer.dart';

/// A class representing a fill extrusion layer in a map.
/// This layer is used to display 3D extruded polygons, adding depth to visualizations.
///
/// The `FillExtrusionLayer` class extends the base `Layer` class and provides
/// properties to define the behavior and appearance of fill extrusion layers.
///
/// Example usage:
/// ```dart
/// final fillExtrusionLayer = FillExtrusionLayer(
///   layerId: "fill-extrusion-layer",
///   sourceId: "source-id",
///   layerProperties: FillExtrusionLayerProperties(
///     fillExtrusionHeight: 10.0,
///     fillExtrusionColor: "rgba(0, 255, 0, 0.5)",
///   ),
/// );
/// ```
///
class FillExtrusionLayer extends Layer<FillExtrusionLayerProperties> {
  /// Constructs a [FillExtrusionLayer].
  ///
  /// - [layerId] is the unique identifier for this layer.
  /// - [sourceId] specifies the source of the data for this layer.
  /// - [layerProperties] (optional) defines additional properties for the layer,
  ///   such as extrusion height, color, and other visual effects.
  FillExtrusionLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "fill-extrusion-layer");

  /// Converts the `FillExtrusionLayer` object into a map format.
  ///
  /// This method is used to serialize the layer's data and properties,
  /// making it suitable for communication with the native platform.
  ///
  /// Returns a map containing:
  /// - `"layerId"`: The unique identifier for the layer.
  /// - `"sourceId"`: The source of the data for the layer.
  /// - `"layerProperties"`: The layer's properties, either the provided
  ///   `layerProperties` or the default properties if none are specified.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? FillExtrusionLayerProperties.defaultProperties)
              .toArgs(),
    };
  }
}

/// FillExtrusionLayerProperties class
/// It contains all the properties for the fill extrusion layer
/// e.g.
/// final fillExtrusionLayerProperties = FillExtrusionLayerProperties(
///                             fillExtrusionColor: '#000000',
///                         );
class FillExtrusionLayerProperties extends LayerProperties {
  /// Controls the intensity of ambient occlusion (AO) shading.
  /// Current AO implementation is a low-cost best-effort approach that shades
  /// area near ground and concave angles between walls. Default value 0.0
  /// disables ambient occlusion and values around 0.3 provide the most
  /// plausible results for buildings.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic fillExtrusionAmbientOcclusionIntensity;

  /// Transition for intensity of ambient occlusion (AO) shading.
  /// Current AO implementation is a low-cost best-effort approach that
  /// shades area near ground and concave angles between walls.
  /// Default value 0.0 disables ambient occlusion and values around 0.3
  /// provide the most plausible results for buildings.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionAmbientOcclusionIntensityTransition;

  /// The radius of ambient occlusion (AO) shading, in meters.
  /// Current AO implementation is a low-cost best-effort approach that
  /// shades area near ground and concave angles between walls where the
  /// radius defines only vertical impact. Default value 3.0 corresponds
  /// to height of one floor and brings the most plausible
  /// results for buildings.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 3.0
  final dynamic fillExtrusionAmbientOcclusionRadius;

  /// Transition for the radius of ambient occlusion (AO) shading, in meters.
  /// Current AO implementation is a low-cost best-effort approach that shades
  /// area near ground and concave angles between walls where the radius
  /// defines only vertical impact. Default value 3.0 corresponds to height
  /// of one floor and brings the most plausible results for buildings.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionAmbientOcclusionRadiusTransition;

  /// The height with which to extrude the base of this layer.
  /// Must be less than or equal to `fill-extrusion-height`.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic fillExtrusionBase;

  /// Transition for the height with which to extrude the base of this layer.
  /// Must be less than or equal to `fill-extrusion-height`.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionBaseTransition;

  /// The base color of the extruded fill.
  /// The extrusion's surfaces will be shaded differently based on this color
  /// in combination with the root `light` settings. If this color is specified
  /// as `rgba` with an alpha component, the alpha component will be ignored;
  /// use `fill-extrusion-opacity` to set layer opacity.
  /// Accepted data type:
  /// - String
  /// - int and
  /// - Expression
  /// default value is '#000000'
  final dynamic fillExtrusionColor;

  /// Transition for the base color of the extruded fill.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionColorTransition;

  /// The height with which to extrude this layer.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic fillExtrusionHeight;

  /// Transition for the height with which to extrude this layer.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionHeightTransition;

  /// The opacity of the entire fill extrusion layer. This is rendered on
  /// a per-layer, not per-feature, basis, and data-driven styling
  /// is not available.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic fillExtrusionOpacity;

  /// Transition for the opacity of the entire fill extrusion layer.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionOpacityTransition;

  /// Name of image in sprite to use for drawing images on extruded fills.
  /// For seamless patterns, image width and height must be a factor of two
  /// (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be
  /// evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - String and
  /// - Expression
  final dynamic fillExtrusionPattern;

  /// Transition for fillExtrusionPattern
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionPatternTransition;

  /// The geometry's offset. Values are [x, y] where negatives indicate
  /// left and up (on the flat plane), respectively.
  /// Accepted data type:
  /// - List of double and
  /// - Expression
  /// default value is [0.0, 0.0]
  final dynamic fillExtrusionTranslate;

  /// Transition for fillExtrusionTranslate
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillExtrusionTranslateTransition;

  /// Controls the frame of reference for `fill-extrusion-translate`.
  /// Accepted data type:
  /// - FillExtrusionTranslateAnchor and
  /// Expression
  /// default value is FillExtrusionTranslateAnchor.map
  final dynamic fillExtrusionTranslateAnchor;

  /// Whether to apply a vertical gradient to the sides of a
  /// fill-extrusion layer. If true, sides will be shaded slightly
  /// darker farther down.
  /// Accepted data type:
  /// - bool and
  /// Expression
  /// default value is true
  final dynamic fillExtrusionVerticalGradient;

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

  /// Whether this layer should be visible or not.
  /// Accepted data type - [LayerVisibility]
  /// default value is LayerVisibility.visible
  ///
  final LayerVisibility visibility;

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
  FillExtrusionLayerProperties({
    this.fillExtrusionAmbientOcclusionIntensity,
    this.fillExtrusionAmbientOcclusionIntensityTransition,
    this.fillExtrusionAmbientOcclusionRadius,
    this.fillExtrusionAmbientOcclusionRadiusTransition,
    this.fillExtrusionBase,
    this.fillExtrusionBaseTransition,
    this.fillExtrusionColor,
    this.fillExtrusionColorTransition,
    this.fillExtrusionHeight,
    this.fillExtrusionHeightTransition,
    this.fillExtrusionOpacity,
    this.fillExtrusionOpacityTransition,
    this.fillExtrusionPattern,
    this.fillExtrusionPatternTransition,
    this.fillExtrusionTranslate,
    this.fillExtrusionTranslateTransition,
    this.fillExtrusionTranslateAnchor,
    this.fillExtrusionVerticalGradient,
    this.filter,
    this.sourceLayer,
    this.visibility = LayerVisibility.visible,
    this.minZoom,
    this.maxZoom,
  });

  /// Default FillExtrusionLayerProperties
  static FillExtrusionLayerProperties get defaultProperties {
    return FillExtrusionLayerProperties(
      // heatmapIntensity: 1.0,
      // heatmapIntensityTransition: StyleTransition.build(
      //   delay: 275,
      //   duration: const Duration(milliseconds: 500),
      // ),
    );
  }

  /// Converts the properties of the FillExtrusionLayer into a map format.
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
    final layoutArgs = _fillExtrusionLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _fillExtrusionPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _fillExtrusionTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _fillExtrusionLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('visibility', visibility.name);

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _fillExtrusionPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert(
      'fill-extrusion-ambient-occlusion-intensity',
      fillExtrusionAmbientOcclusionIntensity,
    );

    insert(
      'fill-extrusion-ambient-occlusion-radius',
      fillExtrusionAmbientOcclusionRadius,
    );

    insert('fill-extrusion-base', fillExtrusionBase);

    insert('fill-extrusion-color', fillExtrusionColor);

    insert('fill-extrusion-height', fillExtrusionHeight);

    insert('fill-extrusion-opacity', fillExtrusionOpacity);

    insert('fill-extrusion-pattern', fillExtrusionPattern);
    insert('fill-extrusion-vertical-gradient', fillExtrusionVerticalGradient);

    if (fillExtrusionTranslate != null && fillExtrusionTranslate is List) {
      paintArgs['fill-extrusion-translate'] = fillExtrusionTranslate;
    }

    // Handle enums or lists for specific keys
    if (fillExtrusionTranslateAnchor != null) {
      paintArgs['fill-extrusion-translate-anchor'] =
          fillExtrusionTranslateAnchor is FillExtrusionTranslateAnchor
              ? fillExtrusionTranslateAnchor.name
              : fillExtrusionTranslateAnchor is List
              ? jsonEncode(fillExtrusionTranslateAnchor)
              : fillExtrusionTranslateAnchor;
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _fillExtrusionTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert(
      'fill-extrusion-ambient-occlusion-intensity',
      fillExtrusionAmbientOcclusionIntensityTransition,
    );
    insert(
      'fill-extrusion-ambient-occlusion-radius',
      fillExtrusionAmbientOcclusionRadiusTransition,
    );
    insert('fill-extrusion-base', fillExtrusionBaseTransition);
    insert('fill-extrusion-color', fillExtrusionColorTransition);
    insert('fill-extrusion-height', fillExtrusionHeightTransition);
    insert('fill-extrusion-opacity', fillExtrusionOpacityTransition);
    insert('fill-extrusion-pattern', fillExtrusionPatternTransition);
    insert('fill-extrusion-translate', fillExtrusionTranslateTransition);
    return transitionsArgs;
  }
}
