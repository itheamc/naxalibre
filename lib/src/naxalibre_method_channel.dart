import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:naxalibre/src/pigeon_generated.dart';

import 'naxalibre_platform_interface.dart';

/// An implementation of [NaxaLibrePlatform] that uses method channels.
class MethodChannelNaxaLibre extends NaxaLibrePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('naxalibre');

  static const _viewType = "naxalibre/mapview";

  final _hostApi = NaxaLibreHostApi();

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    bool hyperComposition = false,
  }) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
      );
    }

    return Platform.isIOS
        ? UiKitView(
            viewType: _viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: onPlatformViewCreated,
            gestureRecognizers: gestureRecognizers,
          )
        : const Text('MapLibre is only implemented for iOS in this example');
  }

  @override
  void addImage(String name, Uint8List bytes) {
    // TODO: implement addImage
  }

  @override
  void addImages(Map<String, Uint8List> images) {
    // TODO: implement addImages
  }

  @override
  void addLayer(Map<String, Object> layer) {
    // TODO: implement addLayer
  }

  @override
  void addSource(Map<String, Object> source) {
    // TODO: implement addSource
  }

  @override
  void animateCamera(Map<String, Object?> args) {
    // TODO: implement animateCamera
  }

  @override
  void easeCamera(Map<String, Object?> args) {
    // TODO: implement easeCamera
  }

  @override
  List<double> fromScreenLocation(List<double> point) {
    // TODO: implement fromScreenLocation
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> getCameraForLatLngBounds(Map<String, Object?> bounds) {
    // TODO: implement getCameraForLatLngBounds
    throw UnimplementedError();
  }

  @override
  Map<String, Object> getCameraPosition() {
    // TODO: implement getCameraPosition
    throw UnimplementedError();
  }

  @override
  double getHeight() {
    // TODO: implement getHeight
    throw UnimplementedError();
  }

  @override
  Uint8List getImage(String id) {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  @override
  String getJson() {
    // TODO: implement getJson
    throw UnimplementedError();
  }

  @override
  List<double> getLatLngForProjectedMeters(double northing, double easting) {
    // TODO: implement getLatLngForProjectedMeters
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> getLayer(String id) {
    // TODO: implement getLayer
    throw UnimplementedError();
  }

  @override
  List<Map<String, Object?>> getLayers(String id) {
    // TODO: implement getLayers
    throw UnimplementedError();
  }

  @override
  Map<String, Object> getLight() {
    // TODO: implement getLight
    throw UnimplementedError();
  }

  @override
  double getMaximumPitch() {
    // TODO: implement getMaximumPitch
    throw UnimplementedError();
  }

  @override
  double getMaximumZoom() {
    // TODO: implement getMaximumZoom
    throw UnimplementedError();
  }

  @override
  double getMinimumPitch() {
    // TODO: implement getMinimumPitch
    throw UnimplementedError();
  }

  @override
  double getMinimumZoom() {
    // TODO: implement getMinimumZoom
    throw UnimplementedError();
  }

  @override
  double getPixelRatio() {
    // TODO: implement getPixelRatio
    throw UnimplementedError();
  }

  @override
  List<double> getProjectedMetersForLatLng(List<double> latLng) {
    // TODO: implement getProjectedMetersForLatLng
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> getSource(String id) {
    // TODO: implement getSource
    throw UnimplementedError();
  }

  @override
  List<Map<String, Object?>> getSources() {
    // TODO: implement getSources
    throw UnimplementedError();
  }

  @override
  String getUri() {
    // TODO: implement getUri
    throw UnimplementedError();
  }

  @override
  List<List<double>> getVisibleRegion(bool ignorePadding) {
    // TODO: implement getVisibleRegion
    throw UnimplementedError();
  }

  @override
  double getWidth() {
    // TODO: implement getWidth
    throw UnimplementedError();
  }

  @override
  double getZoom() {
    // TODO: implement getZoom
    throw UnimplementedError();
  }

  @override
  bool isAttributionEnabled() {
    // TODO: implement isAttributionEnabled
    throw UnimplementedError();
  }

  @override
  bool isCompassEnabled() {
    // TODO: implement isCompassEnabled
    throw UnimplementedError();
  }

  @override
  bool isCompassFadeWhenFacingNorth() {
    // TODO: implement isCompassFadeWhenFacingNorth
    throw UnimplementedError();
  }

  @override
  bool isDestroyed() {
    // TODO: implement isDestroyed
    throw UnimplementedError();
  }

  @override
  bool isFullyLoaded() {
    // TODO: implement isFullyLoaded
    throw UnimplementedError();
  }

  @override
  bool isLogoEnabled() {
    // TODO: implement isLogoEnabled
    throw UnimplementedError();
  }

  @override
  List<Map<String, Object?>> queryRenderedFeatures(Map<String, Object?> args) {
    // TODO: implement queryRenderedFeatures
    throw UnimplementedError();
  }

  @override
  void removeImage(String name) {
    // TODO: implement removeImage
  }

  @override
  bool removeLayer(String id) {
    // TODO: implement removeLayer
    throw UnimplementedError();
  }

  @override
  bool removeLayerAt(int index) {
    // TODO: implement removeLayerAt
    throw UnimplementedError();
  }

  @override
  bool removeSource(String id) {
    // TODO: implement removeSource
    throw UnimplementedError();
  }

  @override
  void setAttributionMargins(
      double left, double top, double right, double bottom) {
    // TODO: implement setAttributionMargins
  }

  @override
  void setAttributionTintColor(int color) {
    // TODO: implement setAttributionTintColor
  }

  @override
  void setCompassFadeFacingNorth(bool compassFadeFacingNorth) {
    // TODO: implement setCompassFadeFacingNorth
  }

  @override
  void setCompassImage(Uint8List bytes) {
    // TODO: implement setCompassImage
  }

  @override
  void setCompassMargins(double left, double top, double right, double bottom) {
    // TODO: implement setCompassMargins
  }

  @override
  void setLogoMargins(double left, double top, double right, double bottom) {
    // TODO: implement setLogoMargins
  }

  @override
  void setMaximumFps(int fps) {
    // TODO: implement setMaximumFps
  }

  @override
  void setStyle(String style) {
    _hostApi.setStyle(style);
  }

  @override
  void setSwapBehaviorFlush(bool flush) {
    // TODO: implement setSwapBehaviorFlush
  }

  @override
  List<double> toScreenLocation(List<double> latLng) {
    // TODO: implement toScreenLocation
    throw UnimplementedError();
  }

  @override
  void zoomBy(int by) {
    _hostApi.zoomBy(by);
  }

  @override
  void zoomIn() {
    _hostApi.zoomIn();
  }

  @override
  void zoomOut() {
    _hostApi.zoomOut();
  }
}
