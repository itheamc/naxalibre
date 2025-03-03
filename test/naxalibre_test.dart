import 'dart:typed_data';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naxalibre/naxalibre.dart';
import 'package:naxalibre/src/naxalibre_method_channel.dart';
import 'package:naxalibre/src/naxalibre_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNaxaLibrePlatform
    with MockPlatformInterfaceMixin
    implements NaxaLibrePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    bool hyperComposition = false,
  }) {
    // TODO: implement buildMapView
    throw UnimplementedError();
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
  void setAttributionMargins(double left, double top, double right, double bottom) {
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
    // TODO: implement setStyle
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
    // TODO: implement zoomBy
  }

  @override
  void zoomIn() {
    // TODO: implement zoomIn
  }

  @override
  void zoomOut() {
    // TODO: implement zoomOut
  }
}

void main() {
  final NaxaLibrePlatform initialPlatform = NaxaLibrePlatform.instance;

  test('$MethodChannelNaxaLibre is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNaxaLibre>());
  });
}
