# NaxaLibre

[![Pub](https://img.shields.io/pub/v/naxalibre)](https://pub.dev/packages/naxalibre)
[![License](https://img.shields.io/github/license/itheamc/naxalibre)](https://github.com/itheamc/naxalibre/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/itheamc/naxalibre.svg?style=social)](https://github.com/itheamc/naxalibre)

## Overview

**NaxaLibre** is a powerful and feature-rich MapLibre plugin for Flutter, designed to simplify and enhance geospatial mapping capabilities in mobile applications. Developed by [@itheamc](https://github.com/itheamc/), this plugin provides developers with a comprehensive toolkit for integrating interactive and customizable maps into their Flutter projects.

## Key Features

- Seamless integration with MapLibre Map SDK
- Support for both Android (v11.8.5) and iOS (v6.12.2)
- Comprehensive layer support (Circle, Line, Fill, Symbol, Raster, Hillshade, Heatmap, Fill Extrusion, Background)
- Multiple source types (Vector, Raster, RasterDem, GeoJson, Image)
- Advanced location services
- Flexible style and layer customization
- Expression and transition support

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  naxalibre: ^latest_version
```

Then run:

```bash
flutter pub get
```

## Getting Started

### 1. Location Permissions

#### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS (Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show it on the map.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to show it on the map.</string>
```

### 2. Basic Map Implementation

```dart
NaxaLibreMap(
  style: "your-style-url-or-json-style-string",
  locationSettings: LocationSettings(
    locationEnabled: true,
    shouldRequestAuthorizationOrPermission: true,
    locationComponentOptions: LocationComponentOptions(
      pulseColor: "red",
      backgroundTintColor: "yellow",
      foregroundTintColor: "green",
    ),
    locationEngineRequestOptions: LocationEngineRequestOptions(
      displacement: 10,
      priority: LocationEngineRequestPriority.highAccuracy,
      provider: LocationProvider.gps,
    ),
  ),
  hyperComposition: true,
  onMapCreated: onMapCreated,
  onStyleLoaded: () {
    // Handle style loading
  },
  onMapLoaded: () {
    // Handle map loading
  },
  onMapClick: (latLng) {
    // Handle map click events
  },
  onMapLongClick: (latLng) {
    // Handle long press events
  },
)
```

### 3. Adding Sources

#### GeoJSON Source Example
```dart
await _controller.addSource<GeoJsonSource>(
  source: GeoJsonSource(
    sourceId: "geojson-source-id",
    url: "https://example.com/your-geojson-data.geojson",
    sourceProperties: GeoJsonSourceProperties(
      cluster: true,
      clusterRadius: 50,
      clusterMaxZoom: 14,
      maxZoom: 20,
    ),
  ),
)
```

### 4. Adding Layers

#### Circle Layer
```dart
await _controller.addLayer<CircleLayer>(
  layer: CircleLayer(
    layerId: "my-circle-layer",
    sourceId: "geojson-source-id",
    layerProperties: CircleLayerProperties(
      circleColor: [
        'case',
        ['boolean', ['has', 'point_count'], true],
        'red',
        'blue'
      ],
      circleColorTransition: StyleTransition.build(
        delay: 500,
        duration: const Duration(milliseconds: 1000),
      ),
      circleRadius: [
        'case',
        ['boolean', ['has', 'point_count'], true],
        15,
        10
      ],
      circleStrokeWidth: [
        'case',
        ['boolean', ['has', 'point_count'], true],
        3,
        2
      ],
      circleStrokeColor: "#fff",
    ),
  ),
)
```

#### Symbol Layer
```dart
await _controller.addLayer<SymbolLayer>(
  layer: SymbolLayer(
    layerId: "symbol-layer-example",
    sourceId: "geojson-source-id",
    layerProperties: SymbolLayerProperties(
      textField: ['get', 'point_count_abbreviated'],
      textSize: 12,
      textColor: '#fff',
      iconSize: 1,
      iconAllowOverlap: true,
    ),
  ),
)
```

### 5. Adding Style Images

#### Local Asset Image
```dart
await _controller.addStyleImage<LocalStyleImage>(
  image: LocalStyleImage(
    imageId: "local-icon",
    imageName: "assets/images/your-image.png",
  ),
)
```

#### Network Image
```dart
await _controller.addStyleImage<NetworkStyleImage>(
  image: NetworkStyleImage(
    imageId: "network-icon",
    url: "https://example.com/icon.png",
  ),
)
```

### 6. Adding Annotations

#### Circle Annotation
```dart
    await controller?.addAnnotation<CircleAnnotation>(
      annotation: CircleAnnotation(
        options: CircleAnnotationOptions(
          point: LatLng(27.741712, 85.331033),
          circleColor: "red",
          circleStrokeColor: "white",
          circleStrokeWidth: 2.0,
          circleRadius: 12.0,
          circleRadiusTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
          circleColorTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
        ),
      ),
    );
```

#### Polygon Annotation
```dart
    await controller?.addAnnotation<PolygonAnnotation>(
      annotation: PolygonAnnotation(
        options: PolygonAnnotationOptions(
          points: [
            [
              LatLng(27.741712, 85.331033),
              LatLng(27.7420, 85.3412),
              LatLng(27.7525, 85.3578),
            ],
          ],
          fillColor: "red",
          fillOpacity: 0.15,
          fillOutlineColor: "blue",
        ),
      ),
    );
```

#### Point Annotation
```dart
    await controller?.addAnnotation<PointAnnotation>(
      annotation: PointAnnotation(
        image: NetworkStyleImage(
          imageId: "pointImageId",
          url:
              "https://www.cp-desk.com/wp-content/uploads/2019/02/map-marker-free-download-png.png",
        ),
        options: PointAnnotationOptions(
          point: LatLng(27.7525, 85.3578),
          iconSize: 0.1,
        ),
      ),
    );
```

#### Polyline Annotation
```dart
    await controller?.addAnnotation<PolylineAnnotation>(
      annotation: PolylineAnnotation(
        options: PolylineAnnotationOptions(
          points: [LatLng(27.741712, 85.331033), LatLng(27.7420, 85.3412)],
          lineColor: "red",
          lineWidth: 3.75,
          lineCap: LineCap.round,
          lineJoin: LineJoin.round,
        ),
      ),
    );
```

### 7. Offline Region

#### Download Region

##### Using `OfflineTilePyramidRegionDefinition`
```dart
    final definition = OfflineTilePyramidRegionDefinition(
      styleUrl: mapStyle,
      bounds: LatLngBounds(
        southwest: LatLng(27.84, 85.23),
        northeast: LatLng(27.88, 85.60),
      ),
      minZoom: 5.0,
      maxZoom: 10.0,
    );

    final metadata = OfflineRegionMetadata(
      name: 'Region_${DateTime.now().millisecondsSinceEpoch}',
      customAttributes: {
        'custom_attribute_1': 'value_1',
        'custom_attribute_2': 'value_2',
      }
    );

    await controller?.offlineManager.download(
      definition: definition,
      metadata: metadata,
      onInitiated: (regionId) {
        setState(() {
          _statusMessage = 'Download initiated for region ID: $regionId';
        });
      },
      onDownloading: (progress) {
        
      },
      onDownloaded: (region) {
  
      },
      onError: (error) {
       
      },
    );
```

##### Using `OfflineGeometryRegionDefinition`
```
      final geometryArgs = <String, dynamic>{
        "coordinates": [
            [
                [81.43286208834144, 29.168844681981057],
                [81.43272857503553, 28.154758204111474],
                [82.82808392041403, 28.00775457992897],
                [83.36951061373333, 28.59439547536701],
                [83.4215408561538, 29.268510933276843],
                [82.86979546062628, 29.667365733566996],
                [82.12016836359783, 29.748878555461047],
                [81.43286208834144, 29.168844681981057],
            ],
        ],
        "type": "Polygon",
      };

      final geometry = Geometry.fromArgs(geometryArgs);

      final definition = OfflineGeometryRegionDefinition(
        styleUrl: mapStyle,
        geometry: geometry,
        minZoom: 5.0,
        maxZoom: 15.0,
      );

      final metadata = OfflineRegionMetadata(
        name: 'Region_${DateTime.now().millisecondsSinceEpoch}',
      );

      await controller?.offlineManager.download(
        definition: definition,
        metadata: metadata,
        onInitiated: (regionId) {
         
        },
        onDownloading: (progress) {
         
        },
        onDownloaded: (region) {
         
        },
        onError: (error) {
        
        },
      );
```

#### Delete Offline Region
```dart
    final isDeleted = await controller?.offlineManager.delete(12);
```

#### Delete All Offline Regions
```dart
    // result is a map containing id as a key and bool value as status
    final result = await controller?.offlineManager.deleteAll();
```

## Supported MapLibre API Features

| Feature              | Android          | iOS                | 
|----------------------|------------------|--------------------| 
| Style                | ✅                | ✅                 | 
| Camera               | ✅                | ✅                 | 
| Current Location     | ✅                | ✅                 |
| Circle Layer         | ✅                | ✅                 | 
| Line Layer           | ✅                | ✅                 | 
| Fill Layer           | ✅                | ✅                 | 
| Symbol Layer         | ✅                | ✅                 | 
| Raster Layer         | ✅                | ✅                 | 
| Hillshade Layer      | ✅                | ✅                 | 
| Heatmap Layer        | ✅                | ✅                 | 
| Fill Extrusion Layer | ✅                | ✅                 |
| Background Layer     | ✅                | ✅                 |
| Vector Source        | ✅                | ✅                 | 
| Raster Source        | ✅                | ✅                 | 
| RasterDem Source     | ✅                | ✅                 | 
| GeoJson Source       | ✅                | ✅                 | 
| Image Source         | ✅                | ✅                 |
| Expressions          | ✅                | ✅                 |
| Transitions          | ✅                | ✅                 |
| Annotations          | ✅                | ✅                 |
| Offline Manager      | ✅                | ✅                 |

## Limitations and Considerations

- SVG images are currently not supported
- Ensure proper location permissions are set for location-based features

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms of the LICENSE file in the repository.

## Author

[@itheamc](https://github.com/itheamc/)
