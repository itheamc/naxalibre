package com.itheamc.naxalibre.parsers

import androidx.core.graphics.toColorInt
import org.maplibre.android.location.LocationComponent
import org.maplibre.android.location.LocationComponentOptions

/**
 * Sets up the creation parameters for the [LocationComponentOptions.Builder] based on the provided map.
 *
 * This function iterates through a map of parameters and applies them to the
 * [LocationComponentOptions.Builder], allowing for dynamic configuration of the
 * location component's appearance and behavior.
 *
 * The function supports a variety of parameters, including:
 * - **pulseEnabled**: `Boolean` - Enables or disables the pulse animation.
 * - **pulseFadeEnabled**: `Boolean` - Enables or disables the pulse fade effect.
 * - **pulseColor**: `Int`, `Long`, `String` - Sets the color of the pulse.
 *   - `Int` or `Long` represent color as ARGB integer.
 *   - `String` represent color as Hexadecimal string (ex: "#RRGGBBAA").
 * - **pulseAlpha**: `Int`, `Long`, `Float` - Sets the alpha (transparency) of the pulse.
 *   - `Int` or `Long` will be converted to float.
 *   - `Float` is between 0.0f and 1.0f.
 * - **pulseSingleDuration**: `Int`, `Long`, `Float` - Sets the duration of a single pulse animation.
 *   - `Int` or `Long` will be converted to float.
 *   - `Float` is in milliseconds.
 * - **pulseMaxRadius**: `Int`, `Long`, `Float` - Sets the maximum radius of the pulse animation.
 *   - `Int` or `Long` will be converted to float.
 *   - `Float` is in pixels.
 * - **foregroundTintColor**: `Int`, `Long`, `String` - Sets the tint color of the foreground icon.
 *   - `Int` or `Long` represent color as ARGB integer.
 *   - `String` represent color as Hexadecimal string (ex: "#RRGGBBAA").
 */
fun LocationComponentOptions.Builder.setupArgs(params: Map<*, *>?): LocationComponentOptions.Builder {
    return this.apply {
        if (params != null) {
            if (params.containsKey("pulseEnabled") && params["pulseEnabled"] is Boolean) {
                pulseEnabled(params["pulseEnabled"] as Boolean)
            }

            if (params.containsKey("pulseFadeEnabled") && params["pulseFadeEnabled"] is Boolean) {
                pulseFadeEnabled(params["pulseFadeEnabled"] as Boolean)
            }

            if (params.containsKey("pulseColor")) {
                try {
                    when (val pulseColor = params["pulseColor"]) {
                        is Int -> pulseColor(pulseColor)
                        is Long -> pulseColor(pulseColor.toInt())
                        is String -> pulseColor(pulseColor.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set pulse color
                }
            }

            if (params.containsKey("pulseAlpha")) {
                try {
                    when (val pulseAlpha = params["pulseAlpha"]) {
                        is Int -> pulseAlpha(pulseAlpha.toFloat())
                        is Long -> pulseAlpha(pulseAlpha.toFloat())
                        is Float -> pulseAlpha(pulseAlpha)
                        is Double -> pulseAlpha(pulseAlpha.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set pulse alpha
                }
            }

            if (params.containsKey("pulseSingleDuration")) {
                try {
                    when (val duration = params["pulseSingleDuration"]) {
                        is Int -> pulseSingleDuration(duration.toFloat())
                        is Long -> pulseSingleDuration(duration.toFloat())
                        is Float -> pulseSingleDuration(duration)
                        is Double -> pulseSingleDuration(duration.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set pulse single duration
                }
            }

            if (params.containsKey("pulseMaxRadius")) {
                try {
                    when (val radius = params["pulseMaxRadius"]) {
                        is Int -> pulseMaxRadius(radius.toFloat())
                        is Long -> pulseMaxRadius(radius.toFloat())
                        is Float -> pulseMaxRadius(radius)
                        is Double -> pulseMaxRadius(radius.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set pulse fade duration
                }
            }

            if (params.containsKey("foregroundTintColor")) {
                try {
                    when (val foreground = params["foregroundTintColor"]) {
                        is Int -> foregroundTintColor(foreground)
                        is Long -> foregroundTintColor(foreground.toInt())
                        is String -> foregroundTintColor(foreground.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set foreground tint color
                }
            }

            if (params.containsKey("foregroundStaleTintColor")) {
                try {
                    when (val foreground = params["foregroundStaleTintColor"]) {
                        is Int -> foregroundStaleTintColor(foreground)
                        is Long -> foregroundStaleTintColor(foreground.toInt())
                        is String -> foregroundStaleTintColor(foreground.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set foreground stale tint color
                }
            }

            if (params.containsKey("backgroundTintColor")) {
                try {
                    when (val backgroundTintColor = params["backgroundTintColor"]) {
                        is Int -> backgroundTintColor(backgroundTintColor)
                        is Long -> backgroundTintColor(backgroundTintColor.toInt())
                        is String -> backgroundTintColor(backgroundTintColor.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set background tint color
                }
            }

            if (params.containsKey("backgroundStaleTintColor")) {
                try {
                    when (val backgroundStaleTintColor = params["backgroundStaleTintColor"]) {
                        is Int -> backgroundStaleTintColor(backgroundStaleTintColor)
                        is Long -> backgroundStaleTintColor(backgroundStaleTintColor.toInt())
                        is String -> backgroundStaleTintColor(backgroundStaleTintColor.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set background stale tint color
                }
            }

            if (params.containsKey("accuracyAnimationEnabled") && params["accuracyAnimationEnabled"] is Boolean) {
                accuracyAnimationEnabled(params["accuracyAnimationEnabled"] as Boolean)
            }

            if (params.containsKey("accuracyColor")) {
                try {
                    when (val accuracyColor = params["accuracyColor"]) {
                        is Int -> accuracyColor(accuracyColor)
                        is Long -> accuracyColor(accuracyColor.toInt())
                        is String -> accuracyColor(accuracyColor.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set accuracy color
                }
            }

            if (params.containsKey("accuracyAlpha")) {
                try {
                    when (val accuracyAlpha = params["accuracyAlpha"]) {
                        is Int -> accuracyAlpha(accuracyAlpha.toFloat())
                        is Long -> accuracyAlpha(accuracyAlpha.toFloat())
                        is Float -> accuracyAlpha(accuracyAlpha)
                        is Double -> accuracyAlpha(accuracyAlpha.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set accuracy alpha
                }
            }

            if (params.containsKey("bearingTintColor")) {
                try {
                    when (val bearingTintColor = params["bearingTintColor"]) {
                        is Int -> bearingTintColor(bearingTintColor)
                        is Long -> bearingTintColor(bearingTintColor.toInt())
                        is String -> bearingTintColor(bearingTintColor.toColorInt())
                    }
                } catch (e: Exception) {
                    // Unable to set bearing tint color
                }
            }

            if (params.containsKey("compassAnimationEnabled") && params["compassAnimationEnabled"] is Boolean) {
                compassAnimationEnabled(params["compassAnimationEnabled"] as Boolean)
            }

            if (params.containsKey("elevation")) {
                try {
                    when (val elevation = params["elevation"]) {
                        is Int -> elevation(elevation.toFloat())
                        is Long -> elevation(elevation.toFloat())
                        is Float -> elevation(elevation)
                        is Double -> elevation(elevation.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set elevation
                }
            }

            if (params.containsKey("maxZoomIconScale")) {
                try {
                    when (val maxZoomIconScale = params["maxZoomIconScale"]) {
                        is Int -> maxZoomIconScale(maxZoomIconScale.toFloat())
                        is Long -> maxZoomIconScale(maxZoomIconScale.toFloat())
                        is Float -> maxZoomIconScale(maxZoomIconScale)
                        is Double -> maxZoomIconScale(maxZoomIconScale.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set maxZoomIconScale
                }
            }

            if (params.containsKey("minZoomIconScale")) {
                try {
                    when (val minZoomIconScale = params["minZoomIconScale"]) {
                        is Int -> minZoomIconScale(minZoomIconScale.toFloat())
                        is Long -> minZoomIconScale(minZoomIconScale.toFloat())
                        is Float -> minZoomIconScale(minZoomIconScale)
                        is Double -> minZoomIconScale(minZoomIconScale.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set minZoomIconScale
                }
            }

            if (params.containsKey("layerAbove") && params["layerAbove"] is String) {
                layerAbove(params["layerAbove"] as String)
            }

            if (params.containsKey("layerBelow") && params["layerBelow"] is String) {
                layerBelow(params["layerBelow"] as String)
            }
        }
    }
}


fun LocationComponent.setupArgs(params: Map<*, *>?) {
    apply {
        if (params?.containsKey("cameraMode") == true) {
            try {
                when (val mode = params["cameraMode"]) {
                    is Int -> mode
                    is Long -> mode.toInt()
                    is Float -> mode.toInt()
                    is Double -> mode.toInt()
                    else -> null
                }?.let {
                    cameraMode = it
                }
            } catch (e: Exception) {
                // Unable to set camera mode
            }
        }

        if (params?.containsKey("renderMode") == true) {
            try {
                when (val mode = params["renderMode"]) {
                    is Int -> mode
                    is Long -> mode.toInt()
                    is Float -> mode.toInt()
                    is Double -> mode.toInt()
                    else -> null
                }?.let {
                    renderMode = it
                }
            } catch (e: Exception) {
                // Unable to set render mode
            }
        }

        if (params?.containsKey("maxAnimationFps") == true) {
            try {
                when (val fps = params["maxAnimationFps"]) {
                    is Int -> fps
                    is Long -> fps.toInt()
                    is Float -> fps.toInt()
                    is Double -> fps.toInt()
                    else -> null
                }?.let {
                    setMaxAnimationFps(it)
                }
            } catch (e: Exception) {
                // Unable to set max animation fps
            }
        }

        if (params?.containsKey("tiltWhileTracking") == true) {
            try {
                when (val tilt = params["tiltWhileTracking"]) {
                    is Int -> tilt.toDouble()
                    is Long -> tilt.toDouble()
                    is Float -> tilt.toDouble()
                    is Double -> tilt
                    else -> null
                }?.let {
                    tiltWhileTracking(it)
                }
            } catch (e: Exception) {
                // Unable to set tilt while tracking
            }
        }

        if (params?.containsKey("zoomWhileTracking") == true) {
            try {
                when (val zoom = params["zoomWhileTracking"]) {
                    is Int -> zoom.toDouble()
                    is Long -> zoom.toDouble()
                    is Float -> zoom.toDouble()
                    is Double -> zoom
                    else -> null
                }?.let {
                    zoomWhileTracking(it)
                }
            } catch (e: Exception) {
                // Unable to set zoom while tracking
            }
        }
    }
}