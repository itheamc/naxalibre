package np.com.naxa.naxalibre

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * NaxaLibreViewFactory is a PlatformViewFactory responsible for creating instances of NaxaLibreView.
 *
 * This class bridges the gap between Flutter's UI system and native Android views. It acts as a factory
 * that Flutter can use to request the creation of a native Android view, specifically the NaxaLibreView.
 *
 * @property activity The parent Activity that hosts the Flutter view. It might be needed for accessing
 *                     activity-related resources or starting new activities from within the native view.
 *                     It can be null if not required.
 * @property binaryMessenger The BinaryMessenger used for communication between Flutter and the native
 *                           side. It's employed to send messages from the native view to Flutter and vice-versa.
 */
class NaxaLibreViewFactory(
    private val activity: Activity?,
    private val binaryMessenger: BinaryMessenger
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    /**
     * Creates a PlatformView instance for rendering the NaxaLibreView.
     *
     * This function is called by Flutter's platform view system to instantiate and manage the
     * native view. It receives the necessary context, view ID, and creation parameters.
     *
     * @param context The application context.
     * @param viewId The unique identifier for this view instance. This ID is assigned by Flutter.
     * @param args Optional arguments passed from the Flutter side during view creation.
     *             These arguments are expected to be a Map containing key-value pairs.
     *             If no arguments are passed, `args` will be `null`.
     *             The map is casted to Map<*,*> because the type of the value can be different
     *             and will be treated in the NaxaLibreView constructor.
     * @return A new instance of [NaxaLibreView], configured with the given parameters.
     * @throws ClassCastException If the `args` parameter is not `null` and cannot be cast to a Map.
     */
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<*, *>
        return NaxaLibreView(context, creationParams, activity, binaryMessenger)
    }
}