/// Represents different camera modes for a mapping application.
///
/// The [CameraMode] enum defines various modes that a camera can be in,
/// such as no tracking, GPS tracking, and compass tracking.
///
/// Each mode is associated with a unique integer value.
enum CameraMode {
  /// No camera tracking.
  none(8),

  /// No camera tracking, but does track compass bearing
  noneCompass(16),

  /// No camera tracking, but does track GPS bearing
  noneGps(22),

  /// The camera follows the user's movement.
  tracking(24),

  /// Camera tracks the user location, with bearing provided by a compass
  trackingCompass(32),

  /// The camera follows the user's GPS location.
  trackingGps(34),

  /// The camera follows the user's GPS location and remains oriented to the north.
  trackingGpsNorth(36);

  /// The integer value associated with the camera mode.
  final int value;

  /// Creates a [CameraMode] with the specified [value].
  const CameraMode(this.value);

  /// Retrieves the corresponding [CameraMode] from an integer [value].
  ///
  /// Throws an [ArgumentError] if the value does not match any defined mode.
  static CameraMode fromValue(int value) {
    return CameraMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CameraMode.none,
    );
  }
}

/// Defines different rendering modes for a mapping application.
///
/// The [RenderMode] enum represents various ways in which the camera or map
/// rendering can be adjusted based on user interaction or tracking settings.
enum RenderMode {
  /// Normal rendering mode without additional tracking features.
  normal(18),

  /// Rendering mode that aligns with the compass direction.
  compass(4),

  /// Rendering mode that follows the user's GPS location.
  gps(8);

  /// The integer value associated with the render mode.
  final int value;

  /// Creates a [RenderMode] with the specified [value].
  const RenderMode(this.value);

  /// Retrieves the corresponding [RenderMode] from an integer [value].
  ///
  /// Throws an [ArgumentError] if the value does not match any defined mode.
  static RenderMode fromValue(int value) {
    return RenderMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RenderMode.normal,
    );
  }
}

/// Enum to represent the reason for a camera movement on the map.
///
/// The `CameraMoveReason` enum is used to specify the cause behind a change in the camera position or viewport.
/// It helps differentiate between user-driven actions and programmatically triggered movements.
///
/// Enum values:
/// - [unknown] - The reason for the camera movement is unknown (default).
/// - [apiGesture] - The camera movement is caused by a gesture (like pinch-to-zoom or drag) by the user.
/// - [developerAnimation] - The camera movement is triggered by an animation set by the developer.
/// - [apiAnimation] - The camera movement is caused by an animation triggered via the API.
enum CameraMoveReason {
  /// The camera move reason is unknown.
  unknown(0),

  /// The camera move is caused by a user gesture (e.g., drag, pinch-to-zoom).
  apiGesture(1),

  /// The camera move is caused by an animation triggered by the developer.
  developerAnimation(2),

  /// The camera move is caused by an animation from the API (programmatic).
  apiAnimation(3);

  /// The unique code associated with each camera move reason.
  final int code;

  /// Constructor to assign a code to each CameraMoveReason.
  const CameraMoveReason(this.code);

  /// Factory method to create a CameraMoveReason from its corresponding code.
  ///
  /// [code] is the integer value associated with a particular CameraMoveReason.
  /// The method will return the appropriate CameraMoveReason based on the code:
  /// - 1: [apiGesture]
  /// - 2: [developerAnimation]
  /// - 3: [apiAnimation]
  /// - Any other code: [unknown]
  factory CameraMoveReason.fromCode(int? code) {
    return switch (code) {
      1 => CameraMoveReason.apiGesture,
      2 => CameraMoveReason.developerAnimation,
      3 => CameraMoveReason.apiAnimation,
      _ => CameraMoveReason.unknown,
    };
  }
}

/// Represents gravity constants used for positioning or alignment.
/// Each value corresponds to a specific gravity constant with an associated integer value.
///
enum Gravity {
  /// Clip along the axis.
  axisClip(8),

  /// Pull after the axis.
  axisPullAfter(4),

  /// Pull before the axis.
  axisPullBefore(2),

  /// Specified axis.
  axisSpecified(1),

  /// Shift along the X-axis.
  axisXShift(0),

  /// Shift along the Y-axis.
  axisYShift(4),

  /// Align to the bottom.
  bottom(80),

  /// Center alignment.
  center(17),

  /// Center horizontally.
  centerHorizontal(1),

  /// Center vertically.
  centerVertical(16),

  /// Clip horizontally.
  clipHorizontal(8),

  /// Clip vertically.
  clipVertical(128),

  /// Display clip horizontally.
  displayClipHorizontal(16777216),

  /// Display clip vertically.
  displayClipVertical(268435456),

  /// Align to the end.
  end(8388613),

  /// Fill alignment.
  fill(119),

  /// Fill horizontally.
  fillHorizontal(7),

  /// Fill vertically.
  fillVertical(112),

  /// Mask for horizontal gravity.
  horizontalGravityMask(7),

  /// Align to the left.
  left(3),

  /// No gravity applied.
  noGravity(0),

  /// Mask for relative horizontal gravity.
  relativeHorizontalGravityMask(8388615),

  /// Relative layout direction.
  relativeLayoutDirection(8388608),

  /// Align to the right.
  right(5),

  /// Align to the start.
  start(8388611),

  /// Align to the top.
  top(48),

  /// Mask for vertical gravity.
  verticalGravityMask(112);

  /// The integer value associated with the gravity constant.
  final int value;

  /// Creates a [Gravity] enum with the given integer value.
  const Gravity(this.value);

  /// Returns the [Gravity] enum corresponding to the given integer value.
  ///
  /// Throws an [ArgumentError] if the value does not match any [Gravity] enum.
  static Gravity fromValue(int value) {
    return Gravity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Gravity.noGravity,
    );
  }
}

/// Enum for map memory budget
/// This enum defines the units of memory budget for a map.
enum MapMemoryBudgetIn {
  /// Memory budget is measured in megabytes.
  megaBytes,

  /// Memory budget is measured in tiles.
  tiles,
}

/// Satisfies embedding platforms that requires the viewport coordinate systems
/// to be set according to its standards.
enum ViewportMode {
  /// Default viewport mode, with no specific transformations.
  defaultMode,

  /// Viewport mode with flipped y-axis.
  flippedYMode
}

/// Defines the possible line cap styles.
enum LineCap {
  /// The line ends at the endpoint, forming a flat edge.
  butt,

  /// The line ends with a rounded edge.
  round,

  /// The line ends with a square edge extending beyond the endpoint.
  square,
}

/// Defines the possible line join styles.
enum LineJoin {
  /// The line joins with a rounded corner.
  round,

  /// The line joins with a beveled corner.
  bevel,

  /// The line joins with a sharp corner (mitered).
  miter,
}

/// Defines where the line translation anchor should be.
enum LineTranslateAnchor {
  /// The translation is relative to the map.
  map,

  /// The translation is relative to the viewport.
  viewport,
}

/// Defines anchor positions for an icon.
enum IconAnchor {
  /// The icon is anchored at the center.
  center("center"),

  /// The icon is anchored at the left.
  left("left"),

  /// The icon is anchored at the right.
  right("right"),

  /// The icon is anchored at the top.
  top("top"),

  /// The icon is anchored at the bottom.
  bottom("bottom"),

  /// The icon is anchored at the top-left corner.
  topLeft("top-left"),

  /// The icon is anchored at the top-right corner.
  topRight("top-right"),

  /// The icon is anchored at the bottom-left corner.
  bottomLeft("bottom-left"),

  /// The icon is anchored at the bottom-right corner.
  bottomRight("bottom-right");

  final String key;

  const IconAnchor(this.key);
}

/// Defines the alignment of the icon with respect to pitch.
enum IconPitchAlignment {
  /// Auto alignment based on other settings.
  auto,

  /// Icon is aligned with the map pitch.
  map,

  /// Icon is aligned with the viewport pitch.
  viewport,
}

/// Defines how the icon rotates with respect to the map or viewport.
enum IconRotationAlignment {
  /// Auto alignment based on other settings.
  auto,

  /// Icon rotates with the map.
  map,

  /// Icon rotates with the viewport.
  viewport,
}

/// Defines how the icon text fits.
enum IconTextFit {
  /// No text fitting applied.
  none,

  /// The text fits the width of the icon.
  width,

  /// The text fits the height of the icon.
  height,

  /// The text fits both the width and height of the icon.
  both,
}

/// Defines the placement of symbols (icons or text).
enum SymbolPlacement {
  /// The symbol is placed at a point.
  point("point"),

  /// The symbol is placed along a line.
  line("line"),

  /// The symbol is placed at the center of a line.
  lineCenter("line-center");

  final String key;

  const SymbolPlacement(this.key);
}

/// Defines the z-order of symbols.
enum SymbolZOrder {
  /// The symbol's z-order is determined automatically.
  auto("auto"),

  /// The symbol's z-order is based on the viewport's Y-axis.
  viewportY("viewport-y"),

  /// The symbol's z-order is based on the source.
  source("source");

  final String key;

  const SymbolZOrder(this.key);
}

/// Defines the anchor position for text.
enum TextAnchor {
  /// The text is anchored at the center.
  center("center"),

  /// The text is anchored at the left.
  left("left"),

  /// The text is anchored at the right.
  right("right"),

  /// The text is anchored at the top.
  top("top"),

  /// The text is anchored at the bottom.
  bottom("bottom"),

  /// The text is anchored at the top-left corner.
  topLeft("top-left"),

  /// The text is anchored at the top-right corner.
  topRight("top-right"),

  /// The text is anchored at the bottom-left corner.
  bottomLeft("bottom-left"),

  /// The text is anchored at the bottom-right corner.
  bottomRight("bottom-right");

  final String key;

  const TextAnchor(this.key);
}

/// Defines the text justification.
enum TextJustify {
  /// Text justification is determined automatically.
  auto,

  /// Text is left-aligned.
  left,

  /// Text is center-aligned.
  center,

  /// Text is right-aligned.
  right,
}

/// Defines the pitch alignment for text.
enum TextPitchAlignment {
  /// Auto alignment based on other settings.
  auto,

  /// Text is aligned with the map pitch.
  map,

  /// Text is aligned with the viewport pitch.
  viewport,
}

/// Defines the rotation alignment for text.
enum TextRotationAlignment {
  /// Auto alignment based on other settings.
  auto,

  /// Text rotates with the map.
  map,

  /// Text rotates with the viewport.
  viewport,
}

/// Defines the transformation for text (upper or lower case).
enum TextTransform {
  /// No transformation applied to the text.
  none,

  /// The text is transformed to uppercase.
  uppercase,

  /// The text is transformed to lowercase.
  lowercase,
}

/// Defines the translation anchor for icons.
enum IconTranslateAnchor {
  /// The icon's translation is relative to the map.
  map,

  /// The icon's translation is relative to the viewport.
  viewport,
}

/// Defines the translation anchor for text.
enum TextTranslateAnchor {
  /// The text's translation is relative to the map.
  map,

  /// The text's translation is relative to the viewport.
  viewport,
}

/// Defines the translation anchor for fill extrusions.
enum FillExtrusionTranslateAnchor {
  /// The fill extrusion is translated relative to the map.
  map,

  /// The fill extrusion is translated relative to the viewport.
  viewport,
}

/// Defines the translation anchor for fill layer.
enum FillTranslateAnchor {
  /// The fill extrusion is translated relative to the map.
  map,

  /// The fill extrusion is translated relative to the viewport.
  viewport,
}

/// Defines the type of sky rendering.
enum SkyType {
  /// The sky is rendered with a gradient.
  gradient,

  /// The sky is rendered using atmospheric scattering.
  atmosphere
}

/// Defines the resampling technique for raster images.
enum RasterResampling {
  /// Linear resampling is used for raster images.
  linear,

  /// Nearest-neighbor resampling is used for raster images.
  nearest,
}

/// Defines the illumination anchor for hill shading.
enum HillShadeIlluminationAnchor {
  /// Hill shading is relative to the north direction.
  map,

  /// Hill shading is relative to the top of the viewport.
  viewport,
}

/// Defines the translation anchor for circles.
enum CircleTranslateAnchor {
  /// The circle's translation is relative to the map.
  map,

  /// The circle's translation is relative to the viewport.
  viewport,
}

/// Defines the scaling of circles based on pitch.
enum CirclePitchScale {
  /// The circle is scaled based on the map pitch.
  map,

  /// The circle is scaled based on the viewport pitch.
  viewport,
}

/// Defines the pitch alignment for circles.
enum CirclePitchAlignment {
  /// The circle's pitch alignment is relative to the map.
  map,

  /// The circle's pitch alignment is relative to the viewport.
  viewport,
}

/// Defines the types of annotations.
enum AnnotationType {
  /// The annotation is a circle.
  circle,

  /// The annotation is a point.
  point,

  /// The annotation is a polygon.
  polygon,

  /// The annotation is a polyline.
  polyline,

  /// The annotation type is unknown.
  unknown,
}

/// Defines the states of a drag event.
enum DragEvent {
  /// The drag event has started.
  started,

  /// The drag event is in progress.
  dragging,

  /// The drag event has finished.
  finished,

  /// The drag event state is unknown.
  unknown,
}
