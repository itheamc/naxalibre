import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import '../enums/enums.dart';
import '../models/latlng.dart';
import '../models/style_transition.dart';
import '../utils/naxalibre_logger.dart';

part 'annotation_options.dart';
part 'circle_annotation.dart';
part 'point_annotation.dart';
part 'polygon_annotation.dart';
part 'polyline_annotation.dart';

/// Abstract Annotation class
///
/// This class represents a base abstraction for annotations in a mapping or graphics system.
/// It defines a general structure for annotations that include options and methods to convert
/// the annotation to a map representation. The class is generic, allowing for different types
/// of annotation options through the type parameter [T].
///
/// Properties:
/// - [annotationOptions] : A generic property that holds the specific options needed
///   to build and create the annotation. The type of this property is determined by the
///   generic type [T].
///
/// Constructor:
/// - The constructor requires an instance of [annotationOptions], which specifies the
///   options or properties needed to create the annotation.
///
/// Abstract Method:
/// - [toArgs] : A method that must be implemented in subclasses to convert the annotation
///   object into a json map. The Map will represent the annotation in a
///   suitable format for further processing or use.
abstract class Annotation<T> {
  /// Type of the annotation
  ///
  String get type;

  /// AnnotationOptions
  /// It contains the properties that are needed to build and create an annotation.
  final T annotationOptions;

  /// Constructor to initialize the annotation with the given options.
  ///
  /// [annotationOptions] - The specific properties or options needed to build the annotation.
  /// This is a required parameter, and its type is determined by the generic type [T].
  Annotation({required this.annotationOptions});

  /// Method to convert the Annotation object to a Map.
  ///
  /// This abstract method must be implemented by subclasses to define how to convert
  /// the annotation object into a Map representation. The Map can then be used for
  /// further processing or serialization.
  Map<String, dynamic> toArgs();
}
