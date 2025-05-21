part of 'annotation.dart';

/// The `PointAnnotation` class represents a point annotation that can be added
/// to the map for visualization purposes. This annotation can display an icon
/// from a URL, asset path, or a style image already added to the map.
///
class PointAnnotation extends Annotation<PointAnnotationOptions> {
  /// Type of the annotation
  ///
  @override
  String get type => "Symbol";

  /// The `image` property is required to set the icon image to the
  /// `PointAnnotation`. It can be either a [NetworkStyleImage] or an
  /// [AssetStyleImage].
  final StyleImage? image;

  /// Constructs a `PointAnnotation` instance.
  ///
  /// [image] A style image to use as the icon for the annotation.
  /// It may me [NetworkStyleImage] or [AssetStyleImage]
  /// [options] The options for the annotation.
  ///
  PointAnnotation({this.image, required super.options});

  /// Converts the `PointAnnotation` object into a map representation.
  ///
  /// This method formats the annotation data into a structure suitable
  /// for passing to the native platform through the `args` parameter.
  ///
  /// Returns:
  /// - A json map containing the annotation options.
  @override
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "type": type,
      "options": {
        ...?options.toArgs(),
        if (image != null) 'icon-image': image?.imageId,
      },
    };
  }
}

/// PointAnnotationOptions class
/// It contains all the properties for the polygon annotation
/// e.g.
/// final pointAnnotationOptions = PointAnnotationOptions(
///                             point: LatLng(27.34, 85.43),
///                             fillColor: "#ef2d3f",
///                         );
class PointAnnotationOptions extends AnnotationOptions {
  /// Set the Point of the point annotation, which represents the location
  /// of the point annotation on the map
  /// Accepted data type:
  /// - LatLng
  final LatLng point;

  /// Set whether this circleAnnotation should be draggable, meaning it can be
  /// dragged across the screen when touched and moved.
  /// Accepted data type - bool
  /// default value is false
  final bool draggable;

  /// Set the arbitrary json data of the annotation.
  /// Accepted data type - map of string - dynamic
  /// default value is empty map
  final Map<String, dynamic>? data;

  /// Part of the icon placed closest to the anchor.
  /// IconAnchor or Expression
  /// Default is IconAnchor.center
  final dynamic iconAnchor;

  /// If true, the icon may be flipped to prevent it
  /// from being rendered upside-down.
  /// Boolean or Expression
  /// Default is false
  final dynamic iconKeepUpright;

  /// Offset distance of icon from its anchor.
  /// Positive values indicate right and down,
  /// while negative values indicate left and up.
  /// Each component is multiplied by the value of `icon-size` to obtain
  /// the final offset in pixels.
  /// When combined with `icon-rotate` the offset will be as if the
  /// rotated direction was up.
  /// List of double or Expression
  /// Default value is listOf(0.0, 0.0)
  final dynamic iconOffset;

  /// If true, text will display without their corresponding icons
  /// when the icon collides with other symbols and the text does not.
  /// Boolean or Expression
  /// Default is false
  final dynamic iconOptional;

  /// Size of the additional area around the icon bounding box used
  /// for detecting symbol collisions.
  /// Double or Expression
  /// Default value is 2.0
  final dynamic iconPadding;

  /// Rotates the icon clockwise.
  /// Double or Expression
  /// Default is 0.0
  final dynamic iconRotate;

  /// Scales the original size of the icon by the provided factor.
  /// The new pixel size of the image will be the original pixel
  /// size multiplied by `icon-size`. 1 is the original size;
  /// 3 triples the size of the image.
  /// Double or Expression
  /// Default is 1.0
  final dynamic iconSize;

  /// Scales the icon to fit around the associated text.
  /// IconTextFit or Expression
  /// Default is IconTextFit.none
  final dynamic iconTextFit;

  /// Size of the additional area added to dimensions determined by
  /// `icon-text-fit`, in clockwise order: top, right, bottom, left.
  /// Lost of double or Expression
  /// Default value is listOf(0.0, 0.0, 0.0, 0.0)
  final dynamic iconTextFitPadding;

  /// If true, the symbols will not cross tile edges to avoid
  /// mutual collisions. Recommended in layers that don't
  /// have enough padding in the vector tile to prevent collisions,
  /// or if it is a point symbol layer placed after a line symbol
  /// layer. When using a client that supports global collision
  /// detection, like Mapbox GL JS version 0.42.0 or greater,
  /// enabling this property is not needed to prevent clipped
  /// labels at tile boundaries.
  /// Boolean or Expression
  /// Default is false
  final dynamic symbolAvoidEdges;

  /// Sorts features in ascending order based on this value.
  /// Features with lower sort keys are drawn and placed first.
  /// When `icon-allow-overlap` or `text-allow-overlap` is `false`,
  /// features with a lower sort key will have priority during
  /// placement. When `icon-allow-overlap` or `text-allow-overlap`
  /// is set to `true`, features with a higher sort key will overlap
  /// over features with a lower sort key.
  /// Double or Expression
  final dynamic symbolSortKey;

  /// Part of the text placed closest to the anchor.
  /// TextAnchor and Expression
  /// Default value is TextAnchor.center
  final dynamic textAnchor;

  /// Value to use for a text label. If a plain `string` is provided,
  /// it will be treated as a `formatted` with default/inherited
  /// formatting options. SDF images are not supported in formatted text
  /// and will be ignored.
  /// String and Expression
  final dynamic textField;

  /// Font stack to use for displaying text.
  /// List of string or Expression
  /// Default value is listOf("Open Sans Regular", "Arial Unicode MS Regular")
  final dynamic textFont;

  /// If true, other symbols can be visible even if they collide with the text.
  /// Boolean and Expression
  /// Default is false
  final dynamic textIgnorePlacement;

  /// Text justification options.
  /// TextJustify and Expression
  /// Default is TextJustify.enter
  final dynamic textJustify;

  /// If true, the text may be flipped vertically to prevent it
  /// from being rendered upside-down.
  /// Boolean and Expression
  /// Default value is true
  final dynamic textKeepUpright;

  /// Text tracking amount.
  /// Double and Expression
  /// Default value is 0.0
  final dynamic textLetterSpacing;

  /// Text leading value for multi-line text.
  /// Double and Expression
  /// Default value is 1.2
  final dynamic textLineHeight;

  /// Maximum angle change between adjacent characters.
  /// double or Expression
  /// Default value is 45.0
  final dynamic textMaxAngle;

  /// The maximum line width for text wrapping.
  /// double or Expression
  /// Default value is 10.0
  final dynamic textMaxWidth;

  /// Offset distance of text from its anchor.
  ///
  /// Positive values indicate right and down, while negative values
  /// indicate left and up. If used with text-variable-anchor, input values
  /// will be taken as absolute values. Offsets along the x- and y-axis will
  /// be applied automatically based on the anchor position.
  /// List of double or Expression
  /// Default is listOf(0.0, 0.0)
  final dynamic textOffset;

  /// If true, icons will display without their corresponding text when
  /// the text collides with other symbols and the icon does not.
  /// Boolean or Expression
  /// default value is false
  final dynamic textOptional;

  /// Size of the additional area around the text bounding box used for
  /// detecting symbol collisions.
  /// double or Expression
  /// Default value is 2.0
  final dynamic textPadding;

  /// Radial offset of text, in the direction of the symbol's anchor.
  /// Useful in combination with `text-variable-anchor`, which defaults to
  /// using the two-dimensional `text-offset` if present.
  /// double or Expression
  /// Default is 0.0
  final dynamic textRadialOffset;

  /// Rotates the text clockwise.
  /// double or Expression
  /// Default value is 0.0
  final dynamic textRotate;

  /// Font size.
  /// double or Expression
  /// Default value is 16.0
  final dynamic textSize;

  /// Specifies how to capitalize text, similar to the CSS
  /// `text-transform` property.
  /// TextTransform
  /// Default is TextTransform.NONE
  final dynamic textTransform;

  /// The property allows control over a symbol's orientation.
  /// Note that the property values act as a hint, so that a symbol whose
  /// language doesn’t support the provided orientation will be laid out in
  /// its natural orientation. Example: English point symbol will be rendered
  /// horizontally even if array value contains single 'vertical' enum value.
  /// For symbol with point placement, the order of elements in an array define
  /// priority order for the placement of an orientation variant. For symbol
  /// with line placement, the default text writing mode is either
  /// ['horizontal', 'vertical'] or ['vertical', 'horizontal'], the order
  /// doesn't affect the placement.
  /// List of String or Expression
  final dynamic textWritingMode;

  /// The color of the icon. This can only be used with [SDF icons]
  /// String, int or Expression
  ///
  /// Default value is '#000
  final dynamic iconColor;

  /// The color of the icon. This can only be used with [SDF icons]
  /// StyleTransition
  final StyleTransition? iconColorTransition;

  /// Fade out the halo towards the outside.
  /// double or Expression
  /// Default value is 0.0
  final dynamic iconHaloBlur;

  /// Fade out the halo towards the outside.
  /// StyleTransition
  final StyleTransition? iconHaloBlurTransition;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons]
  /// String, int or Expression
  final dynamic iconHaloColor;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons]
  /// StyleTransition
  final StyleTransition? iconHaloColorTransition;

  /// Distance of halo to the icon outline.
  /// double and Expression
  /// Default value is 0.0
  final dynamic iconHaloWidth;

  /// Distance of halo to the icon outline.
  /// StyleTransition
  final StyleTransition? iconHaloWidthTransition;

  /// The opacity at which the icon will be drawn.
  /// double and Expression
  /// Default value is 1.0
  final dynamic iconOpacity;

  /// The opacity at which the icon will be drawn.
  /// StyleTransition
  final StyleTransition? iconOpacityTransition;

  /// Distance that the icon's anchor is moved from its original placement.
  /// Positive values indicate right and down, while negative values indicate
  /// left and up.
  /// List of double or Expression
  /// Default value is listOf(0.0, 0.0)
  final dynamic iconTranslate;

  /// The color with which the text will be drawn.
  /// String, int or Expression
  /// Default is '#000'
  final dynamic textColor;

  /// The color with which the text will be drawn.
  /// StyleTransition
  final StyleTransition? textColorTransition;

  /// The halo's fadeout distance towards the outside.
  /// double or Expression
  /// Default value is  0.0
  final dynamic textHaloBlur;

  /// The halo's fadeout distance towards the outside.
  /// StyleTransition
  final StyleTransition? textHaloBlurTransition;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  /// String, int or Expression
  /// Default is '#000'
  final dynamic textHaloColor;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  /// StyleTransition
  final StyleTransition? textHaloColorTransition;

  /// Distance of halo to the font outline. Max text halo width is 1/4
  /// of the font-size.
  /// double or Expression
  /// Default value is 0.0
  final dynamic textHaloWidth;

  /// Distance of halo to the font outline. Max text halo width is 1/4
  /// of the font-size.
  /// StyleTransition
  final StyleTransition? textHaloWidthTransition;

  /// The opacity at which the text will be drawn.
  /// double or Expression
  /// Default value is 1.0
  final dynamic textOpacity;

  /// The opacity at which the text will be drawn.
  /// StyleTransition
  final StyleTransition? textOpacityTransition;

  /// Distance that the text's anchor is moved from its original placement.
  /// Positive values indicate right and down, while negative values indicate
  /// left and up.
  /// List of double or Expression
  /// Default value is listOf(0.0, 0.0)
  final dynamic textTranslate;

  /// Distance that the text's anchor is moved from its original placement.
  /// Positive values indicate right and down, while negative values indicate
  /// left and up.
  /// StyleTransition
  final StyleTransition? textTranslateTransition;

  /// Constructor
  PointAnnotationOptions({
    required this.point,
    this.iconAnchor,
    this.iconKeepUpright,
    this.iconOffset,
    this.iconOptional,
    this.iconPadding,
    this.iconRotate,
    this.iconSize,
    this.iconTextFit,
    this.iconTextFitPadding,
    this.symbolAvoidEdges,
    this.symbolSortKey,
    this.textAnchor,
    this.textField,
    this.textFont,
    this.textIgnorePlacement,
    this.textJustify,
    this.textKeepUpright,
    this.textLetterSpacing,
    this.textLineHeight,
    this.textMaxAngle,
    this.textMaxWidth,
    this.textOffset,
    this.textOptional,
    this.textPadding,
    this.textRadialOffset,
    this.textRotate,
    this.textSize,
    this.textTransform,
    this.textWritingMode,
    this.iconColor,
    this.iconColorTransition,
    this.iconHaloBlur,
    this.iconHaloBlurTransition,
    this.iconHaloColor,
    this.iconHaloColorTransition,
    this.iconHaloWidth,
    this.iconHaloWidthTransition,
    this.iconOpacity,
    this.iconOpacityTransition,
    this.iconTranslate,
    this.textColor,
    this.textColorTransition,
    this.textHaloBlur,
    this.textHaloBlurTransition,
    this.textHaloColor,
    this.textHaloColorTransition,
    this.textHaloWidth,
    this.textHaloWidthTransition,
    this.textOpacity,
    this.textOpacityTransition,
    this.textTranslate,
    this.textTranslateTransition,
    this.draggable = false,
    this.data,
  });

  /// Method to proceeds the symbol layer properties for native
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    // Adding point
    args['point'] = point.toArgs();

    // Adding draggable
    args['draggable'] = draggable;

    // Adding data
    if (data != null) {
      args['data'] = data;
    }

    // Layout properties
    final layoutArgs = _symbolLayoutArgs();
    args['layout'] = layoutArgs;

    // Paint properties
    final paintArgs = _symbolPaintArgs();
    args['paint'] = paintArgs;

    // Transition properties
    final transitionsArgs = _symbolTransitionsArgs();
    args['transition'] = transitionsArgs;

    return args.isNotEmpty ? args : null;
  }

  /// Method to create layout properties
  ///
  Map<String, dynamic> _symbolLayoutArgs() {
    final layoutArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        layoutArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('icon-keep-upright', iconKeepUpright);
    insert('icon-optional', iconOptional);
    insert('icon-padding', iconPadding);
    insert('icon-rotate', iconRotate);
    insert('icon-size', iconSize);
    insert('symbol-avoid-edges', symbolAvoidEdges);
    insert('symbol-sort-key', symbolSortKey);
    insert('text-field', textField);
    insert('text-font', textFont);
    insert('text-ignore-placement', textIgnorePlacement);
    insert('text-keep-upright', textKeepUpright);
    insert('text-letter-spacing', textLetterSpacing);
    insert('text-line-height', textLineHeight);
    insert('text-max-angle', textMaxAngle);
    insert('text-max-width', textMaxWidth);
    insert('text-optional', textOptional);
    insert('text-padding', textPadding);
    insert('text-radial-offset', textRadialOffset);
    insert('text-rotate', textRotate);
    insert('text-size', textSize);

    if (iconAnchor != null &&
        (iconAnchor is IconAnchor || iconAnchor is List)) {
      layoutArgs['icon-anchor'] =
          iconAnchor is IconAnchor
              ? (iconAnchor as IconAnchor).key
              : iconAnchor is List
              ? jsonEncode(iconAnchor)
              : iconAnchor;
    }

    if (iconOffset != null && iconOffset is List) {
      layoutArgs['icon-offset'] =
          iconOffset is List<double> ||
                  iconOffset is List<int> ||
                  iconOffset is List<num>
              ? iconOffset
              : jsonEncode(iconOffset);
    }

    if (iconTextFit != null &&
        (iconTextFit is IconTextFit || iconTextFit is List)) {
      layoutArgs['icon-text-fit'] =
          iconTextFit is IconTextFit
              ? (iconTextFit as IconTextFit).name
              : iconTextFit is List
              ? jsonEncode(iconTextFit)
              : iconTextFit;
    }

    if (iconTextFitPadding != null && iconTextFitPadding is List) {
      layoutArgs['icon-text-fit-padding'] =
          iconTextFitPadding is List<double> ||
                  iconTextFitPadding is List<int> ||
                  iconTextFitPadding is List<num>
              ? iconTextFitPadding
              : jsonEncode(iconTextFitPadding);
    }

    if (textAnchor != null &&
        (textAnchor is TextAnchor || textAnchor is List)) {
      layoutArgs['text-anchor'] =
          textAnchor is TextAnchor
              ? (textAnchor as TextAnchor).key
              : textAnchor is List
              ? jsonEncode(textAnchor)
              : textAnchor;
    }

    if (textJustify != null &&
        (textJustify is TextJustify || textJustify is List)) {
      layoutArgs['text-justify'] =
          textJustify is TextJustify
              ? (textJustify as TextJustify).name
              : textJustify is List
              ? jsonEncode(textJustify)
              : textJustify;
    }

    if (textOffset != null && textOffset is List) {
      layoutArgs['text-offset'] =
          textOffset is List<double> ||
                  textOffset is List<int> ||
                  textOffset is List<num>
              ? textOffset
              : jsonEncode(textOffset);
    }

    if (textTransform != null &&
        (textTransform is TextTransform || textTransform is List)) {
      layoutArgs['text-transform'] =
          textTransform is TextTransform
              ? (textTransform as TextTransform).name
              : textTransform is List
              ? jsonEncode(textTransform)
              : textTransform;
    }

    if (textWritingMode != null && textWritingMode is List) {
      layoutArgs['text-writing-mode'] =
          textWritingMode is List<String>
              ? textWritingMode
              : jsonEncode(textWritingMode);
    }

    return layoutArgs;
  }

  /// Method to create paint properties
  ///
  Map<String, dynamic> _symbolPaintArgs() {
    final paintArgs = <String, dynamic>{};

    void insert(String key, dynamic value) {
      if (value != null) {
        paintArgs[key] = value is List ? jsonEncode(value) : value;
      }
    }

    insert('icon-color', iconColor);
    insert('icon-halo-blur', iconHaloBlur);
    insert('icon-halo-color', iconHaloColor);
    insert('icon-halo-width', iconHaloWidth);
    insert('icon-opacity', iconOpacity);
    insert('text-color', textColor);
    insert('text-halo-blur', textHaloBlur);
    insert('text-halo-color', textHaloColor);
    insert('text-halo-width', textHaloWidth);
    insert('text-opacity', textOpacity);

    if (iconTranslate != null && iconTranslate is List) {
      paintArgs['icon-translate'] =
          iconTranslate is List<double> ||
                  iconTranslate is List<int> ||
                  iconTranslate is List<num>
              ? iconTranslate
              : jsonEncode(iconTranslate);
    }

    if (textTranslate != null && textTranslate is List) {
      paintArgs['text-translate'] =
          textTranslate is List<double> ||
                  textTranslate is List<int> ||
                  textTranslate is List<num>
              ? textTranslate
              : jsonEncode(textTranslate);
    }

    return paintArgs;
  }

  /// Method to create transitions properties
  ///
  Map<String, dynamic> _symbolTransitionsArgs() {
    final transitionsArgs = <String, dynamic>{};

    void insert(String key, dynamic transition) {
      if (transition != null) {
        transitionsArgs[key] = transition.toArgs();
      }
    }

    insert('icon-color-transition', iconColorTransition);
    insert('icon-halo-blur-transition', iconHaloBlurTransition);
    insert('icon-halo-color-transition', iconHaloColorTransition);
    insert('icon-halo-width-transition', iconHaloWidthTransition);
    insert('icon-opacity-transition', iconOpacityTransition);
    insert('text-color-transition', textColorTransition);
    insert('text-halo-blur-transition', textHaloBlurTransition);
    insert('text-halo-color-transition', textHaloColorTransition);
    insert('text-halo-width-transition', textHaloWidthTransition);
    insert('text-opacity-transition', textOpacityTransition);
    insert('text-translate-transition', textTranslateTransition);

    return transitionsArgs;
  }
}
