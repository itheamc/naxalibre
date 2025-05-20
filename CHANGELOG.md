## 0.0.10

* Added toScreenLocations method
* Added fromScreenLocations method
* Added setAllGesturesEnabled method to enable or disable all gestures

## 0.0.9

* Fixes raster source related issues on Android ([#42](https://github.com/itheamc/naxalibre/issues/42))
* Fixes visibility properties parsing related issue on iOS

## 0.0.8

* Upgraded MapLibre Android SDK to v11.8.8
* Upgraded MapLibre iOS SDK to v6.13.0
* Fixes layer visibility related issues ([#38](https://github.com/itheamc/naxalibre/issues/38))

## 0.0.7

* Upgraded MapLibre iOS SDK to v6.12.3
* Added addSourceWithLayers, setGeoJsonData and setGeoJsonUri methods in controller
* Added factory method fromGeometry in GeoJson
* Fixes vector tile not loading on iOS
* Fixes raster and raster dem tile not loading on iOS

## 0.0.6

* Updated android MapLibre SDK version to v11.8.5 and iOS to v6.12.2
* Fixes issues arise while downloading offline region using geometry
* Fixes issues related to raster and raster dem sources ([#28](https://github.com/itheamc/naxalibre/issues/28))
* Fixes app crashing related issues on frequent map open close in android
* Fixes geometry args parsing related issues in android and ios ([#26](https://github.com/itheamc/naxalibre/issues/26))
* Added annotation click and long click event listener
* Added support for annotation dragging ([#25](https://github.com/itheamc/naxalibre/issues/25))
* Added support for annotation update ([#32](https://github.com/itheamc/naxalibre/issues/32))
* Added support for annotation remove or delete
* Fixes style transition duration related issue in iOS


## 0.0.5

* Added support for offline regions

## 0.0.4

* Updated documentation

## 0.0.3

* Added method reset north
* Added support for annotations
* Shown attributions from sources in Attribution dialog
* Fixes raw json style string not working on iOS
* Fixes getJson() not returning correct style json
* Added different Hybrid Composition modes

## 0.0.2

* Fixes bugs related to queryRenderedFeatures method
* Other minor changes

## 0.0.1

* Seamless integration with MapLibre Map SDK
* Support for both Android (v11.8.2) and iOS (v6.11.0)
* Comprehensive layer support (Circle, Line, Fill, Symbol, Raster, Hillshade, Heatmap, Fill
  Extrusion, Background)
* Multiple source types (Vector, Raster, RasterDem, GeoJson, Image)
* Advanced location services
* Flexible style and layer customization
* Expression and transition support
