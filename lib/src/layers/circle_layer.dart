part of 'layer.dart';

/// The `CircleLayer` class represents a layer that displays circles on the map.
///
/// This class is used to define a circle layer with properties such as its unique
/// identifier, associated data source, and customizable properties for the layer.
///
class CircleLayer extends Layer<CircleLayerProperties> {
  /// Constructs a `CircleLayer` instance.
  ///
  /// [layerId]: A unique identifier for the layer.
  /// [sourceId]: The identifier of the data source that the layer uses.
  /// [layerProperties]: Optional properties for the layer. If not provided,
  /// the default circle layer properties are used.
  CircleLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "circle-layer");

  /// Converts the `CircleLayer` object to a map representation.
  ///
  /// This method prepares the `CircleLayer` instance for communication with
  /// native platforms by serializing its data into a map format.
  ///
  /// Returns:
  /// - A `Map[String, dynamic]` containing:
  ///   - `"layerId"`: The unique identifier for the layer.
  ///   - `"sourceId"`: The identifier for the associated data source.
  ///   - `"layerProperties"`: A map representation of the layer's properties,
  ///     using default properties if none are explicitly set.
  ///
  /// Example:
  /// ```dart
  /// final circleLayer = CircleLayer(
  ///   layerId: "circleLayerId",
  ///   sourceId: "sourceId",
  ///   layerProperties: CircleLayerProperties.defaultProperties,
  /// );
  /// final mapData = circleLayer.toMap();
  /// ```
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? CircleLayerProperties.defaultProperties).toArgs(),
    };
  }
}

/// CircleLayerProperties class
/// It contains all the properties for the circle layer
/// e.g.
/// final circleLayerProperties = CircleLayerProperties(
///                             circleColor: 'green',
///                             circleRadius: 10.0,
///                             circleStrokeWidth: 2.0,
///                             circleStrokeColor: "#fff",
///                             circleColor: 'green',
///                         );
class CircleLayerProperties extends LayerProperties {
  /// The fill color of the circle.
  /// Accepted data type:
  /// - String,
  /// - Int and
  /// - Expression
  /// default value is '#0000'
  final dynamic circleColor;

  /// StyleTransition for circleColor
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleColorTransition;

  /// Circle radius.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 5.0
  final dynamic circleRadius;

  /// StyleTransition for circleRadius
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleRadiusTransition;

  /// Amount to blur the circle. 1 blurs the circle such that only the
  /// center point is full opacity.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 0.0
  final dynamic circleBlur;

  /// StyleTransition for circleBlur
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleBlurTransition;

  /// The opacity at which the circle will be drawn.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 1.0
  final dynamic circleOpacity;

  /// StyleTransition for circleOpacity
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleOpacityTransition;

  /// The stroke color of the circle.
  /// Accepted data type:
  /// - String
  /// - Int and
  /// - Expression
  /// default value is '#000'
  final dynamic circleStrokeColor;

  /// StyleTransition for circleStrokeColor
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleStrokeColorTransition;

  /// The width of the circle's stroke. Strokes are placed outside
  /// of the circle-radius.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 0.0
  final dynamic circleStrokeWidth;

  /// StyleTransition for circleStrokeWidth
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleStrokeWidthTransition;

  /// The opacity of the circle's stroke
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 1.0
  final dynamic circleStrokeOpacity;

  /// StyleTransition for circleStrokeOpacity
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleStrokeOpacityTransition;

  /// Controls the scaling behavior of the circle when the map is pitched
  /// Accepted data type:
  /// - CirclePitchScale and
  /// - Expression
  /// default value is CirclePitchScale.map
  final dynamic circlePitchScale;

  /// Orientation of circle when map is pitched.
  /// Accepted data type:
  /// - CirclePitchAlignment and
  /// - Expression
  /// default value is CirclePitchAlignment.viewport
  final dynamic circlePitchAlignment;

  /// Sorts features in ascending order based on this value.
  /// Features with a higher sort key will appear above features
  /// with a lower sort key.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  final dynamic circleSortKey;

  /// The geometry's offset. Values are x, y where negatives indicate
  /// left and up, respectively.
  /// Accepted data type:
  /// - List of double and
  /// - Expression
  final dynamic circleTranslate;

  /// StyleTransition for circleTranslate
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? circleTranslateTransition;

  /// Controls the frame of reference for circle-translate
  /// Accepted data type:
  /// - CircleTranslateAnchor and
  /// - Expression
  /// default value is CircleTranslateAnchor.map
  final dynamic circleTranslateAnchor;

  /// A source layer is an individual layer of data within a vector source.
  /// A vector source can have multiple source layers.
  /// Accepted data type:
  /// - String
  final String? sourceLayer;

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
  CircleLayerProperties({
    this.circleColor,
    this.circleColorTransition,
    this.circleRadius,
    this.circleRadiusTransition,
    this.circleBlur,
    this.circleBlurTransition,
    this.circleOpacity,
    this.circleOpacityTransition,
    this.circleStrokeColor,
    this.circleStrokeColorTransition,
    this.circleStrokeWidth,
    this.circleStrokeWidthTransition,
    this.circleStrokeOpacity,
    this.circleStrokeOpacityTransition,
    this.circlePitchScale,
    this.circlePitchAlignment,
    this.circleSortKey,
    this.circleTranslate,
    this.circleTranslateTransition,
    this.circleTranslateAnchor,
    this.sourceLayer,
    this.filter,
    this.maxZoom,
    this.minZoom,
    this.visibility = LayerVisibility.visible,
  });

  /// Default Circle layer properties
  static CircleLayerProperties get defaultProperties {
    return CircleLayerProperties(
      circleColor: 'blue',
      circleColorTransition: StyleTransition.build(
        delay: 300,
        duration: const Duration(milliseconds: 500),
      ),
      circleRadius: 10.0,
      circleStrokeWidth: 2.0,
      circleStrokeColor: "#fff",
    );
  }

  /// Method to proceeds the circle layer properties for native
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    // Helper function to handle list or single value encoding
    void insert(String key, dynamic value) {
      if (value != null) {
        args[key] = value is List ? jsonEncode(value) : value;
      }
    }

    // Layer properties
    insert('source-layer', sourceLayer);
    insert('filter', filter);
    insert('maxzoom', maxZoom);
    insert('minzoom', minZoom);

    // Layout properties
    final layoutArgs = _circleLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _circlePaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _circleTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _circleLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('circle-sort-key', circleSortKey);
    insert('visibility', visibility.name);

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _circlePaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('circle-color', circleColor);
    insert('circle-radius', circleRadius);
    insert('circle-blur', circleBlur);
    insert('circle-opacity', circleOpacity);
    insert('circle-stroke-color', circleStrokeColor);
    insert('circle-stroke-width', circleStrokeWidth);
    insert('circle-stroke-opacity', circleStrokeOpacity);
    insert('circle-translate', circleTranslate);

    // Handle enums or lists for specific keys
    insert(
      'circle-pitch-scale',
      circlePitchScale is CirclePitchScale
          ? circlePitchScale.name
          : circlePitchScale,
    );

    insert(
      'circle-pitch-alignment',
      circlePitchAlignment is CirclePitchAlignment
          ? circlePitchAlignment.name
          : circlePitchAlignment,
    );

    insert(
      'circle-translate-anchor',
      circleTranslateAnchor is CircleTranslateAnchor
          ? circleTranslateAnchor.name
          : circleTranslateAnchor,
    );

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _circleTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('circle-color-transition', circleColorTransition);
    insert('circle-radius-transition', circleRadiusTransition);
    insert('circle-blur-transition', circleBlurTransition);
    insert('circle-opacity-transition', circleOpacityTransition);
    insert('circle-stroke-color-transition', circleStrokeColorTransition);
    insert('circle-stroke-width-transition', circleStrokeWidthTransition);
    insert('circle-stroke-opacity-transition', circleStrokeOpacityTransition);
    insert('circle-translate-transition', circleTranslateTransition);

    return transitionsArgs;
  }
}
