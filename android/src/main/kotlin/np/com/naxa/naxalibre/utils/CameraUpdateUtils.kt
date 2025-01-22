package np.com.naxa.naxalibre.utils

import org.maplibre.android.camera.CameraPosition
import org.maplibre.android.camera.CameraUpdate
import org.maplibre.android.camera.CameraUpdateFactory
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds

object CameraUpdateUtils {

    /**
     * Converts a Map argument to a CameraUpdate object.
     */
    fun cameraUpdateFromArgs(args: Map<String, Any?>): CameraUpdate {
        when (val type = args["type"] as String?) {
            "newCameraPosition" -> {
                val cameraPositionArgs = args["camera_position"] as Map<*, *>
                val bearing = cameraPositionArgs["bearing"] as Double?
                val target = cameraPositionArgs["target"] as List<*>?
                val tilt = cameraPositionArgs["tilt"] as Double?
                val zoom = cameraPositionArgs["zoom"] as Double?
                val padding = cameraPositionArgs["padding"] as List<*>?


                val builder = CameraPosition.Builder()

                if (target != null) {
                    val latLng = LatLng(target[0] as Double, target[1] as Double)
                    builder.target(latLng)
                }

                if (zoom != null) {
                    builder.zoom(zoom)
                }

                if (bearing != null) {
                    builder.bearing(bearing)
                }
                if (tilt != null) {
                    builder.tilt(tilt)
                }

                if (padding != null && padding.size == 4 && padding.all { it is Double }) {
                    builder.padding(
                        padding[0] as Double,
                        padding[1] as Double,
                        padding[2] as Double,
                        padding[3] as Double
                    )
                }

                val cameraPosition = builder.build()

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