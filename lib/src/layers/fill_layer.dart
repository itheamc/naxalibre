part of 'layer.dart';

/// FillLayer class
///
/// Represents a layer used to render filled areas on the map. This is typically
/// used to represent polygons, such as land areas, building footprints, or
/// other filled shapes. The `FillLayer` class provides options for configuring
/// the appearance and behavior of the fill, such as colors, patterns, and
/// opacity.
///
class FillLayer extends Layer<FillLayerProperties> {
  /// Constructor for FillLayer
  ///
  /// Initializes a new instance of the FillLayer with the specified [layerId],
  /// [sourceId], and optional [layerProperties].
  ///
  /// Parameters:
  /// - [layerId]: The unique identifier for this layer.
  /// - [sourceId]: The identifier of the source to which this layer is applied.
  /// - [layerProperties]: Optional properties specific to the FillLayer.
  ///   Defaults to [FillLayerProperties.defaultProperties] if not provided.
  FillLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "fill-layer");

  /// Method to convert the FillLayer Object to the
  /// Map data to pass to the native platform through args
  ///
  /// Converts the FillLayer object and its properties into a map that can
  /// be passed to the native platform. It includes the `layerId`, `sourceId`,
  /// and the serialized `layerProperties`. If no custom properties are provided,
  /// default properties are used.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the serialized FillLayer.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? FillLayerProperties.defaultProperties).toArgs(),
    };
  }
}

/// FillLayerProperties class
/// It contains all the properties for the fill layer
/// e.g.
/// final fillLayerProperties = FillLayerProperties(
///                             fillColor: 'red',
///                         );
class FillLayerProperties extends LayerProperties {
  /// The color of the filled part of this layer. This color can be specified
  /// as rgba with an alpha component and the color's opacity will not affect
  /// the opacity of the 1px stroke, if it is used.
  /// Accepted data type:
  /// - String,
  /// - Int and
  /// - Expression
  /// default value is '#000000'
  final dynamic fillColor;

  /// StyleTransition for fill color
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillColorTransition;

  /// Whether or not the fill should be antialiasing.
  /// Accepted data type:
  /// - Boolean and
  /// - Expression
  /// default value is true
  final dynamic fillAntialias;

  /// The opacity of the entire fill layer.
  /// In contrast to the fill-color, this value will also affect the
  /// 1px stroke around the fill, if the stroke is used.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 1.0
  final dynamic fillOpacity;

  /// StyleTransition for fill opacity
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillOpacityTransition;

  /// The outline color of the fill. Matches the value of fill-color if unspecified.
  /// Accepted data type:
  /// - String,
  /// - Int and
  /// - Expression
  final dynamic fillOutlineColor;

  /// StyleTransition for fillOutlineColor
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillOutlineColorTransition;

  /// Name of image in sprite to use for drawing image fills.
  /// For seamless patterns, image width and height must be a factor of
  /// two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will
  /// be evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - String and
  /// - Expression
  final dynamic fillPattern;

  /// StyleTransition for fill pattern
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillPatternTransition;

  /// Sorts features in ascending order based on this value. Features with
  /// a higher sort key will appear above features with a lower sort key.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  final dynamic fillSortKey;

  /// The geometry's offset. Values are x, y where negatives indicate
  /// left and up, respectively.
  /// Accepted data type:
  /// - List<Double> and
  /// - Expression
  final dynamic fillTranslate;

  /// StyleTransition for fill translate
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? fillTranslateTransition;

  /// Controls the frame of reference for fill-translate.
  /// Accepted data type:
  /// - FillTranslateAnchor
  /// - Expression
  /// default value is FillTranslateAnchor.map
  final dynamic fillTranslateAnchor;

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

  FillLayerProperties({
    this.fillColor,
    this.fillColorTransition,
    this.fillAntialias,
    this.fillOpacity,
    this.fillOpacityTransition,
    this.fillOutlineColor,
    this.fillOutlineColorTransition,
    this.fillPattern,
    this.fillPatternTransition,
    this.fillSortKey,
    this.fillTranslate,
    this.fillTranslateTransition,
    this.fillTranslateAnchor,
    this.sourceLayer,
    this.filter,
    this.maxZoom,
    this.minZoom,
    this.visibility,
  });

  /// Default fill layer properties
  static FillLayerProperties get defaultProperties {
    return FillLayerProperties(
      fillColor: 'blue',
      fillColorTransition: StyleTransition.build(
        delay: 300,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Converts the properties of the FillLayer into a map format.
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
    insert('filter', filter);
    insert('maxzoom', maxZoom);
    insert('minzoom', minZoom);

    // Layout properties
    final layoutArgs = _fillLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _fillPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _fillTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _fillLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('fill-sort-key', fillSortKey);
    insert('visibility', visibility);

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _fillPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('fill-color', fillColor);
    insert('fill-antialias', fillAntialias);
    insert('fill-opacity', fillOpacity);
    insert('fill-outline-color', fillOutlineColor);
    insert('fill-pattern', fillPattern);

    // Handle enums or lists for specific keys
    if (fillTranslate != null) {
      paintArgs['fill-translate'] = fillTranslate is List<double> ||
              fillTranslate is List<int> ||
              fillTranslate is List<num>
          ? fillTranslate
          : jsonEncode(fillTranslate);
    }

    if (fillTranslateAnchor != null) {
      paintArgs['fill-translate-anchor'] =
          fillTranslateAnchor is FillTranslateAnchor
              ? fillTranslateAnchor.name
              : fillTranslateAnchor is List
                  ? jsonEncode(fillTranslateAnchor)
                  : fillTranslateAnchor;
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _fillTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('fill-translate-transition', fillTranslateTransition);
    insert('fill-pattern-transition', fillPatternTransition);
    insert('fill-outline-color-transition', fillOutlineColorTransition);
    insert('fill-opacity-transition', fillOpacityTransition);
    insert('fill-color-transition', fillColorTransition);

    return transitionsArgs;
  }
}
