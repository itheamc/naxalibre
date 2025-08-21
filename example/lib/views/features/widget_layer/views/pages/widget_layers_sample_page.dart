import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naxalibre/naxalibre.dart' hide GeoJson;
import 'package:naxalibre_example/views/features/widget_layer/models/dymmy_geojson.dart';
import '../../models/geojson.dart';
import '../widgets/points_widget_layer.dart';

class WidgetLayersSamplePage extends StatefulWidget {
  const WidgetLayersSamplePage({super.key});

  @override
  State<WidgetLayersSamplePage> createState() => _WidgetLayersSamplePageState();
}

class _WidgetLayersSamplePageState extends State<WidgetLayersSamplePage> {
  NaxaLibreController? _libreController;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            NaxaLibreMap(
              mapOptions: NaxaLibreMapOptions(
                position: CameraPosition(
                  target: LatLng(27.6933192, 85.3474295),
                ),
              ),
              onMapCreated: (controller) {
                _libreController = controller;
              },
            ),
            PointsWidgetLayer(
              geoJson: GeoJson.fromJson(dummyGeoJson),
              cluster: true,
              clusterRadius: 20,
              enableAnimation: false,
              controllerBuilder: () => _libreController,
              pointBuilder:
                  (feature) => GestureDetector(
                    onTap: () {
                      debugPrint("Clicked \n ${feature.toJson()}");
                    },
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              clusterPointBuilder: (feature) {
                final defaultSize = 28.0;
                final size =
                    defaultSize +
                    ((feature.clusteredFeatures?.length ?? 1) * 0.075);

                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(size),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: Center(
                    child: Text(
                      feature.clusteredFeatures?.length.toString() ?? '',
                      style: TextTheme.of(
                        context,
                      ).bodySmall?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class TooltipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double pointerHeight = 10.0; // Height of the triangular pointer
    final double pointerWidth = 20.0; // Width of the triangular pointer
    final double cornerRadius = 10.0; // Corner radius for rounded rectangle

    // Start at the top-left corner
    path.moveTo(cornerRadius, 0);

    // Top edge
    path.lineTo(width - cornerRadius, 0);

    // Top-right corner
    path.quadraticBezierTo(width, 0, width, cornerRadius);

    // Right edge
    path.lineTo(width, height - cornerRadius - pointerHeight);

    // Bottom-right corner
    path.quadraticBezierTo(
        width, height - pointerHeight, width - cornerRadius, height - pointerHeight);

    // Bottom edge to the right of the pointer
    path.lineTo(width / 2 + pointerWidth / 2, height - pointerHeight);

    // Right side of the pointer
    path.lineTo(width / 2, height);

    // Left side of the pointer
    path.lineTo(width / 2 - pointerWidth / 2, height - pointerHeight);

    // Bottom edge to the left of the pointer
    path.lineTo(cornerRadius, height - pointerHeight);

    // Bottom-left corner
    path.quadraticBezierTo(0, height - pointerHeight, 0, height - pointerHeight - cornerRadius);

    // Left edge
    path.lineTo(0, cornerRadius);

    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}