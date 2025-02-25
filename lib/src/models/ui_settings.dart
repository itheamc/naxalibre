import 'dart:math';
import 'package:flutter/widgets.dart';

import '../enums/enums.dart';

/// `UiSettings` is a class that configures the UI elements and interactive
/// behaviors of the NaxaLibre map view.
///
/// It allows customization of various features such as the visibility of
/// the Maplibre logo, compass, and attribution, as well as gesture controls.
///
class UiSettings {
  /// Whether the Mapbox logo is displayed on the map.
  final bool logoEnabled;

  /// Whether the compass is displayed on the map.
  final bool compassEnabled;

  /// Whether the attribution is displayed on the map.
  final bool attributionEnabled;

  /// The gravity of the attribution.
  final Gravity? attributionGravity;

  /// The gravity of the compass.
  final Gravity? compassGravity;

  /// The gravity of the logo.
  final Gravity? logoGravity;

  /// Margins for the logo.
  final EdgeInsets? logoMargins;

  /// Margins for the compass.
  final EdgeInsets? compassMargins;

  /// Margins for the attribution.
  final EdgeInsets? attributionMargins;

  /// Whether rotate gestures are enabled.
  final bool rotateGesturesEnabled;

  /// Whether tilt gestures are enabled.
  final bool tiltGesturesEnabled;

  /// Whether zoom gestures are enabled.
  final bool zoomGesturesEnabled;

  /// Whether scroll gestures are enabled.
  final bool scrollGesturesEnabled;

  /// Whether horizontal scroll gestures are enabled.
  final bool horizontalScrollGesturesEnabled;

  /// Whether double tap gestures are enabled.
  final bool doubleTapGesturesEnabled;

  /// Whether quick zoom gestures are enabled.
  final bool quickZoomGesturesEnabled;

  /// Whether the scale velocity animation is enabled.
  final bool scaleVelocityAnimationEnabled;

  /// Whether the rotate velocity animation is enabled.
  final bool rotateVelocityAnimationEnabled;

  /// Whether the fling velocity animation is enabled.
  final bool flingVelocityAnimationEnabled;

  /// Whether to increase the rotate threshold when scaling.
  final bool increaseRotateThresholdWhenScaling;

  /// Whether to disable rotation when scaling.
  final bool disableRotateWhenScaling;

  /// Whether to increase the scale threshold when rotating.
  final bool increaseScaleThresholdWhenRotating;

  /// Whether to fade the compass when facing north.
  final bool fadeCompassWhenFacingNorth;

  /// The focal point of the map.
  final Point<double>? focalPoint;

  /// The threshold for a fling gesture.
  final int flingThreshold;

  /// The map of attributions to be shown while clicking on the attribution icon
  /// Key - Name of attribution/Title of attribution
  /// Value - Associated website url
  ///
  final Map<String, String> attributions;

  const UiSettings({
    this.logoEnabled = true,
    this.compassEnabled = true,
    this.attributionEnabled = true,
    this.attributionGravity,
    this.compassGravity,
    this.logoGravity,
    this.logoMargins,
    this.compassMargins,
    this.attributionMargins,
    this.rotateGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.horizontalScrollGesturesEnabled = true,
    this.doubleTapGesturesEnabled = true,
    this.quickZoomGesturesEnabled = true,
    this.scaleVelocityAnimationEnabled = true,
    this.rotateVelocityAnimationEnabled = true,
    this.flingVelocityAnimationEnabled = true,
    this.increaseRotateThresholdWhenScaling = true,
    this.disableRotateWhenScaling = true,
    this.increaseScaleThresholdWhenRotating = true,
    this.fadeCompassWhenFacingNorth = true,
    this.focalPoint,
    this.flingThreshold = 1000,
    this.attributions = const {
      "NAXA": "https://naxa.com.np",
      "@itheamc": "https://github.com/itheamc",
    },
  });

  /// Converts the [UiSettings] instance into a map of arguments suitable for
  /// passing to native platform code.
  ///
  /// This method processes various properties of the [UiSettings] object,
  /// such as margins and focal points, and formats them into a map that can
  /// be easily understood by the native platform.
  Map<String, dynamic> toArgs() {
    List<double>? marginAsList(EdgeInsets? margin) {
      return margin != null
          ? [margin.left, margin.top, margin.right, margin.bottom]
          : null;
    }

    return {
      'logoEnabled': logoEnabled,
      'compassEnabled': compassEnabled,
      'attributionEnabled': attributionEnabled,
      'attributionGravity': attributionGravity?.name,
      'compassGravity': compassGravity?.name,
      'logoGravity': logoGravity?.name,
      'logoMargins': marginAsList(logoMargins),
      'compassMargins': marginAsList(compassMargins),
      'attributionMargins': marginAsList(attributionMargins),
      'rotateGesturesEnabled': rotateGesturesEnabled,
      'tiltGesturesEnabled': tiltGesturesEnabled,
      'zoomGesturesEnabled': zoomGesturesEnabled,
      'scrollGesturesEnabled': scrollGesturesEnabled,
      'horizontalScrollGesturesEnabled': horizontalScrollGesturesEnabled,
      'doubleTapGesturesEnabled': doubleTapGesturesEnabled,
      'quickZoomGesturesEnabled': quickZoomGesturesEnabled,
      'scaleVelocityAnimationEnabled': scaleVelocityAnimationEnabled,
      'rotateVelocityAnimationEnabled': rotateVelocityAnimationEnabled,
      'flingVelocityAnimationEnabled': flingVelocityAnimationEnabled,
      'increaseRotateThresholdWhenScaling': increaseRotateThresholdWhenScaling,
      'disableRotateWhenScaling': disableRotateWhenScaling,
      'increaseScaleThresholdWhenRotating': increaseScaleThresholdWhenRotating,
      'fadeCompassWhenFacingNorth': fadeCompassWhenFacingNorth,
      'focalPoint': focalPoint != null ? [focalPoint!.x, focalPoint!.y] : null,
      'flingThreshold': flingThreshold,
      'attributions': attributions,
    };
  }
}
