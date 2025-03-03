import 'dart:io';

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
  NaxaLibreController? _controller;

  Uint8List? _snapshot;

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
        body: Stack(
          children: [
            NaxaLibreMap(
              style:
                  "https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json",
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
                ),
              ),
              hyperComposition: false,
              onMapCreated: (c) {
                print("=============onMapCreated");
                _controller = c;
                _controller?.addOnRotateListener((event, v1, v2, v3) {
                  print("=============onRotate $event $v1 $v2 $v3");
                });
                _controller?.addOnFlingListener(() {
                  print("=============onFling");
                });
              },
              onStyleLoaded: () {
                print("=============OnStyleLoaded");
              },
              onMapLoaded: () {
                print("=============onMapLoaded");
              },
              onMapClick: (latLng) async {
                print("=============onMapClick ${latLng.latLngList()}");

                // final queried = await _controller?.queryRenderedFeatures(
                //   RenderedCoordinates.fromLatLng(latLng),
                //   layerIds: ["lineLayerId", "layerId", "symbolLayerId"],
                // );
                //
                // print("=============onMapClick ${queried?.map((e) => e.toArgs())}");
              },
              onMapLongClick: (latLng) async {
                print("=============onMapLongClick ${latLng.latLngList()}");
                final layers = await _controller?.getLayers();
                if (layers != null) {
                  print(layers.map((l) => l["id"]).nonNulls.toList());
                }
              },
            ),
            if (_snapshot != null)
              Center(child: Image.memory(_snapshot!, width: 200)),
          ],
        ),
        floatingActionButton: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8.0,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.zoomIn();
                  },
                  label: const Text("Zoom In"),
                  icon: Icon(Icons.zoom_in),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.zoomOut();
                  },
                  label: const Text("Zoom Out"),
                  icon: Icon(Icons.zoom_out),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.setStyle(
                      "https://tiles.basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json",
                    );
                  },
                  label: const Text("Toggle Style"),
                  icon: Icon(Icons.style),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final layers = await _controller?.getLayer("background");
                    print(layers);
                    _controller?.animateCamera(
                      CameraUpdateFactory.newLatLng(const LatLng(27.34, 85.73)),
                      duration: 5000,
                    );
                  },
                  label: const Text("To New LatLng"),
                  icon: Icon(Icons.golf_course),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.animateCamera(
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
                    _controller?.animateCamera(
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
                    _controller?.animateCamera(
                      CameraUpdateFactory.zoomTo(10),
                      duration: 5000,
                    );
                  },
                  label: Text("ZoomTo"),
                  icon: Icon(Icons.zoom_out_map),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.animateCamera(
                      CameraUpdateFactory.zoomBy(2),
                      duration: 5000,
                    );
                  },
                  label: Text("ZoomBy (2)"),
                  icon: Icon(Icons.zoom_out_map),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller?.animateCamera(
                      CameraUpdateFactory.zoomBy(-2),
                      duration: 5000,
                    );
                  },
                  label: Text("ZoomBy (-2)"),
                  icon: Icon(Icons.zoom_out_map),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _controller?.addSource<GeoJsonSource>(
                      source: GeoJsonSource(
                        sourceId: "sourceId",
                        url:
                            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_populated_places.geojson",
                        sourceProperties: GeoJsonSourceProperties(
                          cluster: true,
                        ),
                      ),
                    );

                    await _controller?.addStyleImage(
                      image: NetworkStyleImage(
                        imageId: 'test_icon',
                        url:
                            'https://www.pngplay.com/wp-content/uploads/9/Map-Marker-PNG-Pic-Background.png',
                      ),
                    );

                    await _controller?.addLayer<CircleLayer>(
                      layer: CircleLayer(
                        layerId: "layerId",
                        sourceId: "sourceId",
                        layerProperties: CircleLayerProperties(
                          circleColor: [
                            'case',
                            [
                              '!',
                              ['has', 'point_count'],
                            ],
                            'blue',
                            'red',
                          ],
                          circleRadius: [
                            'case',
                            [
                              '!',
                              ['has', 'point_count'],
                            ],
                            12,
                            14,
                          ],
                          circleRadiusTransition: StyleTransition.build(
                            delay: 1500,
                            duration: const Duration(milliseconds: 2000),
                          ),
                          circleColorTransition: StyleTransition.build(
                            delay: 1500,
                            duration: const Duration(milliseconds: 2000),
                          ),
                          circleStrokeWidth: 2.0,
                          circleStrokeColor: "white",
                        ),
                      ),
                    );

                    await _controller?.addLayer<SymbolLayer>(
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
                              ['has', 'point_count'],
                            ],
                            'test_icon',
                            '',
                          ],
                          iconSize: Platform.isIOS ? 0.035 : 0.075,
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
                    if ((await _controller?.isLayerExist('lineLayerId')) ==
                        true) {
                      await _controller?.removeLayer('lineLayerId');
                    }

                    if ((await _controller?.isSourceExist('lineSourceId')) ==
                        true) {
                      await _controller?.removeSource('lineSourceId');
                    }

                    await _controller?.addSource<GeoJsonSource>(
                      source: GeoJsonSource(
                        sourceId: "lineSourceId",
                        url:
                            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_rivers_europe.geojson",
                      ),
                    );

                    await _controller?.addLayerBelow<LineLayer>(
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
                            'red',
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
                    if ((await _controller?.isLayerExist('fillLayerId')) ==
                        true) {
                      await _controller?.removeLayer('fillLayerId');
                    }

                    if ((await _controller?.isSourceExist('fillSourceId')) ==
                        true) {
                      await _controller?.removeSource('fillSourceId');
                    }

                    await _controller?.addSource<GeoJsonSource>(
                      source: GeoJsonSource(
                        sourceId: "fillSourceId",
                        url:
                            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_map_subunits.geojson",
                      ),
                    );

                    await _controller?.addLayer<FillLayer>(
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
                FloatingActionButton.extended(
                  onPressed: () async {
                    final location = await _controller?.lastKnownLocation();

                    print(location?.toArgs().toString() ?? "Null");
                  },
                  label: Text("Last Known Location"),
                  icon: Icon(Icons.location_searching),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final image = await _controller?.snapshot();

                    setState(() {
                      _snapshot = image;
                    });

                    Future.delayed(const Duration(milliseconds: 1500), () {
                      setState(() {
                        _snapshot = null;
                      });
                    });
                  },
                  label: Text("Snapshot"),
                  icon: Icon(Icons.photo_camera_outlined),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _controller?.setMaximumFps(240);
                  },
                  label: Text("Set Fps (240)"),
                  icon: Icon(Icons.five_k_plus_sharp),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _controller?.setMaximumFps(120);
                  },
                  label: Text("Set Fps (120)"),
                  icon: Icon(Icons.four_k_plus_sharp),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _controller?.setMaximumFps(60);
                  },
                  label: Text("Set Fps (60)"),
                  icon: Icon(Icons.sixty_fps_select),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final light = await _controller?.getLight();
                    print("""
                    Light Date is ->
                    Intensity: ${light?.intensity},
                    Color: ${light?.color},
                    """);
                  },
                  label: Text("Get Light"),
                  icon: Icon(Icons.light),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final json = await _controller?.getJson();
                    print(json);
                  },
                  label: Text("Get Json"),
                  icon: Icon(Icons.data_object),
                ),
              ],
            ),
          ),
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
      appBar: AppBar(title: const Text('Another Page')),
      body: const NaxaLibreMap(),
    );
  }
}
