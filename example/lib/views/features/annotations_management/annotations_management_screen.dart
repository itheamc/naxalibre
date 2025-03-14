import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/annotation_button.dart';

// 7. Annotations Management Screen
class AnnotationsManagementScreen extends BaseMapScreen {
  const AnnotationsManagementScreen({super.key})
    : super(title: 'Annotation Management');

  @override
  State<AnnotationsManagementScreen> createState() =>
      _LayerManagementScreenState();
}

class _LayerManagementScreenState
    extends BaseMapScreenState<AnnotationsManagementScreen> {
  @override
  Widget buildMapWithControls() {
    return Stack(
      children: [
        buildBaseMap(),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnnotationButton(
                label: "Add Circle Annotation",
                icon: Icons.circle,
                onPressed: () => _addCircleAnnotation(),
              ),
              AnnotationButton(
                label: "Add Polyline Annotation",
                icon: Icons.polyline,
                onPressed: () => _addPolylineAnnotation(),
              ),
              AnnotationButton(
                label: "Add Polygon Annotation",
                icon: Icons.hexagon_outlined,
                onPressed: () => _addPolygonAnnotation(),
              ),
              AnnotationButton(
                label: "Add Point Annotation",
                icon: Icons.location_on_rounded,
                onPressed: () => _addPointAnnotation(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addCircleAnnotation() async {
    await controller?.addAnnotation<CircleAnnotation>(
      annotation: CircleAnnotation(
        options: CircleAnnotationOptions(
          point: LatLng(27.741712, 85.331033),
          circleColor: "red",
          circleStrokeColor: "white",
          circleStrokeWidth: 2.0,
          circleRadius: 12.0,
          circleRadiusTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
          circleColorTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Circle annotation added')));
  }

  Future<void> _addPolylineAnnotation() async {
    await controller?.addAnnotation<PolylineAnnotation>(
      annotation: PolylineAnnotation(
        options: PolylineAnnotationOptions(
          points: [LatLng(27.741712, 85.331033), LatLng(27.7420, 85.3412)],
          lineColor: "red",
          lineWidth: 3.75,
          lineCap: LineCap.round,
          lineJoin: LineJoin.round,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Polyline annotation added')));
  }

  Future<void> _addPolygonAnnotation() async {
    await controller?.addAnnotation<PolygonAnnotation>(
      annotation: PolygonAnnotation(
        options: PolygonAnnotationOptions(
          points: [
            [
              LatLng(27.741712, 85.331033),
              LatLng(27.7420, 85.3412),
              LatLng(27.7525, 85.3578),
            ],
          ],
          fillColor: "red",
          fillOpacity: 0.15,
          fillOutlineColor: "blue",
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Polygon annotation added')));
  }

  Future<void> _addPointAnnotation() async {
    await controller?.addAnnotation<PointAnnotation>(
      annotation: PointAnnotation(
        image: NetworkStyleImage(
          imageId: "pointImageId",
          url:
              "https://www.cp-desk.com/wp-content/uploads/2019/02/map-marker-free-download-png.png",
        ),
        options: PointAnnotationOptions(
          point: LatLng(27.7525, 85.3578),
          iconSize: 0.1,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Point annotation added')));
  }
}
