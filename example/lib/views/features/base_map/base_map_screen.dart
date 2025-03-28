import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

// Base screen with common functionality for all map screens
abstract class BaseMapScreen extends StatefulWidget {
  final String title;

  const BaseMapScreen({super.key, required this.title});
}

abstract class BaseMapScreenState<T extends BaseMapScreen> extends State<T> {
  NaxaLibreController? controller;
  final String mapStyle =
      "https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json";
  final String darkMapStyle =
      "https://tiles.basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      ),
      body: buildMapWithControls(),
    );
  }

  Widget buildMapWithControls();

  Widget buildBaseMap() {
    return NaxaLibreMap(
      style: mapStyle,
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
      hyperCompositionMode: HyperCompositionMode.surfaceView,
      onMapCreated: onMapCreated,
      onStyleLoaded: () {
        debugPrint("[OnStyleLoaded] Style loaded");
      },
      onMapLoaded: () {
        debugPrint("[onMapLoaded] Map loaded");
      },
      onMapClick: (latLng) {
        debugPrint("[onMapClick] Click on map at ${latLng.latLngList()}");
      },
      onMapLongClick: (latLng) async {
        debugPrint(
          "[onMapLongClick] Long click on map at ${latLng.latLngList()}",
        );
      },
    );
  }

  void onMapCreated(NaxaLibreController mapController) {
    debugPrint("[onMapCreated] Map created");
    controller = mapController;
    onControllerReady(mapController);
  }

  void onControllerReady(NaxaLibreController? controller) {
    // Override in subclasses
  }
}
