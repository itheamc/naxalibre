package np.com.naxa.naxalibre.utils

import android.graphics.Color
import android.graphics.PointF

/**
 * `UiSettingsUtils` provides utility functions and a data class for managing the UI settings of a map view.
 *
 * This object contains:
 * - `NaxaLibreUiSettings`: A data class that holds all customizable UI settings for the map.
 * - `parseUiSettings()`: A function to parse a map of settings into a `NaxaLibreUiSettings` object.
 * - `parseMargins()`: A private utility function to parse margin settings from a list.
 * - `parseFocalPoint()`: A private utility function to parse focal point settings from a list.
 */
object UiSettingsUtils {
    /**
     * Represents the UI settings for the Naxa Libre map.
     *
     * This data class provides a comprehensive set of options to customize the appearance and behavior
     * of the map's user interface elements, such as the logo, compass, attribution, and various gesture controls.
     *
     */
    data class NaxaLibreUiSettings(
        val logoEnabled: Boolean = true,
        val compassEnabled: Boolean = true,
        val attributionEnabled: Boolean = true,
        val attributionGravity: Long? = null,
        val compassGravity: Long? = null,
        val logoGravity: Long? = null,
        val logoMargins: List<Int>? = null,
        val compassMargins: List<Int>? = null,
        val attributionMargins: List<Int>? = null,
        val rotateGesturesEnabled: Boolean = true,
        val tiltGesturesEnabled: Boolean = true,
        val zoomGesturesEnabled: Boolean = true,
        val scrollGesturesEnabled: Boolean = true,
        val horizontalScrollGesturesEnabled: Boolean = true,
        val doubleTapGesturesEnabled: Boolean = true,
        val quickZoomGesturesEnabled: Boolean = true,
        val scaleVelocityAnimationEnabled: Boolean = true,
        val rotateVelocityAnimationEnabled: Boolean = true,
        val flingVelocityAnimationEnabled: Boolean = true,
        val increaseRotateThresholdWhenScaling: Boolean = true,
        val disableRotateWhenScaling: Boolean = true,
        val fadeCompassWhenFacingNorth: Boolean = true,
        val focalPoint: PointF? = null,
        val flingThreshold: Long? = null,
    ) {
        /**
         * Companion object for the class (presumably a class holding UI settings).
         *
         * Provides utility functions for working with the class, such as creating instances from maps.
         */
        companion object {
            /**
             * Parses a map of key-value pairs into a UiSettings object.
             *
             * This function takes a generic map as input and delegates the parsing to the `parseUiSettings` function.
             * It's essentially a convenience wrapper to handle the initial map input.
             *
             * @param map The map to parse. The keys and values within the map should represent
             *            settings and their corresponding values that can be interpreted by `parseUiSettings`.
             * @return A UiSettings object constructed from the map data.
             */
            fun fromMap(map: Map<*, *>) = parseUiSettings(map)
        }
    }

    /**
     * Parses a map of key-value pairs into an instance of [NaxaLibreUiSettings].
     *
     * This function takes a map containing UI setting values and constructs a [NaxaLibreUiSettings] object.
     * It handles optional values by providing sensible defaults when a key is missing or the value is of an unexpected type.
     *
     * @param map A map where keys represent UI setting names and values represent their corresponding settings.
     *            The expected keys and value types are:
     *            - "logoEnabled": Boolean (default: true) - Enables/disables the logo.
     *            - "compassEnabled": Boolean (default: true) - Enables/disables the compass.
     *            - "attributionEnabled": Boolean (default: true) - Enables/disables the attribution.
     *            - "attributionGravity": Int - Gravity of the attribution (e.g., Gravity.BOTTOM|Gravity.END).
     *            - "compassGravity": Int - Gravity of the compass.
     *            - "logoGravity": Int - Gravity of the logo.
     *            - "logoMargins": Map<*, *> (parsed by parseMargins) - Margins for the logo.
     *            - "compassMargins": Map<*, *> (parsed by parseMargins) - Margins for the compass.
     *            - "attributionMargins": Map<*, *> (parsed by parseMargins) - Margins for the attribution.
     *            - "rotateGesturesEnabled": Boolean (default: true) - Enables/disables rotation gestures.
     *            - "tiltGesturesEnabled": Boolean (default: true) - Enables/disables tilt gestures.
     *            - "zoomGesturesEnabled": Boolean (default: true) - Enables/disables zoom gestures.
     *            - "scrollGesturesEnabled": Boolean (default: true) - Enables/disables scroll gestures.
     *            - "horizontalScrollGesturesEnabled": Boolean (default: true) - Enables/disables horizontal scroll gestures.
     *            - "doubleTapGesturesEnabled": Boolean (default: true) - Enables/disables double-tap gestures.
     *            - "quickZoomGesturesEnabled": Boolean (default: true) - Enables/disables quick zoom gestures.
     *            - "scaleVelocityAnimationEnabled": Boolean (default: true) - Enables/disables scale
     *
     */
    fun parseUiSettings(map: Map<*, *>): NaxaLibreUiSettings {
        return NaxaLibreUiSettings(
            logoEnabled = map["logoEnabled"] as? Boolean ?: true,
            compassEnabled = map["compassEnabled"] as? Boolean ?: true,
            attributionEnabled = map["attributionEnabled"] as? Boolean ?: true,
            attributionGravity = map["attributionGravity"] as? Long,
            compassGravity = map["compassGravity"] as? Long,
            logoGravity = map["logoGravity"] as? Long,
            logoMargins = parseMargins(map["logoMargins"]),
            compassMargins = parseMargins(map["compassMargins"]),
            attributionMargins = parseMargins(map["attributionMargins"]),
            rotateGesturesEnabled = map["rotateGesturesEnabled"] as? Boolean ?: true,
            tiltGesturesEnabled = map["tiltGesturesEnabled"] as? Boolean ?: true,
            zoomGesturesEnabled = map["zoomGesturesEnabled"] as? Boolean ?: true,
            scrollGesturesEnabled = map["scrollGesturesEnabled"] as? Boolean ?: true,
            horizontalScrollGesturesEnabled = map["horizontalScrollGesturesEnabled"] as? Boolean
                ?: true,
            doubleTapGesturesEnabled = map["doubleTapGesturesEnabled"] as? Boolean ?: true,
            quickZoomGesturesEnabled = map["quickZoomGesturesEnabled"] as? Boolean ?: true,
            scaleVelocityAnimationEnabled = map["scaleVelocityAnimationEnabled"] as? Boolean
                ?: true,
            rotateVelocityAnimationEnabled = map["rotateVelocityAnimationEnabled"] as? Boolean
                ?: true,
            flingVelocityAnimationEnabled = map["flingVelocityAnimationEnabled"] as? Boolean
                ?: true,
            increaseRotateThresholdWhenScaling = map["increaseRotateThresholdWhenScaling"] as? Boolean
                ?: true,
            disableRotateWhenScaling = map["disableRotateWhenScaling"] as? Boolean ?: true,
            fadeCompassWhenFacingNorth = map["fadeCompassWhenFacingNorth"] as? Boolean ?: true,
            focalPoint = parseFocalPoint(map["focalPoint"]),
            flingThreshold = map["flingThreshold"] as? Long,
        )
    }

    /**
     * Parses a list of margins from an input object.
     *
     * This function attempts to parse a list of four numerical margin values (top, right, bottom, left)
     * from the given input object.
     *
     * @param margins The input object that potentially contains a list of margin values.
     * It is expected to be a `List` of four elements. Each element should be convertible to a `Double`.
     *
     * @return A `List<Double>` representing the parsed margin values (top, right, bottom, left) if:
     *   - The input `margins` is a `List`.
     *   - The `margins` list has exactly four elements.
     *   - Each element in the list can be successfully converted to a `Double`.
     *   If any of these conditions are not met, `null` is returned.
     *
     *   If an element cannot be converted to a `Double`, it defaults to `0.0`.
     *
     */
    private fun parseMargins(margins: Any?): List<Int>? {
        return if (margins is List<*> && margins.size == 4) {
            margins.map { it?.toString()?.toInt() ?: 0 }
        } else null
    }

    /**
     * Parses a focal point from a generic object.
     *
     * This function attempts to extract a focal point represented as a list of two numbers (x, y)
     * from the provided input. If the input is a List of size 2, it attempts to convert the first
     * two elements to floats, representing the x and y coordinates of the focal point respectively.
     * If the conversion fails or the input is not a list of size 2, it returns null.
     *
     * @param focalPoint The object to parse as a focal point. It's expected to be a List<*>
     *                   where the list contains two elements that can be converted to floats.
     * @return A PointF object representing the parsed focal point, or null if the input is
     *         invalid or cannot be parsed.
     *
     * @throws NumberFormatException if either element in the list cannot be parsed as a Float.
     *
     */
    private fun parseFocalPoint(focalPoint: Any?): PointF? {
        if (focalPoint is List<*> && focalPoint.size == 2) {
            return PointF(
                focalPoint[0]?.toString()?.toFloat() ?: 0f,
                focalPoint[1]?.toString()?.toFloat() ?: 0f
            )
        }
        return null
    }
}