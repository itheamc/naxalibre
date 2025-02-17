import 'package:flutter/foundation.dart';

import '../../naxalibre.dart';
import '../enums/enums.dart';

/// Typedef for handling onMapCreated callback
/// [NaxaLibreController] Instance of the NaxaLibreController
///
typedef OnMapCreated = void Function(NaxaLibreController);

/// Typedef for handling onMapLoaded callback
///
typedef OnMapLoaded = VoidCallback;

/// Typedef for handling OnMapRendered callback
///
typedef OnMapRendered = VoidCallback;

/// Method to handle onStyleLoaded callback
///
typedef OnStyleLoaded = VoidCallback;

/// Typedef for handling onMapClick callback
/// [LatLng] - It consists the latitude and longitude of the clicked feature
///
typedef OnMapClick = void Function(LatLng);

/// Typedef for handling onMapLongClick callback
/// [LatLng] - It consists the latitude and longitude of the clicked feature
///
typedef OnMapLongClick = void Function(LatLng);

/// Typedef for handling onFpsChanged callback
/// [double] - It consists the current fps
///
typedef OnFpsChanged = void Function(double fps);

/// Typedef for handling onCameraIdle callback
///
typedef OnCameraIdle = VoidCallback;

/// Typedef for handling onCameraMoveStarted callback
///
typedef OnCameraMoveStarted = void Function(CameraMoveReason reason);

/// Typedef for handling onCameraMove callback
///
typedef OnCameraMove = VoidCallback;

/// Typedef for handling onCameraMoveEnd callback
///
typedef OnCameraMoveEnd = VoidCallback;

/// Typedef for handling onFling
///
typedef OnFling = VoidCallback;

/// Typedef for handling OnRotateStarted callback
///
typedef OnRotateStarted = void Function(
  double angleThreshold,
  double deltaSinceStart,
  double deltaSinceLast,
);

/// Typedef for handling onRotate callback
///
typedef OnRotate = void Function(
  double angleThreshold,
  double deltaSinceStart,
  double deltaSinceLast,
);

/// Typedef for handling OnRotateEnd callback
///
typedef OnRotateEnd = void Function(
  double angleThreshold,
  double deltaSinceStart,
  double deltaSinceLast,
);
