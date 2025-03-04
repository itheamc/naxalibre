package com.itheamc.naxalibre

import NaxaLibreFlutterApi
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

class NaxaLibreListeners(
    private val binaryMessenger: BinaryMessenger,
    private val libreView: MapView,
    private val libreMap: MapLibreMap,
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


    /** This function establishes communication between the native (Android) map view and the Flutter
     * application by registering listeners for various map-related events. These events, such as FPS
     * changes, map loading/rendering, clicks, camera movements, and more, are then communicated to
     * the Flutter side through the `flutterApi`.
     *
     * Each listener implementation triggers a corresponding method on the `flutterApi` object. The
     * lambda passed to these methods is a callback that's invoked when the message has been
     * successfully delivered to Flutter or if any exception occurs during the communication.
     *
     * The listeners include:
     * - `setOnFpsChangedListener`: Listens for changes in the frames per second (FPS) and
     *   notifies Flutter.
     * - `addOnDidFinishLoadingMapListener`: Listens for when the map finishes loading and
     *   notifies Flutter.
     * - `addOnDidFinishRenderingMapListener`: Listens for when the map finishes rendering and
     *   notifies Flutter.
     * - `addOnDidFinishLoadingStyleListener`: Listens for when the map style finishes
     *   loading and notifies Flutter.
     * - `addOnMapClickListener`: Listens for single clicks on the map and notifies Flutter,
     *   providing latitude, longitude, and altitude of the click location.
     * - `addOnMapLongClickListener`: Listens for long clicks on the map and notifies Flutter,
     *   providing latitude, longitude, and altitude of the click location.
     * - `addOnCameraIdleListener`: Listens for when the camera becomes idle and notifies Flutter.
     * - `addOnCameraMoveStartedListener`: Listens for the start of a camera movement and
     *   notifies Flutter with the reason.
     * - `addOnCameraMoveListener`: Listens for camera movements and notifies Flutter.
     * - `addOnCameraMoveCancelListener`: Listens for the end of a camera movement (cancellation)
     *   and notifies Flutter.
     * - `addOnFlingListener`: Listens for fling gestures on the map and notifies Flutter.
     * - `addOnRotateListener`: Listens for rotation gestures on the map (begin, during, end)
     *   and notifies Flutter.
     */
    private val onFpsChangedListener = OnFpsChangedListener {
        flutterApi.onFpsChanged(it) { _ ->
            // It is triggered when the message successfully delivered to the flutter part
            // Or any exception occur
        }
    }

    private val onDidFinishLoadingMapListener = OnDidFinishLoadingMapListener {
        flutterApi.onMapLoaded {}
    }

    private val onDidFinishRenderingMapListener = OnDidFinishRenderingMapListener {
        flutterApi.onMapRendered {}
    }

    private val onDidFinishLoadingStyleListener = OnDidFinishLoadingStyleListener {
        flutterApi.onStyleLoaded {}
    }

    private val onMapClickListener = OnMapClickListener {
        flutterApi.onMapClick(listOf(it.latitude, it.longitude, it.altitude)) {}
        true
    }

    private val onMapLongClickListener = OnMapLongClickListener {
        flutterApi.onMapLongClick(listOf(it.latitude, it.longitude, it.altitude)) {}
        true
    }

    private val onCameraIdleListener = OnCameraIdleListener {
        flutterApi.onCameraIdle {}
    }

    private val onCameraMoveStartedListener = OnCameraMoveStartedListener {
        flutterApi.onCameraMoveStarted(it.toLong()) {}
    }

    private val onCameraMoveListener = OnCameraMoveListener {
        flutterApi.onCameraMove {}
    }

    private val onCameraMoveCancelListener = OnCameraMoveCanceledListener {
        flutterApi.onCameraMoveEnd {}
    }

    private val onFlingListener = OnFlingListener {
        flutterApi.onFling {}
    }

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
}