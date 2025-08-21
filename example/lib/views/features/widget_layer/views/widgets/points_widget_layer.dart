import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:naxalibre/naxalibre.dart' hide Feature, GeoJson;

import '../../handlers/clustering_handler.dart';
import '../../handlers/visible_features_handler.dart';
import '../../models/geojson.dart';

/// MapLibre Points Widget Layer
/// [PointsWidgetLayer] is a widget layer that renders points as a flutter
/// widget on the map
///
/// [geoJson] is the geojson data to be rendered
/// [cluster] is a boolean flag to enable clustering of points
/// [clusterRadius] is the range in which points are clustered
/// [enableAnimation] is a boolean flag to enable animation of points
/// [controllerBuilder] is a function that returns a [NaxaLibreController]
/// [pointBuilder] is a function that returns a widget to be rendered on the map
/// for each point feature
/// [clusterPointBuilder] is a function that returns a widget to be rendered on the map
/// for each clustered point feature
/// [animationDuration] is the duration of the animation
///
class PointsWidgetLayer extends StatefulWidget {
  const PointsWidgetLayer({
    super.key,
    this.geoJson,
    this.cluster = true,
    this.clusterRadius = 15.0,
    this.enableAnimation = true,
    required this.controllerBuilder,
    required this.pointBuilder,
    this.clusterPointBuilder,
    this.animationDuration = const Duration(milliseconds: 50),
  });

  final GeoJson? geoJson;
  final bool cluster;
  final double clusterRadius;
  final bool enableAnimation;
  final NaxaLibreController? Function() controllerBuilder;
  final Widget Function(Feature) pointBuilder;
  final Widget Function(Feature)? clusterPointBuilder;
  final Duration animationDuration;

  @override
  State<PointsWidgetLayer> createState() => _PointsWidgetLayerState();
}

class _PointsWidgetLayerState extends State<PointsWidgetLayer> {
  /// List of visible features
  /// Initially it will be empty
  final _visibleFeatures = ValueNotifier<List<Feature>>([]);

  /// Flag to check if the listener is added or not
  /// Initially it will be false
  bool _isListenerAdded = false;

  /// Controller of the map
  /// It will be provided by [widget.controllerBuilder]
  /// and might be null until the map is loaded
  NaxaLibreController? get _libreController => widget.controllerBuilder();

  /// Init State method
  @override
  void initState() {
    super.initState();
    _tryAttachMapListener();
  }

  /// Did Update Widget method
  /// Here we are comparing dependencies and react accordingly
  @override
  void didUpdateWidget(covariant PointsWidgetLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.geoJson != widget.geoJson ||
        oldWidget.controllerBuilder() != widget.controllerBuilder()) {
      _handleOnMapMove();
    }
  }

  /// Method to try attaching the listener to the map
  /// Since the listener is added to the map after the map is loaded
  /// we need to wait for the map to be loaded
  Future<void> _tryAttachMapListener() async {
    final controller = await _waitForController();
    if (!_isListenerAdded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.addOnCameraMoveListener(_listener);
        _isListenerAdded = true;
      });
    }
    _handleOnMapMove();
  }

  /// Method to wait for the map to be loaded
  /// Since the listener is added to the map after the map is loaded
  /// we need to wait for the map to be loaded
  Future<NaxaLibreController> _waitForController() async {
    while (_libreController == null) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return _libreController!;
  }

  /// Method to handle the listener
  void _listener(CameraMoveEvent _, CameraMoveReason? _) => _handleOnMapMove();

  /// Method to handle the on map move event and update the visible features
  /// accordingly.
  /// Here we are using the [VisibleFeaturesHandler] to filter the visible features
  /// and then using the [ClusteringHandler] to cluster the features if [widget.cluster]
  /// is true
  Future<void> _handleOnMapMove() async {
    final geoJson = widget.geoJson;
    final controller = _libreController;
    if (geoJson == null || controller == null) return;

    final bounds = await controller.getVisibleRegion(true);

    if (bounds == null) {
      _visibleFeatures.value = [];
      return;
    }

    final visibleFeatures = VisibleFeaturesHandler.filter(
      geoJson,
      bounds.latLngBounds,
    );

    if (visibleFeatures.isEmpty) {
      _visibleFeatures.value = [];
      return;
    }

    final points = await controller.toScreenLocations(
      visibleFeatures
          .map(
            (e) => LatLng(
              e.geometry!.coordinates.last,
              e.geometry!.coordinates.first,
            ),
          )
          .toList(),
    );

    if (points == null || points.length != visibleFeatures.length) {
      _visibleFeatures.value = [];
      return;
    }

    // It only need for android, in iOS it will be 1.0
    final scale = mounted && Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;

    final updated =
        points.indexed
            .map(
              (p) => visibleFeatures[p.$1].copy(
                offset: Offset(p.$2.x / scale, p.$2.y / scale),
              ),
            )
            .toList();

    final clustered =
        widget.cluster
            ? ClusteringHandler.cluster(updated, radius: widget.clusterRadius)
            : updated;

    _visibleFeatures.value = clustered;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Feature>>(
      valueListenable: _visibleFeatures,
      builder: (_, features, __) {
        if (features.isEmpty) return const SizedBox();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child:
              features.isEmpty
                  ? const SizedBox()
                  : _PassthroughPointer(
                    child: Stack(
                      children:
                          features
                              .where((f) => f.offset != null)
                              .map(
                                (f) => _PositionedFeatureWidget(
                                  feature: f,
                                  enableAnimation: widget.enableAnimation,
                                  builder:
                                      f.isCluster
                                          ? widget.clusterPointBuilder ??
                                              widget.pointBuilder
                                          : widget.pointBuilder,
                                  isClusterBuilderProvided:
                                      widget.clusterPointBuilder != null,
                                  duration: widget.animationDuration,
                                ),
                              )
                              .toList(),
                    ),
                  ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isListenerAdded) {
      _libreController?.removeOnCameraMoveListener(_listener);
    }
    _visibleFeatures.dispose();
    super.dispose();
  }
}

/// Widget to position the feature widget
/// [_PositionedFeatureWidget] is used to position the feature widget
///
class _PositionedFeatureWidget extends StatefulWidget {
  const _PositionedFeatureWidget({
    required this.feature,
    required this.builder,
    this.enableAnimation = true,
    this.isClusterBuilderProvided = false,
    required this.duration,
  });

  final Feature feature;
  final Widget Function(Feature) builder;
  final bool enableAnimation;
  final bool isClusterBuilderProvided;
  final Duration duration;

  @override
  State<_PositionedFeatureWidget> createState() =>
      _PositionedFeatureWidgetState();
}

class _PositionedFeatureWidgetState extends State<_PositionedFeatureWidget> {
  /// Default values if not measured
  Size _childSize = const Size(24.0, 24.0);

  /// Method to notify the size of the child widget
  void _onSizeChange(Size newSize) {
    setState(() {
      _childSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final feature = widget.feature;
    final dx = widget.feature.offset!.dx - _childSize.width / 2;
    final dy = widget.feature.offset!.dy - _childSize.height / 2;

    final child = _SizeReportingWidget(
      onSizeChange: _onSizeChange,
      child: RepaintBoundary(child: widget.builder(feature)),
    );

    return widget.enableAnimation
        ? AnimatedPositioned(
          duration: widget.duration,
          left: dx,
          top: dy,
          child:
              feature.isCluster && !widget.isClusterBuilderProvided
                  ? _DefaultClusterWidget(feature: feature)
                  : child,
        )
        : Positioned(left: dx, top: dy, child: child);
  }
}

/// Widget to measure the size of the child widget
/// [_SizeReportingWidget] notifies the parent widget about the size change
///
class _SizeReportingWidget extends StatefulWidget {
  const _SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  final Widget child;
  final void Function(Size size) onSizeChange;

  @override
  State<_SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  final _key = GlobalKey();
  Size? _oldSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_notifySize);
  }

  @override
  void didUpdateWidget(covariant _SizeReportingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_notifySize);
  }

  void _notifySize(Duration _) {
    try {
      if (!mounted) return;

      final context = _key.currentContext;
      if (context == null) return;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final newSize = renderBox.size;

      if (newSize != _oldSize) {
        _oldSize = newSize;
        widget.onSizeChange(newSize);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(key: _key, child: widget.child);
  }
}

/// Default cluster widget [_DefaultClusterWidget]
/// [_DefaultClusterWidget] is used when the cluster builder is not provided
///
class _DefaultClusterWidget extends StatelessWidget {
  const _DefaultClusterWidget({required this.feature});

  final Feature feature;

  @override
  Widget build(BuildContext context) {
    final defaultSize = 28.0;
    final size =
        defaultSize + ((feature.clusteredFeatures?.length ?? 1) * 0.075);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(size),
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: Center(
        child: Text(
          feature.clusteredFeatures?.length.toString() ?? '',
          style: TextTheme.of(context).bodySmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

/// Use the [_PassthroughPointer] to allow the [child] widget to receive gestures
/// as well as the widgets behind.
class _PassthroughPointer extends SingleChildRenderObjectWidget {
  const _PassthroughPointer({required super.child, super.key});

  @override
  RenderProxyBox createRenderObject(BuildContext context) =>
      _PassthroughPointerRender();
}

class _PassthroughPointerRender extends RenderProxyBox {
  _PassthroughPointerRender() : super(null);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Let the child receive gestures
    child?.hitTest(BoxHitTestResult.wrap(result), position: position);

    // Don't consume the hit; allow widgets behind to receive it
    return false;
  }
}
