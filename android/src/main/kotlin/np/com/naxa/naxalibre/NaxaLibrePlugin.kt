package np.com.naxa.naxalibre


import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewRegistry

class NaxaLibrePlugin : FlutterPlugin, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var viewFactory: NaxaLibreViewFactory? = null
    private var platformViewRegistry: PlatformViewRegistry? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        platformViewRegistry = binding.platformViewRegistry
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        platformViewRegistry = null
        pluginBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        registerViewFactory()
    }

    override fun onDetachedFromActivity() {
        activity = null
        viewFactory = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        registerViewFactory()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        viewFactory = null
    }

    private fun registerViewFactory() {
        // Only register if we have both activity and registry
        activity?.let { activity ->
            platformViewRegistry?.let { registry ->
                viewFactory = NaxaLibreViewFactory(
                    activity,
                    binaryMessenger = pluginBinding!!.binaryMessenger
                )
                registry.registerViewFactory(
                    "naxalibre/mapview",
                    viewFactory!!
                )
            }
        }
    }
}





