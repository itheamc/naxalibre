package com.itheamc.naxalibre.parsers

import org.maplibre.android.camera.CameraUpdate
import org.maplibre.android.camera.CameraUpdateFactory
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds

/**
 * `CameraUpdateArgsParser` is a utility object that provides functions for creating `CameraUpdate` objects
 * from various input arguments, primarily designed for handling camera updates from method calls or
 * other external sources.
 */
object CameraUpdateArgsParser {

    /**
     * Converts a Map argument to a CameraUpdate object.
     */
    fun parseArgs(args: Map<String, Any?>): CameraUpdate {
        when (val type = args["type"] as String?) {
            "newCameraPosition" -> {
                val cameraPositionArgs = args["camera_position"] as Map<*, *>
                val cameraPosition = CameraPositionArgsParser.parseArgs(cameraPositionArgs)
                return CameraUpdateFactory.newCameraPosition(cameraPosition)
            }

            "newLatLng" -> {
                val latLng = args["latLng"] as List<*>
                val lat = latLng[0] as Double
                val lng = latLng[1] as Double
                return CameraUpdateFactory.newLatLng(LatLng(lat, lng))
            }

            "newLatLngBounds" -> {
                val bounds = args["bounds"] as Map<*, *>
                val northEast = bounds["northeast"] as List<*>
                val southWest = bounds["southwest"] as List<*>
                val padding = bounds["padding"] as Double?
                val bearing = bounds["bearing"] as Double?
                val tilt = bounds["tilt"] as Double?

                val latLngBounds = LatLngBounds.fromLatLngs(
                    listOf(
                        LatLng(southWest[0] as Double, southWest[1] as Double),
                        LatLng(northEast[0] as Double, northEast[1] as Double)
                    )
                )
                return CameraUpdateFactory.newLatLngBounds(
                    latLngBounds,
                    bearing = bearing ?: 0.0,
                    tilt = tilt ?: 0.0,
                    padding = padding?.toInt() ?: 0,
                )
            }

            "zoomTo" -> {
                val zoom = args["zoom"] as Double
                return CameraUpdateFactory.zoomTo(zoom)
            }

            "zoomBy" -> {
                val zoom = args["zoom"] as Double
                return CameraUpdateFactory.zoomBy(zoom)
            }

            else -> {
                throw IllegalArgumentException("Invalid camera update type: $type")
            }
        }

    }
}