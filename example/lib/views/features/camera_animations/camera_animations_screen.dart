import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/animation_button.dart';

// 2. Camera Animations Screen
class CameraAnimationsScreen extends BaseMapScreen {
  const CameraAnimationsScreen({super.key}) : super(title: 'Camera Animations');

  @override
  State<CameraAnimationsScreen> createState() => _CameraAnimationsScreenState();
}

class _CameraAnimationsScreenState
    extends BaseMapScreenState<CameraAnimationsScreen> {
  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        Positioned(
          right: 16,
          top: MediaQuery.of(context).padding.top + 75,
          bottom: 16,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimationButton(
                  label: "To New LatLng",
                  icon: Icons.place,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.newLatLng(const LatLng(27.34, 85.73)),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "To Camera Position",
                  icon: Icons.camera,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.newCameraPosition(
                        const CameraPosition(
                          target: LatLng(27.38, 85.75),
                          zoom: 16,
                          bearing: 0,
                          tilt: 0,
                        ),
                      ),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "To LatLng Bounds",
                  icon: Icons.crop_free,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.newLatLngBounds(
                        const LatLngBounds(
                          southwest: LatLng(27.34, 85.73),
                          northeast: LatLng(27.35, 85.74),
                        ),
                        tilt: 5,
                        padding: EdgeInsets.all(50),
                        bearing: 90,
                      ),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "Animate To Current Location",
                  icon: Icons.remove_circle_outline,
                  onPressed: () {
                    controller?.animateCameraToCurrentLocation(
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "Zoom To 10",
                  icon: Icons.zoom_in,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.zoomTo(10),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "Zoom By +2",
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.zoomBy(2),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
                AnimationButton(
                  label: "Zoom By -2",
                  icon: Icons.remove_circle_outline,
                  onPressed: () {
                    controller?.animateCamera(
                      CameraUpdateFactory.zoomBy(-2),
                      duration: const Duration(milliseconds: 5000),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
