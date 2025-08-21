import 'dart:ui';

class GeoJson {
  GeoJson({this.type, this.features = const []});

  final String? type;
  final List<Feature> features;

  GeoJson copy({String? type, List<Feature>? features}) {
    return GeoJson(
      type: type ?? this.type,
      features: features ?? this.features,
    );
  }

  factory GeoJson.fromJson(Map<String, dynamic> json) {
    return GeoJson(
      type: json["type"],
      features:
          json["features"] == null
              ? []
              : List<Feature>.from(
                json["features"]!.map((x) => Feature.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "features": features.map((x) => x.toJson()).toList(),
  };
}

class Feature {
  Feature({
    this.type,
    this.properties,
    this.geometry,
    this.id,
    this.offset,
    this.isCluster = false,
    this.clusteredFeatures,
  });

  final String? type;
  final Properties? properties;
  final Geometry? geometry;
  final String? id;

  // Just for screen coordinate
  final Offset? offset;

  // Flag for checking if feature is cluster
  final bool isCluster;

  // Clustered features
  final List<Feature>? clusteredFeatures;

  Feature copy({
    String? type,
    Properties? properties,
    Geometry? geometry,
    String? id,
    Offset? offset,
    bool? isCluster,
    List<Feature>? clusteredFeatures,
  }) {
    return Feature(
      type: type ?? this.type,
      properties: properties ?? this.properties,
      geometry: geometry ?? this.geometry,
      id: id ?? this.id,
      offset: offset ?? this.offset,
      isCluster: isCluster ?? this.isCluster,
      clusteredFeatures: clusteredFeatures ?? this.clusteredFeatures,
    );
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json["type"],
      properties:
          json["properties"] == null
              ? null
              : Properties.fromJson(json["properties"]),
      geometry:
          json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      id: json["id"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties?.toJson(),
    "geometry": geometry?.toJson(),
    "id": id,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feature &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          properties == other.properties &&
          geometry == other.geometry &&
          id == other.id &&
          offset == other.offset &&
          isCluster == other.isCluster &&
          clusteredFeatures == other.clusteredFeatures;

  @override
  int get hashCode => Object.hash(
    type,
    properties,
    geometry,
    id,
    offset,
    isCluster,
    clusteredFeatures,
  );
}

class Geometry {
  Geometry({this.type, this.coordinates = const []});

  final String? type;
  final List<double> coordinates;

  Geometry copy({String? type, List<double>? coordinates}) {
    return Geometry(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json["type"],
      coordinates:
          json["coordinates"] == null
              ? []
              : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates.map((x) => x).toList(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Geometry &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          coordinates == other.coordinates;

  @override
  int get hashCode => Object.hash(type, coordinates);
}

class Properties {
  Properties({this.json = const {}});

  final Map<String, dynamic> json;

  factory Properties.fromJson(dynamic json) {
    return Properties(
      json: json.map<String, dynamic>((k, v) => MapEntry(k.toString(), v)),
    );
  }

  Map<String, dynamic> toJson() => json;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Properties &&
          runtimeType == other.runtimeType &&
          json == other.json;

  @override
  int get hashCode => json.hashCode;
}
