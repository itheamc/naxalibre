package np.com.naxa.naxalibre.parsers

import android.content.Context
import org.maplibre.android.maps.MapLibreMapOptions

/**
 * Object responsible for parsing arguments provided to configure a MapLibre.
 *
 * This object provides a utility function [parseArgs] that takes a [Context] and a map of arguments
 * and constructs a [MapLibreMapOptions] object based on these arguments. It handles parsing various
 * map options, including camera position, zoom and pitch limits, pixel ratio, and boolean flags.
 */
object MapLibreMapOptionsArgsParser {

    /**
     * Parses a map of arguments to create a [MapLibreMapOptions] object.
     *
     * This function takes a [Context] and an optional map of arguments and constructs
     * a [MapLibreMapOptions] object. It handles parsing various configuration options
     * for the map, such as camera position, zoom/pitch limits, pixel ratio, and boolean flags.
     *
     * @param context The Android [Context] used to create the base [MapLibreMapOptions].
     * @param args An optional [Map] containing key-value pairs representing the map's configuration.
     *             If null, default options are created from the context.
     *             The supported keys and their types are:
     *  - **camera**: A map representing camera position options. It should contain arguments as described in [CameraPositionArgsParser.parseArgs]
     *  - **minZoom**: The minimum zoom level.
     *  - **maxZoom**: The maximum zoom level.
     *  - **minPitch**: The minimum pitch angle.
     *  - **maxPitch**: The maximum pitch angle.
     *  - **pixelRatio**: The pixel ratio.
     *  - **textureMode**: Whether texture mode is enabled.
     *  - **debugActive**: Whether debug mode is active.
     *  - **crossSourceCollisions**: Whether cross-source collisions are enabled.
     *  - **renderSurfaceOnTop**: Whether the rendering surface should be on top.
     * @return A [MapLibreMapOptions] object configured with the provided arguments or default values.
     *
     * @see MapLibreMapOptions
     * @see CameraPositionArgsParser.parseArgs
     *
     * */
    fun parseArgs(context: Context, args: Map<*, *>?): MapLibreMapOptions {
        if (args == null) {
            return MapLibreMapOptions.createFromAttributes(context)
        }

        val options = MapLibreMapOptions.createFromAttributes(context)

        // Parse camera position if provided
        args["camera"]?.let { cameraArgs ->
            if (cameraArgs is Map<*, *>) {
                val cameraPosition = CameraPositionArgsParser.parseArgs(cameraArgs)
                options.camera(cameraPosition)
            }
        }

        // Parse zoom limits
        args["minZoom"]?.let {
            val minZoom = it.toString().toDoubleOrNull()
            if (minZoom != null) {
                options.minZoomPreference(minZoom)
            }
        }
        args["maxZoom"]?.let {
            val maxZoom = it.toString().toDoubleOrNull()
            if (maxZoom != null) {
                options.maxZoomPreference(maxZoom)
            }
        }

        // Parse pitch limits
        args["minPitch"]?.let {
            val minPitch = it.toString().toDoubleOrNull()
            if (minPitch != null) {
                options.minPitchPreference(minPitch)
            }
        }

        args["maxPitch"]?.let {
            val maxPitch = it.toString().toDoubleOrNull()
            if (maxPitch != null) {
                options.maxPitchPreference(maxPitch)
            }
        }

        // Parse pixel ratio
        args["pixelRatio"]?.let {
            val pixelRatio = it.toString().toFloatOrNull()
            if (pixelRatio != null) {
                options.pixelRatio(pixelRatio)
            }
        }

        // Parse boolean flags
        args["textureMode"]?.let {
            val textureMode = it.toString().toBooleanStrictOrNull()

            if (textureMode != null) {
                options.textureMode(textureMode)
            }
        }

        args["debugActive"]?.let {
            val debugActive = it.toString().toBooleanStrictOrNull()
            if (debugActive != null) {
                options.debugActive(debugActive)
            }
        }

        args["crossSourceCollisions"]?.let {
            val crossSourceCollisions = it.toString().toBooleanStrictOrNull()
            if (crossSourceCollisions != null) {
                options.crossSourceCollisions(crossSourceCollisions)
            }
        }

        args["renderSurfaceOnTop"]?.let {
            val renderSurfaceOnTop = it.toString().toBooleanStrictOrNull()
            if (renderSurfaceOnTop != null) {
                options.renderSurfaceOnTop(renderSurfaceOnTop)
            }
        }

        return options
    }
}