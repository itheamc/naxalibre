import 'package:flutter/material.dart';

import 'controller/naxalibre_controller.dart';
import 'controller/naxalibre_controller_impl.dart';
import 'enums/enums.dart';
import 'listeners/naxalibre_listeners.dart';
import 'models/location_settings.dart';
import 'models/naxalibre_map_options.dart';
import 'models/ui_settings.dart';
import 'naxalibre_platform_interface.dart';
import 'typedefs/typedefs.dart';
import 'utils/naxalibre_logger.dart';

/// [NaxaLibreMap] for widget for displaying a NaxaLibre map.
///
class NaxaLibreMap extends StatefulWidget {
  /// Creates a widget for displaying a NaxaLibre map.
  ///
  /// The [style] parameter defines the initial map style, with a default value of
  /// "https://demotiles.maplibre.org/style.json".
  ///
  /// The [mapOptions] parameter allows customization of map options such as zoom levels
  /// and camera position.
  ///
  /// The [uiSettings] parameter enables customization of UI elements like the Maplibre logo.
  ///
  /// The [locationSettings] parameter provides settings for a location component.
  ///
  /// Callback parameters like [onMapCreated], [onMapLoaded], [onStyleLoaded], [onMapClick],
  /// [onMapLongClick], [onCameraMoveStarted], [onCameraMove], [onCameraMoveEnd], and [onCameraIdle]
  /// allow for interaction with the map and its events.
  ///
  /// The [hyperComposition] parameter determines whether to use hybrid composition for the map view.
  ///
  const NaxaLibreMap({
    super.key,
    this.style = "https://demotiles.maplibre.org/style.json",
    this.mapOptions = const NaxaLibreMapOptions(),
    this.uiSettings = const UiSettings(),
    this.locationSettings = const LocationSettings(),
    this.onMapCreated,
    this.onMapLoaded,
    this.onStyleLoaded,
    this.onMapClick,
    this.onMapLongClick,
    this.onCameraMove,
    this.onCameraIdle,
    this.hyperCompositionMode = HyperCompositionMode.disabled,
  });

  /// [style] An initial map style whenever map loaded
  /// default value is https://demotiles.maplibre.org/style.json
  final String style;

  /// [NaxaLibreMapOptions] defines various configuration options for the NaxaLibreMap.
  ///
  /// It allows customization of zoom levels, pitch limits, camera position,
  /// rendering behavior, and debug options.
  ///
  final NaxaLibreMapOptions mapOptions;

  /// [UiSettings] is a class that allows customization of various features
  /// such as the visibility of the Maplibre logo, compass, and attribution,
  /// as well as gesture controls.
  ///
  final UiSettings uiSettings;

  /// [LocationSettings] the settings for a location component.
  /// It encapsulates the configuration for enabling or disabling the location
  /// component and provides additional options for customizing its appearance and behavior
  final LocationSettings locationSettings;

  /// [onMapCreated] A callback that will be triggered whenever platform view
  /// for mapbox map is created
  final OnMapCreated? onMapCreated;

  /// [onMapLoaded] A callback that will be triggered whenever map is
  /// fully loaded/created
  final OnMapLoaded? onMapLoaded;

  /// [onStyleLoaded] A callback that will be triggered whenever style is loaded
  final OnStyleLoaded? onStyleLoaded;

  /// [onMapClick] A callback that will be triggered whenever user click
  /// anywhere on the map
  final OnMapClick? onMapClick;

  /// [onMapLongClick] A callback that will be triggered whenever user long
  /// click anywhere on the map
  final OnMapLongClick? onMapLongClick;

  /// [onCameraMove] A callback that will be triggered whenever map camera is moving.
  final OnCameraMove? onCameraMove;

  /// [onCameraIdle] A callback that will be triggered whenever map camera become
  /// idle. i.e. camera/map stop moving
  ///
  final OnCameraIdle? onCameraIdle;

  /// The hyper-composition mode used for rendering.
  ///
  /// Hyper-composition optimizes the rendering of complex UI elements, especially
  /// those involving platform views or heavy drawing operations.
  ///
  /// The available modes are:
  ///
  /// * [HyperCompositionMode.disabled]: Hyper-composition is completely disabled.
  ///     This is the default mode.
  /// * [HyperCompositionMode.androidView]: Hyper-composition is enabled using an
  ///     Android View (TextureView on Android).
  /// * [HyperCompositionMode.surfaceView]: Hyper-composition is enabled using a
  ///     SurfaceView.
  /// * [HyperCompositionMode.expensiveView]: Hyper-composition is enabled using a
  ///     custom, potentially expensive, rendering strategy.
  ///
  /// Note: It doesn't have any effect on iOS and other platform.
  ///
  /// **Default value is [HyperCompositionMode.disabled].**
  final HyperCompositionMode hyperCompositionMode;

  @override
  State<NaxaLibreMap> createState() => _MapLibreViewState();
}

class _MapLibreViewState extends State<NaxaLibreMap> {
  NaxaLibreController? _libreController;

  @override
  void initState() {
    super.initState();
    final listeners = NaxaLibreListeners();
    _libreController = NaxaLibreControllerImpl(listeners);
    _addListeners();
  }

  /// Method to add listeners
  ///
  void _addListeners() {
    if (widget.onMapLoaded != null) {
      _libreController?.addOnMapLoadedListener(widget.onMapLoaded!);
    }

    if (widget.onStyleLoaded != null) {
      _libreController?.addOnStyleLoadedListener(widget.onStyleLoaded!);
    }

    if (widget.onMapClick != null) {
      _libreController?.addOnMapClickListener(widget.onMapClick!);
    }

    if (widget.onMapLongClick != null) {
      _libreController?.addOnMapLongClickListener(widget.onMapLongClick!);
    }

    if (widget.onCameraMove != null) {
      _libreController?.addOnCameraMoveListener(widget.onCameraMove!);
    }

    if (widget.onCameraIdle != null) {
      _libreController?.addOnCameraIdleListener(widget.onCameraIdle!);
    }

    widget.onMapCreated?.call(_libreController!);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = {
      'styleUrl': widget.style,
      'mapOptions': widget.mapOptions.toArgs(),
      'uiSettings': widget.uiSettings.toArgs(),
      'locationSettings': widget.locationSettings.toArgs(),
    };

    return NaxaLibrePlatform.instance.buildMapView(
      creationParams: creationParams,
      hyperCompositionMode: widget.hyperCompositionMode,
      onPlatformViewCreated: (id) {
        NaxaLibreLogger.logMessage("onPlatformViewCreated");
      },
    );
  }

  @override
  void dispose() {
    _libreController?.dispose();
    super.dispose();
  }
}
