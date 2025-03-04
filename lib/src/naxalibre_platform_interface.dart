import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'naxalibre_method_channel.dart';

abstract class NaxaLibrePlatform extends PlatformInterface {
  /// Constructs a NaxaLibrePlatform.
  NaxaLibrePlatform() : super(token: _token);

  static final Object _token = Object();

  static NaxaLibrePlatform _instance = MethodChannelNaxaLibre();

  /// The default instance of [NaxaLibrePlatform] to use.
  ///
  /// Defaults to [MethodChannelNaxaLibre].
  static NaxaLibrePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NaxaLibrePlatform] when
  /// they register themselves.
  static set instance(NaxaLibrePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    bool hyperComposition = false,
  });
}
