package np.com.naxa.naxalibre.parsers

import org.maplibre.android.camera.CameraPosition
import org.maplibre.android.geometry.LatLng

/**
 * `CameraPositionArgsParser` is a utility object responsible for parsing a map of arguments
 * and constructing a `CameraPosition` object from them. It expects specific keys within the
 * map to represent camera properties such as target (latitude, longitude), zoom, bearing, tilt, and padding.
 *
 * This object provides a single method, [parseArgs], for parsing the arguments.
 */
object CameraPositionArgsParser {

    /**
     * Parses a map of arguments to construct a [CameraPosition].
     *
     * This function takes a map of arguments, potentially containing keys for "target", "zoom", "bearing", "tilt", and "padding".
     * It extracts these values, validates their types, and uses them to build a [CameraPosition] object.
     *
     * The expected structure of the arguments map is as follows:
     * - **target**: A `List<*>` representing latitude and longitude coordinates.
     *   - Example: `listOf(37.7749, -122.4194)` (San Francisco)
     *   - The list must contain exactly two numerical values (latitude, longitude) that can be parsed as Doubles.
     *   - If the list has not exactly two values or some values cannot be parsed as Double, it will be ignored.
     * - **zoom**: A numerical value representing the zoom level.
     *   - Example: `10.5`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **bearing**: A numerical value representing the camera's bearing (rotation).
     *   - Example: `45.0`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **tilt**: A numerical value representing the camera's tilt angle.
     *   - Example: `30.0`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **padding**: A `List<*>` representing the padding in pixels for the map view: `[left, top, right, bottom]`.
     *   - Example: `listOf(10.0, 20.0, 10.0, 20.0)`
     *   - The list must contain exactly four numerical values that can be parsed as Doubles.
     *   - If the list has not exactly four values or some values cannot be parsed as Double, it will be ignored.
     *
     */
    fun parseArgs(args: Map<*, *>?): CameraPosition {
        val target = args?.get("target") as List<*>?
        val zoom = args?.get("zoom")
        val bearing = args?.get("bearing")
        val tilt = args?.get("tilt")
        val padding = args?.get("padding") as List<*>?

        val builder = CameraPosition.Builder()


        if (target != null) {
            val targetAsDouble = target.mapNotNull { it.toString().toDoubleOrNull() }
            if (targetAsDouble.size >= 2) {
                val latLng = LatLng(targetAsDouble[0], targetAsDouble[1])
                builder.target(latLng)
            }

        }

        if (zoom != null) {
            val zoomAsDouble = zoom.toString().toDoubleOrNull()
            if (zoomAsDouble != null) {
                builder.zoom(zoomAsDouble)
            }
        }

        if (bearing != null) {
            val bearingAsDouble = bearing.toString().toDoubleOrNull()
            if (bearingAsDouble != null) {
                builder.bearing(bearingAsDouble)
            }
        }
        if (tilt != null) {
            val tiltAsDouble = tilt.toString().toDoubleOrNull()
            if (tiltAsDouble != null) {
                builder.tilt(tiltAsDouble)
            }
        }

        if (padding != null) {
            val paddingAsDouble = padding.mapNotNull { it.toString().toDoubleOrNull() }

            if (paddingAsDouble.size == 4) {
                builder.padding(
                    paddingAsDouble[0],
                    paddingAsDouble[1],
                    paddingAsDouble[2],
                    paddingAsDouble[3]
                )
            }
        }

        return builder.build()
    }
}