part of 'annotation.dart';

/// The `PolygonAnnotation` class represents a polygon annotation,
/// which is a filled geometric shape that can be rendered on the map.
///
/// This class extends the `Annotation` class and uses
/// `PolygonAnnotationOptions` to define the properties of the polygon annotation.
///
class PolygonAnnotation extends Annotation<PolygonAnnotationOptions> {
  /// Constructs a `PolygonAnnotation` instance.
  ///
  /// [annotationOptions] is required and defines the properties of the polygon annotation,
  /// such as the points that form the polygon, its fill color, stroke color, and other style properties.
  PolygonAnnotation({
    required super.annotationOptions,
  });

  /// Converts the `PolygonAnnotation` object to a map representation.
  ///
  /// This method prepares the annotation data in a format suitable
  /// for passing to the native platform through the `args` parameter.
  ///
  /// Returns:
  /// - A json map containing the annotation options.
  @override
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "annotationOptions": annotationOptions.toArgs(),
    };
  }
}

/// PolygonAnnotationOptions class
/// It contains all the properties for the polygon annotation
/// e.g.
/// final polygonAnnotationOptions = PolygonAnnotationOptions(
///                             points: [
///                                [
///                                Point.fromLatLng(27.34, 85.43),
///                                Point.fromLatLng(27.4, 85.5)
///                                ]
///                             ],
///                             fillColor: "#ef2d3f",
///                         );
class PolygonAnnotationOptions extends AnnotationOptions {
  /// Set a list of lists of Point for the fill, which represents
  /// the locations of the fill on the map
  /// Accepted data type:
  /// - List of List of LatLng
  final List<List<LatLng>> points;

  /// Set fill-color to initialise the polygonAnnotation with.
  /// The color of the filled part of this layer.
  /// This color can be specified as rgba with an alpha component
  /// and the color's opacity will not affect the opacity of the 1px stroke,
  /// if it is used.
  /// Accepted data type:
  /// - String and
  /// - Int
  final dynamic fillColor;

  /// The opacity of the entire fill layer.
  /// Accepted data type:
  /// - Double
  /// default value is 1.0
  final double? fillOpacity;

  /// The outline color of the fill.
  /// Accepted data type:
  /// - String and
  /// - Int
  final dynamic fillOutlineColor;

  /// Set fill-pattern to initialise the polygonAnnotation with.
  /// Name of image in sprite to use for drawing image fills.
  /// For seamless patterns, image width and height must be a
  /// factor of two (2, 4, 8, ..., 512). Note that zoom-dependent
  /// expressions will be evaluated only at integer zoom levels.
  /// Accepted data type:
  /// - String
  final String? fillPattern;

  /// Set fill-sort-key to initialise the polygonAnnotation with.
  /// Sorts features in ascending order based on this value.
  /// Features with a higher sort key will appear above features with
  /// a lower sort key.
  /// Accepted data type:
  /// - Double
  final double? fillSortKey;

  /// Set whether this circleAnnotation should be draggable, meaning it can be
  /// dragged across the screen when touched and moved.
  /// Accepted data type - bool
  /// default value is false
  final bool draggable;

  /// Set the arbitrary json data of the annotation.
  /// Accepted data type - json map {}
  /// default value is map json {}
  final Map<String, dynamic>? data;

  /// Constructor
  PolygonAnnotationOptions({
    required this.points,
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
    this.fillSortKey,
    this.draggable = false,
    this.data,
  });

  /// Method to proceeds the polygon annotation option for native
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    args['points'] =
        points.map((e) => e.map((e1) => e1.toArgs()).toList()).toList();

    if (fillColor != null) args['fillColor'] = fillColor;
    if (fillOpacity != null) args['fillOpacity'] = fillOpacity;
    if (fillOutlineColor != null) args['fillOutlineColor'] = fillOutlineColor;
    if (fillSortKey != null) args['fillSortKey'] = fillSortKey;
    if (fillPattern != null) args['fillPattern'] = fillPattern;
    if (data != null) args['data'] = jsonEncode(data);
    args['draggable'] = draggable;

    return args.isNotEmpty ? args : null;
  }
}
