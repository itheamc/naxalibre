part of 'layer.dart';

/// LineLayer class
///
/// Represents a line layer in the map style, which is used to visualize line
/// geometries, such as routes, boundaries, or paths. This layer can be styled
/// with various properties like color, width, and dash patterns to enhance the
/// visualization of the lines on the map.
///
class LineLayer extends Layer<LineLayerProperties> {
  /// Constructor for LineLayer
  ///
  /// Initializes a new instance of the LineLayer with the specified
  /// [layerId], [sourceId], and optional [layerProperties].
  ///
  /// Parameters:
  /// - [layerId]: A unique identifier for this layer.
  /// - [sourceId]: The ID of the source from which the layer gets its data.
  /// - [layerProperties]: Optional properties specific to the LineLayer.
  ///   Defaults to [LineLayerProperties.defaultProperties] if not provided.
  LineLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "line-layer");

  /// Method to convert the LineLayer Object to the
  /// Map data to pass to the native platform through args
  ///
  /// Converts the LineLayer object and its properties into a map that can
  /// be passed to the native platform. It includes the `layerId`, `sourceId`,
  /// and the serialized `layerProperties`. If no custom properties are provided,
  /// default properties are used.
  ///
  /// Returns:
  /// A `Map[String, dynamic]` representing the serialized LineLayer.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? LineLayerProperties.defaultProperties).toArgs(),
    };
  }
}

/// LineLayerProperties class
/// It contains all the properties for the line layer
/// e.g.
/// final lineLayerProperties = LineLayerProperties(
///                             lineWidth: 2.0,
///                             lineColor: 'red',
///                         );
class LineLayerProperties extends LayerProperties {
  /// Stroke thickness.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 1.0
  final dynamic lineWidth;

  /// StyleTransition for line width
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineWidthTransition;

  /// The color with which the line will be drawn.
  /// Accepted data type:
  /// - String,
  /// - int and
  /// - Expression
  /// default value is '#000000'
  final dynamic lineColor;

  /// StyleTransition for line color
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineColorTransition;

  /// Blur applied to the line, in pixels.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic lineBlur;

  /// StyleTransition for line blur
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineBlurTransition;

  /// Specifies the lengths of the alternating dashes and gaps that form
  /// the dash pattern. The lengths are later scaled by the line width.
  /// To convert a dash length to pixels, multiply the length by the current
  /// line width. Note that GeoJSON sources with lineMetrics: true specified
  /// won't render dashed lines to the expected scale. Also note that
  /// zoom-dependent expressions will be evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - List<Double> and
  /// - Expression
  final dynamic lineDashArray;

  /// StyleTransition for dash array
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineDashArrayTransition;

  /// Draws a line casing outside of a line's actual path. Value indicates
  /// the width of the inner gap.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic lineGapWidth;

  /// StyleTransition for line gap width
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineGapWidthTransition;

  /// Expression
  /// e.g.
  ///   [
  ///    'interpolate',
  ///    ['linear'],
  ///    ['line-progress'],
  ///     0,
  ///    'blue',
  ///     0.1,
  ///    'green',
  ///     0.3,
  ///    'cyan',
  ///     0.5,
  ///    'lime',
  ///     0.7,
  ///    'yellow',
  ///     1,
  ///    'red'
  ///  ]
  ///
  final dynamic lineGradient;

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 2.0
  final dynamic lineMiterLimit;

  /// The line's offset. For linear features, a positive value offsets
  /// the line to the right, relative to the direction of the line, and
  /// a negative value to the left. For polygon features, a positive value
  /// results in an inset, and a negative value results in an outset.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 0.0
  final dynamic lineOffset;

  /// StyleTransition for line offset
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineOffsetTransition;

  /// The opacity at which the line will be drawn.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic lineOpacity;

  /// StyleTransition for line opacity
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineOpacityTransition;

  /// Name of image in sprite to use for drawing image lines.
  /// For seamless patterns, image width must be a factor of two
  /// (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be
  /// evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - String and
  /// - Expression
  final dynamic linePattern;

  /// StyleTransition for linePattern
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? linePatternTransition;

  /// Used to automatically convert round joins to miter joins
  /// for shallow angles.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  /// default value is 1.05
  final dynamic lineRoundLimit;

  /// Sorts features in ascending order based on this value. Features with
  /// a higher sort key will appear above features with a lower sort key.
  /// Accepted data type:
  /// - Double and
  /// - Expression
  final dynamic lineSortKey;

  /// The geometry's offset. Values are x, y where negatives indicate
  /// left and up, respectively
  /// Accepted data type:
  /// - List<Double> and
  /// - Expression
  /// default value is [0.0, 0.0]
  final dynamic lineTranslate;

  /// StyleTransition for lineTranslate
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? lineTranslateTransition;

  /// Controls the frame of reference for line-translate.
  /// Accepted data type:
  /// - LineTranslateAnchor
  /// - Expression
  /// default value is LineTranslateAnchor.map
  final dynamic lineTranslateAnchor;

  /// The line part between trim-start, trim-end will be marked as transparent
  /// to make a route vanishing effect. The line trim-off offset is based
  /// on the whole line range 0.0, 1.0.
  /// Accepted data type:
  /// - List<Double> and
  /// - Expression
  /// default value is [0.0, 0.0]
  final dynamic lineTrimOffset;

  /// The display of line endings.
  /// Accepted data type:
  /// - LineCap and
  /// - Expression
  /// default value is LineCap.butt
  final dynamic lineCap;

  /// The display of lines when joining.
  /// Accepted data type:
  /// - LineJoin and
  /// - Expression
  /// default value is LineJoin.miter
  final dynamic lineJoin;

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

  /// Constructor
  LineLayerProperties({
    this.lineWidth,
    this.lineWidthTransition,
    this.lineColor,
    this.lineColorTransition,
    this.lineBlur,
    this.lineBlurTransition,
    this.lineDashArray,
    this.lineDashArrayTransition,
    this.lineGapWidth,
    this.lineGapWidthTransition,
    this.lineGradient,
    this.lineMiterLimit,
    this.lineOffset,
    this.lineOffsetTransition,
    this.lineOpacity,
    this.lineOpacityTransition,
    this.linePattern,
    this.linePatternTransition,
    this.lineRoundLimit,
    this.lineSortKey,
    this.lineTranslate,
    this.lineTranslateTransition,
    this.lineTranslateAnchor,
    this.lineTrimOffset,
    this.lineCap,
    this.lineJoin,
    this.sourceLayer,
    this.filter,
    this.maxZoom,
    this.minZoom,
    this.visibility,
  });

  /// Default line layer properties
  static LineLayerProperties get defaultProperties {
    return LineLayerProperties(
      lineWidth: 2.0,
      lineColor: 'blue',
      lineCap: LineCap.round,
      lineJoin: LineJoin.round,
    );
  }

  /// Method to proceeds the line layer properties for native
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
    final layoutArgs = _lineLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _linePaintArgs();
    args['paint'] = paintArgs;

    // Transitions properties
    final transitionsArgs = _lineTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _lineLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('line-miter-limit', lineMiterLimit);
    insert('line-round-limit', lineRoundLimit);
    insert('line-sort-key', lineSortKey);
    insert('visibility', visibility);

    if (lineCap != null && (lineCap is LineCap || lineCap is List)) {
      layoutArgs['line-cap'] = lineCap is LineCap
          ? (lineCap as LineCap).name
          : lineCap is List
              ? jsonEncode(lineCap)
              : lineCap;
    }

    if (lineJoin != null && (lineJoin is LineJoin || lineJoin is List)) {
      layoutArgs['line-join'] = lineJoin is LineJoin
          ? (lineJoin as LineJoin).name
          : lineJoin is List
              ? jsonEncode(lineJoin)
              : lineJoin;
    }

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _linePaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('line-width', lineWidth);
    insert('line-color', lineColor);
    insert('line-blur', lineBlur);
    insert('line-gap-width', lineGapWidth);
    insert('line-offset', lineOffset);
    insert('line-opacity', lineOpacity);
    insert('line-pattern', linePattern);

    if (lineDashArray != null) {
      paintArgs['line-dasharray'] = lineDashArray is List<double> ||
              lineDashArray is List<int> ||
              lineDashArray is List<num>
          ? lineDashArray
          : jsonEncode(lineDashArray);
    }

    if (lineGradient != null && lineGradient is List) {
      paintArgs['line-gradient'] = jsonEncode(lineGradient);
    }

    if (lineTranslate != null) {
      paintArgs['line-translate'] = lineTranslate is List<double> ||
              lineTranslate is List<int> ||
              lineTranslate is List<num>
          ? lineTranslate
          : jsonEncode(lineTranslate);
    }

    if (lineTranslateAnchor != null &&
        (lineTranslateAnchor is LineTranslateAnchor ||
            lineTranslateAnchor is List)) {
      paintArgs['line-translate-anchor'] =
          lineTranslateAnchor is LineTranslateAnchor
              ? (lineTranslateAnchor as LineTranslateAnchor).name
              : lineTranslateAnchor is List
                  ? jsonEncode(lineTranslateAnchor)
                  : lineTranslateAnchor;
    }

    if (lineTrimOffset != null) {
      paintArgs['line-trim-offset'] = lineTrimOffset is List<double> ||
              lineTrimOffset is List<int> ||
              lineTrimOffset is List<num>
          ? lineTrimOffset
          : jsonEncode(lineTrimOffset);
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _lineTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('line-width-transition', lineWidthTransition);
    insert('line-color-transition', lineColorTransition);
    insert('line-blur-transition', lineBlurTransition);
    insert('line-dash-array-transition', lineDashArrayTransition);
    insert('line-gap-width-transition', lineGapWidthTransition);
    insert('line-offset-transition', lineOffsetTransition);
    insert('line-opacity-transition', lineOpacityTransition);
    insert('line-pattern-transition', linePatternTransition);
    insert('line-translate-transition', lineTranslateTransition);

    return transitionsArgs;
  }
}
