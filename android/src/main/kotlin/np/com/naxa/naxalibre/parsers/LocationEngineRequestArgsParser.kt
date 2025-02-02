package np.com.naxa.naxalibre.parsers

import org.maplibre.android.location.engine.LocationEngineRequest

/**
 * Object responsible for parsing arguments and building a `LocationEngineRequest.Builder`.
 *
 * This object provides a utility function, `fromArgs`, to create a `LocationEngineRequest.Builder`
 * instance from a map of parameters. It handles the parsing and validation of different
 * parameter types, providing sensible defaults when necessary.
 */
object LocationEngineRequestArgsParser {
    /**
     * Creates a `LocationEngineRequest.Builder` from a map of parameters.
     *
     * This function takes a map (`params`) containing key-value pairs representing
     * configuration options for a `LocationEngineRequest`. It extracts the
     * following parameters from the map, if present, and configures the builder
     * accordingly:
     *
     * - **interval**: The desired interval for active location updates, in milliseconds.
     *   - Accepts `Int`, `Long`, `Float`, or `Double` values.
     *   - Defaults to 750 milliseconds if not provided or if an error occurs during parsing.
     * - **priority**: The priority of the location request.
     *   - Accepts `Int`, `Long`, `Float`, or `Double` values.
     *   - Values are converted to Int before setting.
     * - **displacement**: The minimum displacement, in meters, that must occur before a location update is generated.
     *   - Accepts `Int`, `Long`, `Float`, or `Double` values.
     *   - Values are converted to Float before setting.
     * - **maxWaitTime**: The maximum wait time for location updates, in milliseconds.
     *   - Accepts `Int`, `Long`, `Float`, or `Double` values.
     *   - Values are converted to Long before setting.
     * - **fastestInterval**: The fastest rate at which your app can handle location updates, in milliseconds.
     *   - Accepts `Int`, `Long`, `Float`, or `Double` values.
     *   - Values are converted to Long before setting.
     *
     * If a parameter is not found in the map, the corresponding builder option will
     * not be set (except for `interval`, which has a default). If a parameter is found
     * but its value is of an incorrect type or cannot be parsed, a default value
     * may be used (for `interval`) or the parameter may be skipped.
     *
     * @param params A map of key-value pairs representing the configuration options.
     *               Keys should be strings ("interval", "priority", "displacement", "maxWaitTime", "fastestInterval")
     *               and values should be of the appropriate type as described above.
     * @return A `LocationEngineRequest.Builder` configured with the parameters
     *         found in the
     */
    fun fromArgs(params: Map<*, *>): LocationEngineRequest.Builder {

        val interval: Long = if (params.containsKey("interval")) {
            try {
                when (val interval = params["interval"]) {
                    is Int -> interval.toLong()
                    is Long -> interval
                    is Float -> interval.toLong()
                    is Double -> interval.toLong()
                    else -> 750
                }
            } catch (e: Exception) {
                750L
            }
        } else {
            750L
        }

        return LocationEngineRequest.Builder(interval).apply {
            if (params.containsKey("priority")) {
                try {
                    when (val priority = params["priority"]) {
                        is Int -> setPriority(priority)
                        is Long -> setPriority(priority.toInt())
                        is Float -> setPriority(priority.toInt())
                        is Double -> setPriority(priority.toInt())
                    }
                } catch (e: Exception) {
                    // Unable to set priority
                }
            }

            if (params.containsKey("displacement")) {
                try {
                    when (val displacement = params["displacement"]) {
                        is Int -> setDisplacement(displacement.toFloat())
                        is Long -> setDisplacement(displacement.toFloat())
                        is Float -> setDisplacement(displacement)
                        is Double -> setDisplacement(displacement.toFloat())
                    }
                } catch (e: Exception) {
                    // Unable to set displacement
                }
            }

            if (params.containsKey("maxWaitTime")) {
                try {
                    when (val time = params["maxWaitTime"]) {
                        is Int -> setMaxWaitTime(time.toLong())
                        is Long -> setMaxWaitTime(time)
                        is Float -> setMaxWaitTime(time.toLong())
                        is Double -> setMaxWaitTime(time.toLong())
                    }
                } catch (e: Exception) {
                    // Unable to set max wait time
                }
            }

            if (params.containsKey("fastestInterval")) {
                try {
                    when (val fastestInterval = params["fastestInterval"]) {
                        is Int -> setFastestInterval(fastestInterval.toLong())
                        is Long -> setFastestInterval(fastestInterval)
                        is Float -> setFastestInterval(fastestInterval.toLong())
                        is Double -> setFastestInterval(fastestInterval.toLong())
                    }
                } catch (e: Exception) {
                    // Unable to set fastest interval
                }
            }
        }
    }
}