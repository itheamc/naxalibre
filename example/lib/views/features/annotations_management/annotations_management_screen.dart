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
    await controller?.animateCamera(
      CameraUpdateFactory.newCameraPosition(CameraPosition(
          target: LatLng(27.741712, 85.331033),
          zoom: 15
      )),
    );

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
          data: {
            "name": "Circle Annotation",
            "description": "This is a circle annotation",
            "taskId": 11,
          },
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Circle annotation added')));
  }

  Future<void> _addPolylineAnnotation() async {
    await controller?.animateCamera(
      CameraUpdateFactory.newCameraPosition(CameraPosition(
        target: LatLng(27.741712, 85.331033),
        zoom: 15
      )),
    );

    await controller?.addAnnotation<PolylineAnnotation>(
      annotation: PolylineAnnotation(
        options: PolylineAnnotationOptions(
          points: [LatLng(27.741712, 85.331033), LatLng(27.7420, 85.3412)],
          lineColor: "red",
          lineWidth: 3.75,
          lineCap: LineCap.round,
          lineJoin: LineJoin.round,
          draggable: true,
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
          draggable: true,
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
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Point annotation added')));
  }

  Future<void> _updateCircleAnnotation(int id) async {
    await controller?.updateAnnotation<CircleAnnotation>(
      id: id,
      annotation: CircleAnnotation(
        options: CircleAnnotationOptions(
          point: LatLng(27.751712, 85.341033),
          circleColor: "green",
          circleStrokeColor: "yellow",
          circleStrokeWidth: 2.25,
          circleRadius: 14.0,
          circleRadiusTransition: StyleTransition.build(
            delay: 500,
            duration: const Duration(milliseconds: 3000),
          ),
          circleColorTransition: StyleTransition.build(
            delay: 500,
            duration: const Duration(milliseconds: 2000),
          ),
          data: {
            "name": "Circle Annotation",
            "description": "This is a circle annotation updated",
          },
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Circle annotation updated')));
  }

  Future<void> _updatePolygonAnnotation(int id) async {
    await controller?.updateAnnotation<PolygonAnnotation>(
      id: id,
      annotation: PolygonAnnotation(
        options: PolygonAnnotationOptions(
          points: [
            [
              LatLng(27.741712, 85.331033),
              LatLng(27.7420, 85.3412),
              LatLng(27.7525, 85.3578),
            ],
          ],
          fillColor: "blue",
          fillOpacity: 0.25,
          fillOutlineColor: "red",
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Polygon annotation updated')));
  }

  Future<void> _updatePolylineAnnotation(int id) async {
    await controller?.updateAnnotation<PolylineAnnotation>(
      id: id,
      annotation: PolylineAnnotation(
        options: PolylineAnnotationOptions(
          points: [LatLng(27.741712, 85.331033), LatLng(27.7420, 85.3412)],
          lineColor: "yellow",
          lineWidth: 5,
          lineCap: LineCap.round,
          lineJoin: LineJoin.round,
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Polyline annotation updated')));
  }

  Future<void> _updatePointAnnotation(int id) async {
    await controller?.updateAnnotation<PointAnnotation>(
      id: id,
      annotation: PointAnnotation(
        image: NetworkStyleImage(
          imageId: "pointImageId",
          url:
          "https://www.cp-desk.com/wp-content/uploads/2019/02/map-marker-free-download-png.png",
        ),
        options: PointAnnotationOptions(
          point: LatLng(27.7525, 85.3578),
          iconSize: 0.05,
          draggable: true,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Point annotation updated')));
  }

  @override
  void onControllerReady(NaxaLibreController? controller) {
    super.onControllerReady(controller);

    // Click listener
    controller?.addOnAnnotationClickListener((annotation) {
      debugPrint("[Clicked] $annotation");
      if (annotation["type"] == "Circle") {
        _updateCircleAnnotation(annotation["id"] as int);
      } else if (annotation["type"] == "Polygon") {
        _updatePolygonAnnotation(annotation["id"] as int);
      } else if (annotation["type"] == "Polyline") {
        _updatePolylineAnnotation(annotation["id"] as int);
      } else if (annotation["type"] == "Symbol") {
        _updatePointAnnotation(annotation["id"] as int);
      }
    });

    // Long click listener
    controller?.addOnAnnotationLongClickListener((annotation) {
      debugPrint("[LongClicked] $annotation");
    });

    // Drag listener
    controller?.addOnAnnotationDragListener((
      id,
      type,
      annotation,
      updated,
      event,
    ) {
      debugPrint("[$type][Drag($id)][${event.name}] $annotation, $updated");
    });
  }

  @override
  void dispose() {
    controller?.clearOnAnnotationClickListeners();
    controller?.clearOnAnnotationLongClickListeners();
    super.dispose();
  }
}
