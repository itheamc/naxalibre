part of 'layer.dart';

/// HillShadeLayer class
///
/// Represents a layer that applies hillshade styling to a map. Hillshade is a
/// technique used to simulate the lighting of terrain in a way that highlights
/// elevation and slope features. This class inherits from the [Layer] class and
/// provides specific properties for hillshade styling.
///
class HillShadeLayer extends Layer<HillShadeLayerProperties> {
  /// Constructor for HillShadeLayer
  ///
  /// Initializes a new instance of the HillShadeLayer with the specified
  /// [layerId], [sourceId], and optional [layerProperties].
  ///
  /// Parameters:
  /// - [layerId]: The unique identifier for this layer.
  /// - [sourceId]: The identifier of the source to which this layer is applied.
  /// - [layerProperties]: Optional properties specific to the HillShadeLayer.
  ///   Defaults to [HillShadeLayerProperties.defaultProperties] if not provided.
  HillShadeLayer({
    required super.layerId,
    required super.sourceId,
    super.layerProperties,
  }) : super(type: "hill-shade-layer");

  /// Method to convert the HillShadeLayer Object to the
  /// Map data to pass to the native platform through args
  ///
  /// Converts the HillShadeLayer object and its properties into a map that can
  /// be passed to the native platform. It includes the `layerId`, `sourceId`,
  /// and the serialized `layerProperties`. If no custom properties are provided,
  /// default properties are used.
  ///
  /// Returns:
  /// A `Map` representing the serialized HillShadeLayer.
  @override
  Map<String, Object?> toArgs() {
    return <String, Object?>{
      "type": type,
      "layerId": layerId,
      "sourceId": sourceId,
      "properties":
          (layerProperties ?? HillShadeLayerProperties.defaultProperties)
              .toArgs(),
    };
  }
}

/// HillShadeLayerProperties class
/// It contains all the properties for the hill shade layer
/// e.g.
/// final hillShadeLayerProperties = HillShadeLayerProperties(
///                             hillShadeAccentColor: '#2de12',
///                         );
class HillShadeLayerProperties extends LayerProperties {
  /// The shading color used to accentuate rugged terrain like sharp cliffs
  /// and gorges.
  /// Accepted data type -  String, int and Expression
  /// Default value is '#00000'
  final dynamic hillShadeAccentColor;

  /// The shading color used to accentuate rugged terrain like sharp
  /// cliffs and gorges.
  /// Accepted data type -  StyleTransition
  final StyleTransition? hillShadeAccentColorTransition;

  /// Intensity of the hill shade
  /// Accepted value double and Expression
  /// default value is 0.5
  final dynamic hillShadeExaggeration;

  /// Transition for intensity of the hill shade
  /// Accepted data type -  StyleTransition
  final StyleTransition? hillShadeExaggerationTransition;

  /// The shading color of areas that faces towards the light source.
  /// Accepted data type -  String, int and Expression
  /// default value is "#fff"
  final dynamic hillShadeHighlightColor;

  /// The shading color of areas that faces towards the light source.
  /// Accepted data type -  StyleTransition
  final StyleTransition? hillShadeHighlightColorTransition;

  /// Direction of light source when map is rotated.
  /// Accepted data type -  HillShadeIlluminationAnchor and Expression
  /// default value is HillShadeIlluminationAnchor.viewport
  final dynamic hillShadeIlluminationAnchor;

  /// The direction of the light source used to generate the hill shading
  /// with 0 as the top of the viewport if `hill shade-illumination-anchor`
  /// is set to `viewport` and due north if `hill shade-illumination-anchor`
  /// is set to `map`.
  /// Accepted value double and Expression
  /// default value is 335.0
  final dynamic hillShadeIlluminationDirection;

  /// The shading color of areas that face away from the light source.
  /// Accepted data type -  String, int and Expression
  final dynamic hillShadeShadowColor;

  /// The shading color of areas that face away from the light source.
  /// StyleTransition
  final StyleTransition? hillShadeShadowColorTransition;

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
  HillShadeLayerProperties({
    this.hillShadeAccentColor,
    this.hillShadeAccentColorTransition,
    this.hillShadeExaggeration,
    this.hillShadeExaggerationTransition,
    this.hillShadeHighlightColor,
    this.hillShadeHighlightColorTransition,
    this.hillShadeIlluminationAnchor,
    this.hillShadeIlluminationDirection,
    this.hillShadeShadowColor,
    this.hillShadeShadowColorTransition,
    this.sourceLayer,
    this.visibility,
    this.minZoom,
    this.maxZoom,
  });

  /// Default HillShadeLayerProperties
  static HillShadeLayerProperties get defaultProperties {
    return HillShadeLayerProperties(
      hillShadeAccentColor: '#00000',
      hillShadeAccentColorTransition: StyleTransition.build(
        delay: 275,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Converts the properties of the hill shade Layer into a map format.
  ///
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
    final layoutArgs = _hillShadeLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _hillShadePaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _hillShadeTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _hillShadeLayoutArgs() {
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
  Map<String, dynamic> _hillShadePaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('hill-shade-accent-color', hillShadeAccentColor);
    insert('hill-shade-illumination-direction', hillShadeIlluminationDirection);
    insert('hill-shade-shadow-color', hillShadeShadowColor);
    insert('hill-shade-exaggeration', hillShadeExaggeration);
    insert('hill-shade-highlight-color', hillShadeHighlightColor);

    if (hillShadeIlluminationAnchor != null) {
      paintArgs['hill-shade-illumination-anchor'] =
          hillShadeIlluminationAnchor is HillShadeIlluminationAnchor
              ? hillShadeIlluminationAnchor.name
              : jsonEncode(hillShadeIlluminationAnchor);
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _hillShadeTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert(
      'hill-shade-accent-color-transition',
      hillShadeAccentColorTransition,
    );
    insert(
      'hill-shade-exaggeration-transition',
      hillShadeExaggerationTransition,
    );
    insert(
      'hill-shade-highlight-color-transition',
      hillShadeHighlightColorTransition,
    );
    insert(
      'hill-shade-shadow-color-transition',
      hillShadeShadowColorTransition,
    );

    return transitionsArgs;
  }
}
