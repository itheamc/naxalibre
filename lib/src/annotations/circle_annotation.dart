part of 'annotation.dart';

/// The `CircleAnnotation` class represents a circular annotation
/// that can be added to the map for visualization purposes.
///
/// This class extends the `Annotation` class and uses
/// `CircleAnnotationOptions` to define the properties of the circular annotation,
/// such as its position, color, radius, and other customizable features.
///
class CircleAnnotation extends Annotation<CircleAnnotationOptions> {
  /// Constructs a `CircleAnnotation` instance.
  ///
  /// [annotationOptions] is required and contains the properties that define
  /// the circle's visual appearance and behavior, such as its center point and style options.
  CircleAnnotation({
    required super.annotationOptions,
  });

  /// Converts the `CircleAnnotation` object into a map representation.
  ///
  /// This method formats the annotation data into a structure suitable
  /// for passing to the native platform through the `args` parameter.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` containing the annotation options.
  @override
  Map<String, dynamic> toArgs() {
    return <String, dynamic>{
      "annotationOptions": annotationOptions.toArgs(),
    };
  }
}

/// CircleAnnotationOptions class
/// It contains all the properties for the circle annotation
/// e.g.
/// final circleAnnotationOptions = CircleAnnotationOptions(
///                             circleColor: 'green',
///                             circleRadius: 10.0,
///                             circleStrokeWidth: 2.0,
///                             circleStrokeColor: "#fff",
///                         );
class CircleAnnotationOptions extends AnnotationOptions {
  /// Set the Point of the circleAnnotation, which represents the location
  /// of the circleAnnotation on the map
  /// Accepted data type:
  /// - LatLng
  final LatLng point;

  /// The fill color of the circle.
  /// Accepted data type:
  /// - String and
  /// - Int
  /// default value is '#0000'
  final dynamic circleColor;

  /// Circle radius.
  /// Accepted data type:
  /// - Double
  final double? circleRadius;

  /// Amount to blur the circle. 1 blurs the circle such that only the
  /// center point is full opacity.
  /// Accepted data type:
  /// - Double
  /// default value is 0.0
  final double? circleBlur;

  /// The opacity at which the circle will be drawn.
  /// Accepted data type:
  /// - Double
  /// default value is 1.0
  final double? circleOpacity;

  /// The stroke color of the circle.
  /// Accepted data type:
  /// - String and
  /// - Int
  final dynamic circleStrokeColor;

  /// The opacity of the circle's stroke
  /// Accepted data type:
  /// - Double
  /// default value is 1.0
  final double? circleStrokeOpacity;

  /// The width of the circle's stroke. Strokes are placed outside
  /// of the circle-radius.
  /// Accepted data type:
  /// - Double
  /// default value is 0.0
  final double? circleStrokeWidth;

  /// Sorts features in ascending order based on this value.
  /// Features with a higher sort key will appear above features
  /// with a lower sort key.
  /// Accepted data type:
  /// - Double
  final double? circleSortKey;

  /// Set whether this circleAnnotation should be draggable, meaning it can be
  /// dragged across the screen when touched and moved.
  /// Accepted data type - bool
  /// default value is false
  final bool draggable;

  /// Set the arbitrary json data of the annotation.
  /// Accepted data type - Map<String, dynamic>
  /// default value is <String, dynamic>{}
  final Map<String, dynamic>? data;

  /// Constructor
  CircleAnnotationOptions({
    required this.point,
    this.circleColor,
    this.circleRadius,
    this.circleBlur,
    this.circleOpacity,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.circleStrokeWidth,
    this.circleSortKey,
    this.draggable = false,
    this.data,
  });

  /// Method to proceeds the circle annotation options for native
  @override
  Map<String, dynamic>? toArgs() {
    final args = <String, dynamic>{};

    args['point'] = point.toArgs();

    if (circleColor != null) {
      args['circleColor'] = circleColor;
    }

    if (circleRadius != null) {
      args['circleRadius'] = circleRadius;
    }

    if (circleBlur != null) {
      args['circleBlur'] = circleBlur;
    }

    if (circleOpacity != null) {
      args['circleOpacity'] = circleOpacity;
    }

    if (circleStrokeColor != null) {
      args['circleStrokeColor'] = circleStrokeColor;
    }

    if (circleStrokeWidth != null) {
      args['circleStrokeWidth'] = circleStrokeWidth;
    }

    if (circleStrokeOpacity != null) {
      args['circleStrokeOpacity'] = circleStrokeOpacity;
    }

    if (circleSortKey != null) {
      args['circleSortKey'] = circleSortKey;
    }

    if (data != null) {
      args['data'] = jsonEncode(data);
    }

    args['draggable'] = draggable;

    return args.isNotEmpty ? args : null;
  }
}
