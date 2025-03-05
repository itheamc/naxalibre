import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naxalibre/naxalibre.dart';

import '../base_map/base_map_screen.dart';
import 'widgets/layer_button.dart';

// 3. Layer Management Screen
class LayerManagementScreen extends BaseMapScreen {
  const LayerManagementScreen({super.key}) : super(title: 'Layer Management');

  @override
  State<LayerManagementScreen> createState() => _LayerManagementScreenState();
}

class _LayerManagementScreenState
    extends BaseMapScreenState<LayerManagementScreen> {
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
              LayerButton(
                label: "Add Circle Layer",
                onPressed: () => _addCircleLayer(),
              ),
              LayerButton(
                label: "Add Line Layer",
                onPressed: () => _addLineLayer(),
              ),
              LayerButton(
                label: "Add Fill Layer",
                onPressed: () => _addFillLayer(),
              ),
              LayerButton(
                label: "Add Point From Feature",
                onPressed: () => _addPointLayerFromFeature(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addCircleLayer() async {
    await controller?.addSource<GeoJsonSource>(
      source: GeoJsonSource(
        sourceId: "sourceId",
        url:
            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_populated_places.geojson",
        sourceProperties: GeoJsonSourceProperties(cluster: true),
      ),
    );

    await controller?.addStyleImage(
      image: NetworkStyleImage(
        imageId: 'test_icon',
        url:
            'https://www.pngplay.com/wp-content/uploads/9/Map-Marker-PNG-Pic-Background.png',
      ),
    );

    await controller?.addLayer<CircleLayer>(
      layer: CircleLayer(
        layerId: "layerId",
        sourceId: "sourceId",
        layerProperties: CircleLayerProperties(
          circleColor: [
            'case',
            [
              '!',
              ['has', 'point_count'],
            ],
            'blue',
            'red',
          ],
          circleRadius: [
            'case',
            [
              '!',
              ['has', 'point_count'],
            ],
            12,
            14,
          ],
          circleRadiusTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
          circleColorTransition: StyleTransition.build(
            delay: 1500,
            duration: const Duration(milliseconds: 2000),
          ),
          circleStrokeWidth: 2.0,
          circleStrokeColor: "white",
        ),
      ),
    );

    await controller?.addLayer<SymbolLayer>(
      layer: SymbolLayer(
        layerId: "symbolLayerId",
        sourceId: "sourceId",
        layerProperties: SymbolLayerProperties(
          textColor: "yellow",
          textField: ['get', 'point_count_abbreviated'],
          textSize: 10,
          iconImage: [
            'case',
            [
              '!',
              ['has', 'point_count'],
            ],
            'test_icon',
            '',
          ],
          iconSize: Platform.isIOS ? 0.035 : 0.075,
          iconColor: "#fff",
        ),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Circle layer added')));
  }

  Future<void> _addPointLayerFromFeature() async {
    await controller?.addSource<GeoJsonSource>(
      source: GeoJsonSource(
        sourceId: "singleFeatureSourceId",
        geoJson: GeoJson.fromFeature(
          Feature.fromGeometry(
            Geometry.point(coordinates: [85.331033, 27.741712]),
            id: "1",
            properties: {"name": "Amit"},
          ),
        ),
        sourceProperties: GeoJsonSourceProperties(cluster: false),
      ),
    );

    await controller?.addLayer<CircleLayer>(
      layer: CircleLayer(
        layerId: "singleFeatureLayerId",
        sourceId: "singleFeatureSourceId",
        layerProperties: CircleLayerProperties(
          circleColor: 'yellow',
          circleStrokeWidth: 2.0,
          circleStrokeColor: "white",
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Point added')));
  }

  Future<void> _addLineLayer() async {
    if ((await controller?.isLayerExist('lineLayerId')) == true) {
      await controller?.removeLayer('lineLayerId');
    }

    if ((await controller?.isSourceExist('lineSourceId')) == true) {
      await controller?.removeSource('lineSourceId');
    }

    await controller?.addSource<GeoJsonSource>(
      source: GeoJsonSource(
        sourceId: "lineSourceId",
        url:
            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_rivers_europe.geojson",
      ),
    );

    await controller?.addLayerBelow<LineLayer>(
      layer: LineLayer(
        layerId: "lineLayerId",
        sourceId: "lineSourceId",
        layerProperties: LineLayerProperties(
          lineColor: "red",
          lineWidth: 2,
          lineGradient: [
            'interpolate',
            ['linear'],
            ['line-progress'],
            0,
            'blue',
            0.1,
            'royalblue',
            0.3,
            'cyan',
            0.5,
            'lime',
            0.7,
            'yellow',
            1,
            'red',
          ],
        ),
      ),
      below: "fillLayerId",
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Line layer added')));
  }

  Future<void> _addFillLayer() async {
    if ((await controller?.isLayerExist('fillLayerId')) == true) {
      await controller?.removeLayer('fillLayerId');
    }

    if ((await controller?.isSourceExist('fillSourceId')) == true) {
      await controller?.removeSource('fillSourceId');
    }

    await controller?.addSource<GeoJsonSource>(
      source: GeoJsonSource(
        sourceId: "fillSourceId",
        url:
            "https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_map_subunits.geojson",
      ),
    );

    await controller?.addLayer<FillLayer>(
      layer: FillLayer(
        layerId: "fillLayerId",
        sourceId: "fillSourceId",
        layerProperties: FillLayerProperties(
          fillColor: "red",
          fillOpacity: 0.15,
          fillOutlineColor: "red",
        ),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fill layer added')));
  }
}
