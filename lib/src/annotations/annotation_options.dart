part of 'annotation.dart';

/// AnnotationOptions abstract class
///
/// This class serves as the base for all annotation options. It defines the common
/// interface for any specific annotation options that might be used in a mapping
/// or graphics system. The class provides a method to convert the annotation options
/// into a map representation for further processing or serialization.
///
/// Method:
/// - [toArgs] : A method that must be implemented in subclasses to convert the
///   annotation options object into a `Map<String, dynamic>`. This method allows
///   the options to be serialized or used for further processing.
///
/// Subclasses of [AnnotationOptions] should implement the `toMap` method to provide
/// their own specific logic for converting the options into a map.
abstract class AnnotationOptions {
  /// Method to convert AnnotationOptions object to Map.
  ///
  /// This abstract method must be implemented by subclasses to define how to
  /// convert the annotation options into a Map representation. The Map format
  /// can be used for further processing or serialization.
  Map<String, dynamic>? toArgs();
}
