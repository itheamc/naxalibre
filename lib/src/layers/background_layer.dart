part of 'layer.dart';

/// BackgroundLayer class
///
/// Represents a background layer in the map style, which is used to define the
/// visual appearance of the map's background. This layer typically covers the
/// entire map area behind other layers and is used to specify solid colors,
/// patterns, or gradients as the background.
///
class BackgroundLayer extends Layer<BackgroundLayerProperties> {
  /// Constructor for BackgroundLayer
  ///
  /// Initializes a new instance of the BackgroundLayer with the specified
  /// [layerId] and optional [layerProperties].
  ///
  /// Parameters:
  /// - [layerId]: A unique identifier for this layer.
  /// - [layerProperties]: Optional properties specific to the BackgroundLayer.
  ///   Defaults to [BackgroundLayerProperties.defaultProperties] if not provided.
  ///
  /// Note: The `sourceId` is set to an empty string since a BackgroundLayer does
  /// not rely on any data source.
  BackgroundLayer({
    required super.layerId,
    super.layerProperties,
  }) : super(sourceId: "", type: "background-layer");

  /// Method to convert the BackgroundLayer Object to the
  /// Map data to pass to the native platform through args
  ///
  /// Converts the BackgroundLayer object and its properties into a map that can
  /// be passed to the native platform. It includes the `layerId` and the
  /// serialized `layerProperties`. If no custom properties are provided, default
  /// properties are used.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the serialized BackgroundLayer.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "properties":
          (layerProperties ?? BackgroundLayerProperties.defaultProperties)
              .toArgs(),
    };
  }
}

/// BackgroundLayerProperties class
/// It contains all the properties for the background layer
/// e.g.
/// final backgroundLayerProperties = BackgroundLayerProperties(
///                             backgroundColor: '#000',
///                         );
class BackgroundLayerProperties extends LayerProperties {
  /// The color with which the background will be drawn.
  /// Accepted data type:
  /// - String,
  /// - int and
  /// - Expression
  /// default value is '#000000'
  final dynamic backgroundColor;

  /// Transition for the color with which the background will be drawn.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? backgroundColorTransition;

  /// The opacity at which the background will be drawn.
  /// Accepted data type:
  /// - double and
  /// - Expression
  /// default value is 1.0
  final dynamic backgroundOpacity;

  /// Transition for the opacity at which the background will be drawn.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? backgroundOpacityTransition;

  /// Name of image in sprite to use for drawing an image background.
  /// For seamless patterns, image width and height must be a factor
  /// of two (2, 4, 8, ..., 512).
  /// Note that zoom-dependent expressions will be evaluated only at integer
  /// zoom levels.
  /// Accepted data type:
  /// - String and
  /// - Expression
  final dynamic backgroundPattern;

  /// Name of image in sprite to use for drawing an image background.
  /// For seamless patterns, image width and height must be a factor of
  /// two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be
  /// evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - StyleTransition
  final StyleTransition? backgroundPatternTransition;

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
  BackgroundLayerProperties({
    this.backgroundColor,
    this.backgroundColorTransition,
    this.backgroundOpacity,
    this.backgroundOpacityTransition,
    this.backgroundPattern,
    this.backgroundPatternTransition,
    this.visibility,
    this.minZoom,
    this.maxZoom,
  });

  /// Default BackgroundLayerProperties
  static BackgroundLayerProperties get defaultProperties {
    return BackgroundLayerProperties(
      backgroundColor: "#000000",
      backgroundColorTransition: StyleTransition.build(
        delay: 275,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Method to proceeds the background layer properties for native
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        args[key] = value is List ? jsonEncode(value) : value;
      }
    }

    // Add layer-specific properties
    insert('maxzoom', maxZoom);
    insert('minzoom', minZoom);

    // Layout properties
    final layoutArgs = _backgroundLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _backgroundPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _backgroundTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _backgroundLayoutArgs() {
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
  Map<String, dynamic> _backgroundPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('background-color', backgroundColor);
    insert('background-opacity', backgroundOpacity);
    insert('background-pattern', backgroundPattern);

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _backgroundTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('background-color-transition', backgroundColorTransition);
    insert('background-opacity-transition', backgroundOpacityTransition);
    insert('background-pattern-transition', backgroundPatternTransition);

    return transitionsArgs;
  }
}
