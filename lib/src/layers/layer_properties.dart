/// LayerProperties abstract class
///
/// A base class for properties related to layers in a map. This class serves
/// as a blueprint for defining the properties of different layer types (e.g.,
/// symbol layers, raster layers, etc.) in the map. It provides an abstract
/// method that should be implemented by subclasses to convert the properties
/// into a map format suitable for communication with the native platform.
///
abstract class LayerProperties {

  /// Method to convert LayerProperties object to Map
  ///
  /// This method should be implemented by subclasses to serialize the layer
  /// properties into a `Map<String, dynamic>` format. The map is used to pass
  /// the properties to the native platform.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the serialized layer properties,
  /// or `null` if there are no properties to serialize.
  Map<String, dynamic>? toArgs();
}

