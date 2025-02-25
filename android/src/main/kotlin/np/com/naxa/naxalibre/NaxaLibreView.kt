package np.com.naxa.naxalibre

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import np.com.naxa.naxalibre.parsers.NaxaLibreMapOptionsArgsParser
import org.maplibre.android.MapLibre
import org.maplibre.android.maps.MapView

/**
 * [NaxaLibreView] is a custom Flutter platform view that integrates a MapLibre map into a Flutter application.
 *
 * This class manages the lifecycle of the MapView and interacts with the Flutter framework via the [BinaryMessenger].
 * It also handles initial map configuration, UI settings, and event handling through the [NaxaLibreController].
 *
 * @param context The Android application context.
 * @param creationParams Optional parameters passed from Flutter during view creation. These can include settings for the map.
 * @param activity The current Android activity.
 * @param binaryMessenger The [BinaryMessenger] used to communicate between Flutter and the native code.
 *
 * @property _libreView The [MapView] instance that renders the map.
 * @property _controller The [NaxaLibreController] instance responsible for managing the map's behavior and communication.
 */
class NaxaLibreView(
    context: Context,
    private val creationParams: Map<*, *>?,
    private val activity: Activity?,
    private val binaryMessenger: BinaryMessenger
) :
    PlatformView, Application.ActivityLifecycleCallbacks {
    private var _libreView: MapView
    private var _controller: NaxaLibreController? = null

    /**
     * Initializes the NaxaLibreView.
     *
     * This block of code is executed upon the creation of an instance of NaxaLibreView. It performs
     * the following setup tasks:
     * 1. Initializes MapLibre with the provided context.
     * 2. Creates an instance of MapView for rendering the map.
     * 3. Sets up a callback to be invoked when the map has finished loading.
     * 4. Creates a NaxaLibreController to manage the map's behavior and communication.
     * 5. Sets the map's style URL, if provided in the creation parameters.
     * 6. Configures the map's UI settings, including the attribution dialog.
     * 7. Registers activity lifecycle callbacks to handle map lifecycle events.
     *
     * The method `getMapAsync` ensure that Map is ready before executing map functions.
     *
     */
    init {
        MapLibre.getInstance(context)
        _libreView = MapView(
            context,
            NaxaLibreMapOptionsArgsParser.parseArgs(
                context,
                creationParams?.get("mapOptions") as Map<*, *>?
            )
        )
        _libreView.getMapAsync { libreMap ->

            _controller = NaxaLibreController(
                binaryMessenger,
                activity!!,
                _libreView,
                libreMap,
                creationParams
            )

            _controller?.libreListeners?.register()

            val styleUrl = creationParams?.get("styleUrl") as? String
                ?: "https://demotiles.maplibre.org/style.json"
            libreMap.setStyle(styleUrl)
        }

        activity?.application?.registerActivityLifecycleCallbacks(this)
    }

    /**
     * Returns the underlying [View] associated with this object.
     *
     * This method provides access to the actual Android View that is being managed or represented
     * by this object. It allows interaction with the view's properties, hierarchy, and lifecycle.
     *
     * @return The [View] instance held by this object.
     */
    override fun getView(): View {
        return _libreView
    }

    /**
     * Disposes of the resources held by this object.
     *
     * This function performs the following actions:
     * 1. Unregisters this object as an ActivityLifecycleCallbacks from the application.
     *    This prevents memory leaks by ensuring that the application no longer holds
     *    a reference to this object after it's no longer needed.
     * 2. Removes any listeners associated with the internal controller (_controller).
     *    This is crucial for cleaning up any event subscriptions or callbacks that
     *    the controller might be managing.
     * 3. Nullifies the internal controller (_controller) to release its resources
     *    and make it eligible for garbage collection.
     * 4. Calls the onDestroy() method of the internal LibreView instance (_libreView).
     *    This allows LibreView to perform its own cleanup procedures, such as
     *    releasing resources or terminating background tasks.
     *
     * This function should be called when this object is no longer needed to ensure
     * proper resource cleanup and prevent potential memory leaks or unexpected
     * behavior.
     */
    override fun dispose() {
        activity?.application?.unregisterActivityLifecycleCallbacks(this)
        _controller?.libreListeners?.unregister()
        _controller = null
        _libreView.onDestroy()
    }

    /**
     * Called when an activity is created.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is created.
     * If the activity matches the one associated with this view, it calls the [MapView.onCreate] method.
     *
     * @param activity The activity that was created.
     * @param savedInstanceState If the activity is being re-initialized after previously being shut down then this Bundle
     * contains the data it most recently supplied in [onActivitySaveInstanceState].
     */
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity == this@NaxaLibreView.activity) _libreView.onCreate(savedInstanceState)
    }

    /**
     * Called when an activity is started.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is started.
     * If the activity matches the one associated with this view, it calls the [MapView.onStart] method.
     *
     * @param activity The activity that was started.
     */
    override fun onActivityStarted(activity: Activity) {
        if (activity == this@NaxaLibreView.activity) _libreView.onStart()
    }

    /**
     * Called when an activity is resumed.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is resumed.
     * If the activity matches the one associated with this view, it calls the [NaxaLibreController.setupListeners] method
     * and the [MapView.onResume] method.
     *
     * @param activity The activity that was resumed.
     */
    override fun onActivityResumed(activity: Activity) {
        if (activity == this@NaxaLibreView.activity) {
            _controller?.libreListeners?.register()
            _libreView.onResume()
        }
    }

    /**
     * Called when an activity is paused.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is paused.
     * If the activity matches the one associated with this view, it calls the [NaxaLibreController.removeListeners] method
     * and the [MapView.onPause] method.
     *
     * @param activity The activity that was paused.
     */
    override fun onActivityPaused(activity: Activity) {
        if (activity == this@NaxaLibreView.activity) {
            _controller?.libreListeners?.unregister()
            _libreView.onPause()
        }
    }

    /**
     * Called when an activity is stopped.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is stopped.
     * If the activity matches the one associated with this view, it calls the [MapView.onStop] method.
     *
     * @param activity The activity that was stopped.
     */
    override fun onActivityStopped(activity: Activity) {
        if (activity == this@NaxaLibreView.activity) _libreView.onStop()
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (activity == this@NaxaLibreView.activity) _libreView.onSaveInstanceState(outState)
    }

    /**
     * Called when an activity is destroyed.
     *
     * This method is part of the [Application.ActivityLifecycleCallbacks] interface and is called when an activity is destroyed.
     * If the activity matches the one associated with this view, it calls the [NaxaLibreController.removeListeners] method,
     * sets the controller to null, and calls the [MapView.onDestroy] method.
     *
     * @param activity The activity that was destroyed.
     */
    override fun onActivityDestroyed(activity: Activity) {
        if (activity == this@NaxaLibreView.activity) {
            _controller?.libreListeners?.unregister()
            _controller = null
            _libreView.onDestroy()
        }
    }
}