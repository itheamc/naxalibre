import 'package:flutter/src/widgets/framework.dart';
import 'package:naxalibre/src/enums/enums.dart';
import 'package:naxalibre/src/naxalibre_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNaxalibrePlatform
    with MockPlatformInterfaceMixin
    implements NaxaLibrePlatform {
  @override
  Widget buildMapView({
    required Map<String, dynamic> creationParams,
    void Function(int id)? onPlatformViewCreated,
    HyperCompositionMode hyperCompositionMode = HyperCompositionMode.disabled,
  }) {
    // TODO: implement buildMapView
    throw UnimplementedError();
  }
}

void main() {}
