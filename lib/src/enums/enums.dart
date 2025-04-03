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

/// Defines the different stages of a camera movement event.
///
/// This enum is used to track the lifecycle of camera movements,
/// such as panning, zooming, or tilting. It helps in handling
/// UI updates or triggering actions based on camera motion.
enum CameraMoveEvent {
  /// Indicates that the camera movement has started.
  ///
  /// This event is fired at the initial moment when a camera movement begins,
  /// such as when the user starts dragging the map or a programmatic animation starts.
  start,

  /// Indicates that the camera is currently in motion.
  ///
  /// This event is triggered continuously while the camera is moving.
  /// It can be used to update UI elements in real-time or perform
  /// computations that depend on the camera position.
  moving,

  /// Indicates that the camera movement has ended.
  ///
  /// This event is triggered once the camera stops moving,
  /// either because the user has stopped interacting with the map
  /// or an animation has completed.
  end,
}

/// Defines the different stages of a rotation event.
///
/// This enum is used to monitor rotation actions on a map or UI element.
/// It helps in executing animations, handling state updates, or triggering
/// related actions during rotation gestures or programmatic rotations.
enum RotateEvent {
  /// Indicates that the rotation has started.
  ///
  /// This event is fired when a rotation gesture begins, such as
  /// when the user places two fingers on the screen and starts rotating.
  /// It can also be triggered when a scripted rotation animation starts.
  start,

  /// Indicates that the rotation is currently in progress.
  ///
  /// This event is triggered continuously while the rotation is happening.
  /// It can be used to update visual elements dynamically or apply constraints
  /// to the rotation angle.
  rotating,

  /// Indicates that the rotation has ended.
  ///
  /// This event is fired when the rotation gesture is completed or when
  /// a programmatic rotation animation comes to a stop. It can be useful
  /// for snapping the rotated element to a final position or saving state.
  end,
}

/// Defines the different stages of a annotation drag event.
///
/// This enum is used to track the lifecycle of annotation drag,
///
enum AnnotationDragEvent {
  /// Indicates that the annotation drag has started.
  ///
  /// This event is fired at the initial moment when a annotation drag begins,
  /// such as when the user starts dragging the annotation.
  start,

  /// Indicates that the annotation is currently in motion i.e. dragging.
  ///
  /// This event is triggered continuously while the annotation is dragging.
  /// It can be used to update UI elements in real-time or perform
  /// computations that depend on the annotation drag.
  dragging,

  /// Indicates that the annotation drag has ended.
  ///
  /// This event is triggered once the drags ends or canceled,
  end;

  /// Constructs a `AnnotationDragEvent` from a string.
  ///
  /// This factory method takes a string `value` and maps it to the
  /// corresponding `AnnotationDragEvent`. It is used for parsing or
  /// deserializing events from string representations.
  ///
  /// - If `value` is 'start', it returns `AnnotationDragEvent.start`.
  /// - If `value` is 'dragging', it returns `AnnotationDragEvent.dragging`.
  /// - For any other `value`, it defaults to returning `AnnotationDragEvent.end`.
  factory AnnotationDragEvent.fromStr(String? value) {
    return switch (value) {
      'start' => AnnotationDragEvent.start,
      'dragging' => AnnotationDragEvent.dragging,
      _ => AnnotationDragEvent.end,
    };
  }
}

/// Represents gravity constants used for positioning or alignment.
/// Each value corresponds to a specific gravity constant with an associated integer value.
///
enum Gravity {
  /// No gravity applied.
  none(-1),

  /// Place the view in the top left of the map view
  topLeft(0),

  /// Place the view in the top right of the map view
  topRight(1),

  /// Place the view in the bottom left of the map view
  bottomLeft(2),

  /// Place the view in the bottom right of the map view
  bottomRight(3);

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
      orElse: () => Gravity.none,
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
  flippedYMode,
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
  atmosphere,
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

/// Defines the different modes for hyper-composition, a technique used to optimize
/// rendering of complex UI elements, especially those involving platform views
/// (like Android Views) or heavy drawing operations.
enum HyperCompositionMode {
  /// Hyper-composition is completely disabled.
  ///
  /// This mode provides the simplest rendering path but may result in performance
  /// issues with complex UIs, particularly when platform views are involved.
  /// Platform views will be rendered in their standard composited manner.
  disabled,

  /// Hyper-composition is enabled using an Android View (specifically, a TextureView
  /// on Android).
  ///
  /// This mode is suitable for rendering platform views efficiently. The platform
  /// view content is rendered into a TextureView, which can then be composited
  /// more effectively by Flutter. This can improve performance compared to the
  /// `disabled` mode when dealing with Android Views.
  ///
  /// Note: This mode is specifically designed for Android. It might have no effect
  /// or behave differently on other platforms.
  androidView,

  /// Hyper-composition is enabled using a SurfaceView.
  ///
  /// This mode attempts to use a SurfaceView for rendering, potentially offering
  /// better performance than `androidView` in certain scenarios. SurfaceViews
  /// have a more direct rendering path, which can reduce latency and improve
  /// frame rates.
  ///
  /// SurfaceViews, however, have limitations in terms of compositing with other
  /// Flutter widgets and might lead to visual artifacts if not used correctly.
  ///
  /// Note: Implementation and performance characteristics may vary depending
  /// on the platform.
  surfaceView,

  /// Hyper-composition is enabled using an "expensive view".
  ///
  /// This mode is intended for scenarios where a custom, potentially expensive,
  /// rendering strategy is required. It allows for more fine-grained control
  /// over the rendering process, potentially enabling optimizations for
  /// complex drawing operations.
  ///
  /// This mode typically involves creating a custom view or surface that handles
  /// the rendering logic. The exact implementation and performance implications
  /// depend heavily on the specific rendering code.
  ///
  /// It should be used for rendering scenarios that are too costly for normal Flutter rendering,
  /// and that may not be well served by SurfaceView or TextureView.
  ///
  /// The performance of this mode heavily depends on the implementation.
  expensiveView,
}
