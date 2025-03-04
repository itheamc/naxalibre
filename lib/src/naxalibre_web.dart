// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'naxalibre_platform_interface.dart';

/// A web implementation of the NaxalibrePlatform of the Naxalibre plugin.
class NaxaLibreWeb extends NaxaLibrePlatform {
  /// Constructs a NaxalibreWeb
  NaxaLibreWeb();

  static void registerWith(Registrar registrar) {
    NaxaLibrePlatform.instance = NaxaLibreWeb();
  }

  @override
  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    bool hyperComposition = false,
  }) {
    // TODO: implement buildMapView
    throw UnimplementedError();
  }
}
