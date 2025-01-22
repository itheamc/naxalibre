package np.com.naxa.naxalibre

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NaxaLibreViewFactory(
    private val activity: Activity?,
    private val binaryMessenger: BinaryMessenger
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<*, *>
        return NaxaLibreView(context, creationParams, activity, binaryMessenger)
    }
}