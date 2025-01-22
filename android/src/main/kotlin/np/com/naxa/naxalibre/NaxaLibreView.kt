package np.com.naxa.naxalibre

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import org.maplibre.android.MapLibre
import org.maplibre.android.maps.MapView

private const val TAG = "NaxaLibreView"

class NaxaLibreView(
    context: Context,
    creationParams: Map<*, *>?,
    private val activity: Activity?,
    private val binaryMessenger: BinaryMessenger
) :
    PlatformView, Application.ActivityLifecycleCallbacks {
    private var _libreView: MapView
    private var _controller: NaxaLibreController? = null

    init {
        Log.d(TAG, "onInit: Initialized NaxaLibre")
        MapLibre.getInstance(context)
        _libreView = MapView(context)
        _libreView.getMapAsync { libreMap ->
            _controller = NaxaLibreController(binaryMessenger, activity!!, _libreView, libreMap)
            val styleUrl = creationParams?.get("styleURL") as? String
            libreMap.setStyle(styleUrl)

            libreMap.uiSettings.apply {
                setAttributionDialogManager(NaxaLibreAttributionDialogManager(context, libreMap))
            }
        }

        activity?.application?.registerActivityLifecycleCallbacks(this)
    }

    override fun getView(): View {
        return _libreView
    }

    override fun dispose() {
        Log.d(TAG, "dispose: ")
        activity?.application?.unregisterActivityLifecycleCallbacks(this)
        _libreView.onDestroy()
    }

    /**
     * Lifecycle callbacks for MapView
     */
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        Log.d(TAG, "onActivityCreated: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onCreate(savedInstanceState)
    }

    override fun onActivityStarted(activity: Activity) {
        Log.d(TAG, "onActivityStarted: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onStart()
    }

    override fun onActivityResumed(activity: Activity) {
        Log.d(TAG, "onActivityResumed: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        Log.d(TAG, "onActivityPaused: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onPause()
    }

    override fun onActivityStopped(activity: Activity) {
        Log.d(TAG, "onActivityStopped: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onStop()
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        Log.d(TAG, "onActivitySaveInstanceState: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        Log.d(TAG, "onActivityDestroyed: ")
        if (activity == this@NaxaLibreView.activity) _libreView.onDestroy()
    }
}