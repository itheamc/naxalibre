import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:naxalibre/naxalibre.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _naxalibrePlugin = NaxaLibre();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Plugin example app'),
          backgroundColor: Colors.transparent,
        ),
        body: const MapLibreView(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8.0,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                NaxaLibrePlatform.instance.zoomIn();
              },
              label: const Text("Zoom In"),
              icon: Icon(Icons.zoom_in),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                NaxaLibrePlatform.instance.zoomOut();
              },
              label: const Text("Zoom Out"),
              icon: Icon(Icons.zoom_out),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                NaxaLibrePlatform.instance.setStyle(
                    "https://tiles.basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json");
              },
              label: const Text("Toggle Style"),
              icon: Icon(Icons.style),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.newLatLng(
                    const LatLng(27.34, 85.73),
                  ),
                  duration: 5000,
                );
              },
              label: const Text("To New LatLng"),
              icon: Icon(Icons.golf_course),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.newCameraPosition(
                    const CameraPosition(
                      target: LatLng(27.38, 85.75),
                      zoom: 16,
                      bearing: 0,
                      tilt: 0,
                    ),
                  ),
                  duration: 5000,
                );
              },
              label: const Text("To Camera Position"),
              icon: Icon(Icons.golf_course),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.newLatLngBounds(
                    const LatLngBounds(
                      southwest: LatLng(27.34, 85.73),
                      northeast: LatLng(27.35, 85.74),
                    ),
                    tilt: 5,
                    padding: 0,
                    bearing: 90,
                  ),
                  duration: 5000,
                );
              },
              label: const Text("To LatLng Bounds"),
              icon: Icon(Icons.rectangle_outlined),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.zoomTo(10),
                  duration: 5000,
                );
              },
              label: Text("ZoomTo"),
              icon: Icon(Icons.zoom_out_map),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.zoomBy(2.0),
                  duration: 500,
                );
              },
              label: Text("ZoomBy (2)"),
              icon: Icon(Icons.zoom_out_map),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                final controller = NaxaLibreControllerImpl();
                controller.animateCamera(
                  CameraUpdateFactory.zoomBy(-2.0),
                  duration: 500,
                );
              },
              label: Text("ZoomBy (-2)"),
              icon: Icon(Icons.zoom_out_map),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                final controller = NaxaLibreControllerImpl();
                await controller.addSource<GeoJsonSource>(
                  source: GeoJsonSource(
                      sourceId: "sourceId",
                      url:
                          "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_populated_places.geojson",
                      sourceProperties: GeoJsonSourceProperties(cluster: true)),
                );

                await controller.addStyleImage(
                  image: NetworkStyleImage(
                    imageId: 'test_icon',
                    url:
                        'https://www.pngplay.com/wp-content/uploads/9/Map-Marker-PNG-Pic-Background.png',
                  ),
                );

                await controller.addLayer<CircleLayer>(
                  layer: CircleLayer(
                    layerId: "layerId",
                    sourceId: "sourceId",
                    layerProperties: CircleLayerProperties(
                      circleColor: [
                        'case',
                        [
                          '!',
                          ['has', 'point_count']
                        ],
                        'blue',
                        'red'
                      ],
                      circleRadius: [
                        'case',
                        [
                          '!',
                          ['has', 'point_count']
                        ],
                        12,
                        14
                      ],
                      circleRadiusTransition: StyleTransition.build(
                        delay: 1500,
                        duration: const Duration(
                          milliseconds: 2000,
                        ),
                      ),
                      circleColorTransition: StyleTransition.build(
                        delay: 1500,
                        duration: const Duration(
                          milliseconds: 2000,
                        ),
                      ),
                      circleStrokeWidth: 2.0,
                      circleStrokeColor: "#fff",
                    ),
                  ),
                );

                await controller.addLayer<SymbolLayer>(
                  layer: SymbolLayer(
                    layerId: "symbolLayerId",
                    sourceId: "sourceId",
                    layerProperties: SymbolLayerProperties(
                      textColor: "yellow",
                      textField: ['get', 'point_count_abbreviated'],
                      textSize: 10,
                      iconImage: [
                        'case',
                        [
                          '!',
                          ['has', 'point_count']
                        ],
                        'test_icon',
                        ''
                      ],
                      iconSize: 0.075,
                      iconColor: "#fff",
                    ),
                  ),
                );
              },
              label: Text("Add Circle Layer"),
              icon: Icon(Icons.zoom_out_map),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                final controller = NaxaLibreControllerImpl();

                if (await controller.isLayerExist('lineLayerId')) {
                  await controller.removeLayer('lineLayerId');
                }

                if (await controller.isSourceExist('lineSourceId')) {
                  await controller.removeSource('lineSourceId');
                }

                await controller.addSource<GeoJsonSource>(
                  source: GeoJsonSource(
                    sourceId: "lineSourceId",
                    url:
                        "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_rivers_europe.geojson",
                  ),
                );

                await controller.addLayerBelow<LineLayer>(
                  layer: LineLayer(
                    layerId: "lineLayerId",
                    sourceId: "lineSourceId",
                    layerProperties: LineLayerProperties(
                      lineColor: "red",
                      lineWidth: 2,
                      lineGradient: [
                        'interpolate',
                        ['linear'],
                        ['line-progress'],
                        0,
                        'blue',
                        0.1,
                        'royalblue',
                        0.3,
                        'cyan',
                        0.5,
                        'lime',
                        0.7,
                        'yellow',
                        1,
                        'red'
                      ],
                    ),
                  ),
                  below: "fillLayerId",
                );
              },
              label: Text("Add Line Layer"),
              icon: Icon(Icons.layers_outlined),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                final controller = NaxaLibreControllerImpl();

                if (await controller.isLayerExist('fillLayerId')) {
                  await controller.removeLayer('fillLayerId');
                }

                if (await controller.isSourceExist('fillSourceId')) {
                  await controller.removeSource('fillSourceId');
                }

                await controller.addSource<GeoJsonSource>(
                  source: GeoJsonSource(
                    sourceId: "fillSourceId",
                    url:
                        "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_map_subunits.geojson",
                  ),
                );

                await controller.addLayer<FillLayer>(
                  layer: FillLayer(
                    layerId: "fillLayerId",
                    sourceId: "fillSourceId",
                    layerProperties: FillLayerProperties(
                      fillColor: "red",
                      fillOpacity: 0.15,
                      fillOutlineColor: "red",
                    ),
                  ),
                );
              },
              label: Text("Add Fill Layer"),
              icon: Icon(Icons.layers_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class AnotherPage extends StatelessWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Page'),
      ),
      body: const MapLibreView(),
    );
  }
}
