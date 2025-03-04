package com.itheamc.naxalibre.parsers

import android.graphics.PointF

/**
 * `UiSettingsArgsParser` provides utility functions and a data class for managing the UI settings of a map view.
 *
 * This object contains:
 * - `NaxaLibreUiSettings`: A data class that holds all customizable UI settings for the map.
 * - `parseUiSettings()`: A function to parse a map of settings into a `NaxaLibreUiSettings` object.
 * - `parseMargins()`: A private utility function to parse margin settings from a list.
 * - `parseFocalPoint()`: A private utility function to parse focal point settings from a list.
 */
object UiSettingsArgsParser {
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
        val attributionGravity: String? = null,
        val compassGravity: String? = null,
        val logoGravity: String? = null,
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
        val attributions: Map<String, String>? = null,
    )

    /**
     * Parses a map of key-value pairs into an instance of [NaxaLibreUiSettings].
     *
     * This function takes a map containing UI setting values and constructs a [NaxaLibreUiSettings] object.
     * It handles optional values by providing sensible defaults when a key is missing or the value is of an unexpected type.
     *
     * @param args A map where keys represent UI setting names and values represent their corresponding settings.
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
    fun parseArgs(args: Map<*, *>): NaxaLibreUiSettings {
        return NaxaLibreUiSettings(
            logoEnabled = args["logoEnabled"] as? Boolean ?: true,
            compassEnabled = args["compassEnabled"] as? Boolean ?: true,
            attributionEnabled = args["attributionEnabled"] as? Boolean ?: true,
            attributionGravity = args["attributionGravity"] as? String,
            compassGravity = args["compassGravity"] as? String,
            logoGravity = args["logoGravity"] as? String,
            logoMargins = parseMargins(args["logoMargins"]),
            compassMargins = parseMargins(args["compassMargins"]),
            attributionMargins = parseMargins(args["attributionMargins"]),
            rotateGesturesEnabled = args["rotateGesturesEnabled"] as? Boolean ?: true,
            tiltGesturesEnabled = args["tiltGesturesEnabled"] as? Boolean ?: true,
            zoomGesturesEnabled = args["zoomGesturesEnabled"] as? Boolean ?: true,
            scrollGesturesEnabled = args["scrollGesturesEnabled"] as? Boolean ?: true,
            horizontalScrollGesturesEnabled = args["horizontalScrollGesturesEnabled"] as? Boolean
                ?: true,
            doubleTapGesturesEnabled = args["doubleTapGesturesEnabled"] as? Boolean ?: true,
            quickZoomGesturesEnabled = args["quickZoomGesturesEnabled"] as? Boolean ?: true,
            scaleVelocityAnimationEnabled = args["scaleVelocityAnimationEnabled"] as? Boolean
                ?: true,
            rotateVelocityAnimationEnabled = args["rotateVelocityAnimationEnabled"] as? Boolean
                ?: true,
            flingVelocityAnimationEnabled = args["flingVelocityAnimationEnabled"] as? Boolean
                ?: true,
            increaseRotateThresholdWhenScaling = args["increaseRotateThresholdWhenScaling"] as? Boolean
                ?: true,
            disableRotateWhenScaling = args["disableRotateWhenScaling"] as? Boolean ?: true,
            fadeCompassWhenFacingNorth = args["fadeCompassWhenFacingNorth"] as? Boolean ?: true,
            focalPoint = parseFocalPoint(args["focalPoint"]),
            flingThreshold = args["flingThreshold"] as? Long,
            attributions = parseAttributions(args["attributions"] as? Map<*, *>)
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

    private fun parseAttributions(attributions: Map<*, *>?): Map<String, String> {
        return attributions?.mapKeys { it.key.toString() }
            ?.mapValues { it.value?.toString() ?: "" } ?: emptyMap()
    }
}