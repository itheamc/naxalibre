package np.com.naxa.naxalibre


import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.platform.PlatformViewRegistry

/**
 * NaxaLibrePlugin
 *
 * This class is the main plugin class for the NaxaLibre Flutter plugin.
 * It handles the lifecycle of the plugin, manages the associated activity,
 * and registers the NaxaLibreViewFactory for creating and displaying the map view.
 *
 * It conforms to the [FlutterPlugin] and [ActivityAware] interfaces to
 * interact with the Flutter engine and activity lifecycle.
 */
class NaxaLibrePlugin : FlutterPlugin, ActivityAware {
    private var activity: Activity? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var viewFactory: NaxaLibreViewFactory? = null
    private var platformViewRegistry: PlatformViewRegistry? = null

    /**
     * This is called when the plugin is attached to the Flutter engine.
     *
     * This method is part of the `FlutterPlugin` interface and is called by Flutter
     * when the plugin is registered with a Flutter engine. It provides access to
     * essential components like the `FlutterPluginBinding`, `BinaryMessenger`, and
     * `PlatformViewRegistry`.
     *
     * In this implementation, it stores the `FlutterPluginBinding` and
     * `PlatformViewRegistry` for later use.
     *
     * @param binding The [FlutterPlugin.FlutterPluginBinding] provided by Flutter. It contains
     *                references to the `BinaryMessenger`, `PlatformViewRegistry`, and other
     *                essential components for plugin interaction with Flutter.
     *
     *                - `binding.binaryMessenger`: Allows for communication with the Dart side of Flutter.
     *                - `binding.platformViewRegistry`: Allows registering platform views.
     *
     *
     */
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        platformViewRegistry = binding.platformViewRegistry
    }

    /**
     * Called when the Flutter engine detaches from this plugin.
     *
     * This method is invoked when the Flutter engine is detached from the plugin.
     * It provides an opportunity to release any resources that were being held by the plugin,
     * and to clean up any state that was associated with the Flutter engine.
     *
     * In this specific implementation:
     * 1. It sets the `platformViewRegistry` to null, indicating that the plugin is no longer
     *    managing any platform views. This is important for releasing resources associated
     *    with platform views.
     * 2. It sets the `pluginBinding` to null, releasing the reference to the FlutterPluginBinding.
     *    This ensures that the binding is no longer held by the plugin, allowing for proper
     *    garbage collection.
     *
     * This method should be used to perform any necessary cleanup when the plugin is no longer
     * connected to a Flutter engine.
     *
     * @param binding The FlutterPluginBinding that was associated with the plugin. This is
     *                typically no longer needed after detachment, and therefore it's not being used in this implementation,
     *                it's primarily used to comply with the interface.
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        platformViewRegistry = null
        pluginBinding = null
    }

    /**
     * Called when the plugin is attached to an Activity.
     *
     * This method is invoked when the plugin is added to an Activity via an [ActivityPluginBinding].
     * It provides the plugin with a reference to the attached [android.app.Activity] and allows
     * it to perform necessary setup.
     *
     * In this specific implementation, it:
     *   1. Stores a reference to the attached [android.app.Activity] in the `activity` property.
     *   2. Registers the view factory for creating custom platform views.
     *
     * @param binding The [ActivityPluginBinding] instance that connects this plugin to the Activity.
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        registerViewFactory()
    }

    /**
     * Called when the Flutter plugin is detached from the host Activity.
     *
     * This method is called when the Flutter engine is detached from the Activity that
     * was previously associated with the plugin.  This typically happens when the
     * Activity is destroyed or when the Flutter engine is detached for some other reason.
     *
     * This is the appropriate place to release any resources that were tied to the
     * Activity or its lifecycle. In this case, we are releasing the references to
     * the `activity` and the `viewFactory`.
     *
     * After this method is called, the plugin will no longer receive callbacks
     * related to Activity events.
     */
    override fun onDetachedFromActivity() {
        activity = null
        viewFactory = null
    }

    /**
     * This method is called when the plugin is re-attached to an activity after a configuration change.
     *
     * This typically happens when the device's orientation changes (e.g., portrait to landscape) or when
     * other system-level configuration changes occur that require the activity to be recreated.
     *
     * It's important to re-establish any necessary connections or resources that might have been
     * lost during the configuration change. In this case, it updates the `activity` reference and
     * re-registers the view factory.
     *
     * @param binding The [ActivityPluginBinding] that is associated with the re-attached activity.
     *                This binding provides access to the activity and other necessary resources.
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        registerViewFactory()
    }

    /**
     * Called when the host Activity is being temporarily detached due to a configuration change.
     *
     * This method is invoked by the system when the host Activity is undergoing a configuration
     * change (e.g., screen rotation) that requires the Activity to be destroyed and recreated.
     * It's a signal to clean up any references to the Activity and associated resources,
     * as they will be invalid after the configuration change.
     *
     * In this implementation, we are releasing the references to the [activity] and
     * [viewFactory] to avoid potential memory leaks. These references will be re-initialized
     * when the Activity is reattached via [onAttachedToActivity].
     *
     * Note: This is a temporary detachment. The Activity will be reattached shortly after.
     *
     * @see onAttachedToActivity
     */
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        viewFactory = null
    }

    /**
     * Registers the NaxaLibreViewFactory with the Flutter platform view registry.
     *
     * This function attempts to register the custom view factory (`NaxaLibreViewFactory`)
     * with Flutter's platform view registry. This allows the Flutter app to create and
     * display native Android views defined by `NaxaLibreView`.
     *
     * The registration process is conditional and will only proceed if both:
     * 1. The `activity` property is not null (i.e., the plugin is attached to an activity).
     * 2. The `platformViewRegistry` property is not null (i.e., a platform view registry is available).
     *
     * If both conditions are met:
     *   - A new `NaxaLibreViewFactory` instance is created, which is responsible for
     *     creating `NaxaLibreView` instances. It requires:
     *       - The current `activity` (as a `Context`).
     *       - The plugin's `binaryMessenger` for communication between Flutter and native code.
     *   - The factory is then registered with the `platformViewRegistry` using the unique
     *     identifier "naxalibre/mapview". This identifier is used by the Flutter side
     *     to request the creation of this specific type of native view.
     *
     * If either `activity` or `platformViewRegistry` is null, the registration is skipped,
     * meaning the native view will not be available to the Flutter application.
     *
     */
    private fun registerViewFactory() {
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





