package com.itheamc.naxalibre

import NaxaLibreFlutterApi
import com.google.gson.Gson
import com.itheamc.naxalibre.utils.JsonUtils
import io.flutter.plugin.common.BinaryMessenger
import org.maplibre.android.gestures.RotateGestureDetector
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.maps.MapLibreMap.OnCameraIdleListener
import org.maplibre.android.maps.MapLibreMap.OnCameraMoveCanceledListener
import org.maplibre.android.maps.MapLibreMap.OnCameraMoveListener
import org.maplibre.android.maps.MapLibreMap.OnCameraMoveStartedListener
import org.maplibre.android.maps.MapLibreMap.OnFlingListener
import org.maplibre.android.maps.MapLibreMap.OnFpsChangedListener
import org.maplibre.android.maps.MapLibreMap.OnMapClickListener
import org.maplibre.android.maps.MapLibreMap.OnMapLongClickListener
import org.maplibre.android.maps.MapLibreMap.OnRotateListener
import org.maplibre.android.maps.MapView
import org.maplibre.android.maps.MapView.OnDidFinishLoadingMapListener
import org.maplibre.android.maps.MapView.OnDidFinishLoadingStyleListener
import org.maplibre.android.maps.MapView.OnDidFinishRenderingMapListener
import org.maplibre.android.style.layers.Layer

class NaxaLibreListeners(
    private val binaryMessenger: BinaryMessenger,
    private val libreView: MapView,
    private val libreMap: MapLibreMap,
    private val libreAnnotationsManager: NaxaLibreAnnotationsManager,
) {
    /**
     * Provides access to the Flutter API for communication between the native (Kotlin) and Flutter sides.
     *
     * This property lazily initializes an instance of [NaxaLibreFlutterApi], which is responsible for
     * handling method calls and events from the Flutter side.
     *
     * The binaryMessenger is used to send and receive messages to and from the Flutter side.
     *
     * @see NaxaLibreFlutterApi
     * @see BinaryMessenger
     */
    private val flutterApi by lazy { NaxaLibreFlutterApi(binaryMessenger) }


    /**
     * Listener that is triggered when the frames per second (FPS) of the video or animation being played changes.
     * This listener provides the updated FPS value as a parameter in the `onFpsChanged` callback.
     *
     */
    private val onFpsChangedListener = OnFpsChangedListener {
        flutterApi.onFpsChanged(it) { _ ->
            // It is triggered when the message successfully delivered to the flutter part
            // Or any exception occur
        }
    }

    /**
     * Listener that gets triggered when the map has finished loading.
     *
     * This listener is implemented to communicate to the Flutter side when the Mapbox map has
     * fully loaded and is ready for interaction.  Upon completion, it calls the `onMapLoaded`
     * function in the `flutterApi` to notify the Flutter application.
     *
     */
    private val onDidFinishLoadingMapListener = OnDidFinishLoadingMapListener {
        flutterApi.onMapLoaded {}
    }

    /**
     * Listener that gets invoked when the map has finished rendering.
     *
     * This listener is used to notify the Flutter side when the map has completed its initial rendering.
     * It triggers the `onMapRendered` callback on the Flutter API.
     *
     * This can be useful for scenarios where you need to perform actions after the map is visually
     * ready, such as taking a screenshot or interacting with map features.
     *
     * The listener is automatically registered and unregistered by the plugin at the appropriate
     * times during the map's lifecycle.
     */
    private val onDidFinishRenderingMapListener = OnDidFinishRenderingMapListener {
        flutterApi.onMapRendered {}
    }

    /**
     * Listener that is triggered when the map's style has finished loading.
     *
     * This listener is used to notify the Flutter side of the application
     * that the map's style has been successfully loaded and rendered.
     *
     * It internally calls the `onStyleLoaded` method of the `flutterApi` to
     * communicate this event to Flutter.
     *
     * This is crucial for scenarios where UI elements or other actions
     * in the Flutter app depend on the map style being fully loaded.
     */
    private val onDidFinishLoadingStyleListener = OnDidFinishLoadingStyleListener {
        flutterApi.onStyleLoaded {}
    }

    /**
     *  This listener is triggered when the user clicks on the map.
     *  It handles two primary scenarios:
     *  1. **Map Click (No Annotation):** If the click does not intersect with any annotation,
     *     it triggers the `onMapClick` event in the Flutter side, passing the latitude,
     *     longitude, and altitude of the clicked location.
     *  2. **Annotation Click:** If the click intersects with an annotation, it triggers the
     *     `onAnnotationClick` event in Flutter, passing the properties associated with that
     *     annotation as a map.
     *
     */
    private val onMapClickListener = OnMapClickListener {
        try {
            val (annotationAtLatLng, properties) = libreAnnotationsManager.isAnnotationAtLatLng(it)

            if (!annotationAtLatLng) {
                flutterApi.onMapClick(listOf(it.latitude, it.longitude, it.altitude)) {}
                return@OnMapClickListener true
            }

            flutterApi.onAnnotationClick(
                JsonUtils.jsonToMap(
                    Gson().toJson(properties),
                    String::toString
                )
            ) {}
            return@OnMapClickListener true
        } catch (_: Exception) {
            flutterApi.onMapClick(listOf(it.latitude, it.longitude, it.altitude)) {}
            return@OnMapClickListener true
        }
    }

    /**
     *  Listener for long clicks on the map.
     *
     *  This listener handles long click events on the map. It checks if an annotation exists at the long-clicked location.
     *  - If an annotation is found at the location:
     *      - It calls the `onAnnotationLongClick` method on the `flutterApi`, passing a map of the annotation's properties.
     *  - If no annotation is found at the location:
     *      - It calls the `onMapLongClick` method on the `flutterApi`, passing a list containing the latitude, longitude, and altitude of the long-clicked point.
     *  - In case of any exception during processing:
     *      - It falls back to calling `onMapLongClick` with the coordinates.
     *
     *  The function always returns `true` to consume the long click event, preventing further propagation.
     */
    private val onMapLongClickListener = OnMapLongClickListener {
        try {
            val (annotationAtLatLng, properties) = libreAnnotationsManager.isAnnotationAtLatLng(it)

            if (!annotationAtLatLng) {
                flutterApi.onMapLongClick(listOf(it.latitude, it.longitude, it.altitude)) {}
                return@OnMapLongClickListener true
            }

            if (libreAnnotationsManager.isDraggable(properties)) {
                libreAnnotationsManager.removeAnnotationDragListeners()
                libreAnnotationsManager.addAnnotationDragListener { id, type, annotation, updatedAnnotation, event ->
                    flutterApi.onAnnotationDrag(
                        id,
                        type.name,
                        annotation.toGeometryJson(),
                        updatedAnnotation.toGeometryJson(),
                        event
                    ) { _ -> }
                }

                libreAnnotationsManager.handleDragging(properties!!)
            }

            flutterApi.onAnnotationLongClick(
                JsonUtils.jsonToMap(
                    Gson().toJson(properties),
                    String::toString
                )
            ) {}
            return@OnMapLongClickListener true
        } catch (_: Exception) {
            flutterApi.onMapLongClick(listOf(it.latitude, it.longitude, it.altitude)) {}
            return@OnMapLongClickListener true
        }
    }

    /**
     * Listener that is triggered when the camera movement has ended.
     *
     * This listener is used to notify the Flutter side when the camera has stopped moving,
     * indicating that the user has finished interacting with the map's view (e.g., panning, zooming).
     * It triggers the `onCameraIdle` event in the Flutter API.
     *
     * The implementation utilizes the `OnCameraIdleListener` from the `maps-ktx` library.
     */
    private val onCameraIdleListener = OnCameraIdleListener {
        flutterApi.onCameraIdle {}
    }

    /**
     * Listener that gets invoked when the camera starts moving.
     *
     * This listener is triggered when the camera starts moving due to a user gesture on the map,
     * an animation (e.g., pan or zoom), or programmatic changes to the camera position.
     *
     * The `reason` parameter indicates the cause of the camera movement. It can be one of:
     * - `OnCameraMoveStartedListener.REASON_GESTURE`: Indicates that the camera movement was initiated by a user gesture.
     * - `OnCameraMoveStartedListener.REASON_API_ANIMATION`: Indicates that the camera movement was initiated by an animation.
     * - `OnCameraMoveStartedListener.REASON_DEVELOPER_ANIMATION`: Indicates that the camera movement was initiated by a programmatic change.
     *
     * This listener calls the `onCameraMoveStarted` method on the `flutterApi` to notify the Flutter side
     * that the camera movement has started, providing the movement reason as a long value.
     */
    private val onCameraMoveStartedListener = OnCameraMoveStartedListener {
        flutterApi.onCameraMoveStarted(it.toLong()) {}
    }

    /**
     * Listener that is invoked when the camera starts to move or is moving.
     *
     * This listener triggers the `onCameraMove` event on the Flutter side via the Flutter API.
     * It's used to notify Flutter about camera position changes during user interactions
     * such as dragging, zooming, or tilting the map.
     *
     * The listener implementation calls the `flutterApi.onCameraMove {}` method,
     * which sends a signal to the Flutter application indicating that the camera is moving.
     *
     */
    private val onCameraMoveListener = OnCameraMoveListener {
        flutterApi.onCameraMove {}
    }

    /**
     * Listener that gets invoked when the user cancels a camera movement gesture.
     *
     * This listener is part of the Google Maps Android API and is used to detect
     * when a user interaction that was moving the camera is interrupted or
     * canceled before the camera has reached its final position.  This usually
     * happens when the user lifts their finger during a drag or zoom gesture.
     *
     * When this event is triggered, the `onCameraMoveEnd` method of the
     * `flutterApi` object is invoked. This signals to the Flutter side of
     * the application that a camera move has been canceled.
     *
     */
    private val onCameraMoveCancelListener = OnCameraMoveCanceledListener {
        flutterApi.onCameraMoveEnd {}
    }

    /**
     * Listener that is triggered when a fling gesture is detected.
     *
     * This listener uses the OnFlingListener interface (presumably a custom one
     * defined in your project or a dependency). When a fling is detected, it
     * invokes the `onFling` method on the `flutterApi` object, notifying the
     * Flutter side about the fling event.
     *
     * The `onFling` method in `flutterApi` should handle the corresponding
     * logic in the Flutter application.
     *
     */
    private val onFlingListener = OnFlingListener {
        flutterApi.onFling {}
    }

    /**
     * Listener for rotate gesture events.
     *
     * This listener is an implementation of the `OnRotateListener` interface and is responsible for
     * relaying rotate gesture events to the Flutter side via the `flutterApi`.
     */
    private val onRotateListener = object : OnRotateListener {
        override fun onRotateBegin(p0: RotateGestureDetector) {
            flutterApi.onRotateStarted(
                p0.angleThreshold.toDouble(),
                p0.deltaSinceStart.toDouble(),
                p0.deltaSinceLast.toDouble(),
            ) {}
        }

        override fun onRotate(p0: RotateGestureDetector) {
            flutterApi.onRotate(
                p0.angleThreshold.toDouble(),
                p0.deltaSinceStart.toDouble(),
                p0.deltaSinceLast.toDouble(),
            ) {}
        }

        override fun onRotateEnd(p0: RotateGestureDetector) {
            flutterApi.onRotateEnd(
                p0.angleThreshold.toDouble(),
                p0.deltaSinceStart.toDouble(),
                p0.deltaSinceLast.toDouble(),
            ) {}
        }
    }

    /**
     * Registers various listeners to the LibreMap and LibreView instances.
     *
     * This function sets up event listeners for:
     * - FPS changes (onFpsChangedListener)
     * - Map loading completion (onDidFinishLoadingMapListener)
     * - Map rendering completion (onDidFinishRenderingMapListener)
     * - Style loading completion (onDidFinishLoadingStyleListener)
     * - Map clicks (onMapClickListener)
     * - Map long clicks (onMapLongClickListener)
     * - Camera idle state (onCameraIdleListener)
     * - Camera movement start (onCameraMoveStartedListener)
     * - Camera movement (onCameraMoveListener)
     * - Camera movement cancellation (onCameraMoveCancelListener)
     * - Fling gestures (onFlingListener)
     * - Rotation gestures (onRotateListener)
     *
     * These listeners allow the application to respond to different events happening within the map
     * and map view, enabling features like user interaction feedback, performance monitoring,
     * and data updates based on the map's state.
     *
     * **Note:** It's important to ensure that these listeners are properly unregistered when they are no longer needed
     * to avoid memory leaks. This is typically done in a corresponding "unregister" function or during component
     * lifecycle teardown.
     *
     */
    fun register() {
        libreMap.setOnFpsChangedListener(onFpsChangedListener)
        libreView.addOnDidFinishLoadingMapListener(onDidFinishLoadingMapListener)
        libreView.addOnDidFinishRenderingMapListener(onDidFinishRenderingMapListener)
        libreView.addOnDidFinishLoadingStyleListener(onDidFinishLoadingStyleListener)
        libreMap.addOnMapClickListener(onMapClickListener)
        libreMap.addOnMapLongClickListener(onMapLongClickListener)
        libreMap.addOnCameraIdleListener(onCameraIdleListener)
        libreMap.addOnCameraMoveStartedListener(onCameraMoveStartedListener)
        libreMap.addOnCameraMoveListener(onCameraMoveListener)
        libreMap.addOnCameraMoveCancelListener(onCameraMoveCancelListener)
        libreMap.addOnFlingListener(onFlingListener)
        libreMap.addOnRotateListener(onRotateListener)
    }


    /**
     * Unregisters all listeners that were previously registered with the LibreView and LibreMap.
     *
     * This function removes listeners for various events related to map loading, rendering,
     * user interactions (clicks, long clicks, flings, rotations), and camera movements.
     *
     * It's crucial to call this function when the listeners are no longer needed,
     * for instance, when a fragment or activity is being destroyed, to prevent memory leaks.
     *
     * Specifically, it removes the following listeners:
     *  - onDidFinishLoadingMapListener: Listener for when the map finishes loading.
     *  - onDidFinishRenderingMapListener: Listener for when the map finishes rendering.
     *  - onDidFinishLoadingStyleListener: Listener for when the map style finishes loading.
     *  - onMapClickListener: Listener for when the map is clicked.
     *  - onMapLongClickListener: Listener for when the map is long-clicked.
     *  - onCameraIdleListener: Listener for when the camera becomes idle.
     *  - onCameraMoveStartedListener: Listener for when the camera movement starts.
     *  - onCameraMoveListener: Listener for when the camera is moving.
     *  - onCameraMoveCancelListener: Listener for when the camera movement is canceled.
     *  - onFlingListener: Listener for when a fling gesture occurs on the map.
     *  - onRotateListener: Listener for when a rotation gesture occurs on the map.
     *
     */
    fun unregister() {
        libreView.removeOnDidFinishLoadingMapListener(onDidFinishLoadingMapListener)
        libreView.removeOnDidFinishRenderingMapListener(onDidFinishRenderingMapListener)
        libreView.removeOnDidFinishLoadingStyleListener(onDidFinishLoadingStyleListener)
        libreMap.removeOnMapClickListener(onMapClickListener)
        libreMap.removeOnMapLongClickListener(onMapLongClickListener)
        libreMap.removeOnCameraIdleListener(onCameraIdleListener)
        libreMap.removeOnCameraMoveStartedListener(onCameraMoveStartedListener)
        libreMap.removeOnCameraMoveListener(onCameraMoveListener)
        libreMap.removeOnCameraMoveCancelListener(onCameraMoveCancelListener)
        libreMap.removeOnFlingListener(onFlingListener)
        libreMap.removeOnRotateListener(onRotateListener)
    }

    /**
     * Converts an Annotation object to a it's geometry representation.
     *
     * @param T The type of the Layer associated with the annotation.
     * @receiver The Annotation object to be converted.
     * @return A Map<String, Any?> representing the annotation's properties.
     * @throws Exception if there is an issue during Json conversion.
     *
     */
    private fun <T : Layer> NaxaLibreAnnotationsManager.Annotation<T>.toGeometryJson(): Map<String, Any?> {
        return geometry?.toJson()
            ?.let {
                JsonUtils.jsonToMap(it) { k -> k.toString() }
            }?.toMutableMap()?.apply {
                this["id"] = id
            } ?: mutableMapOf()
    }
}