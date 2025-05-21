package com.itheamc.naxalibre

import NaxaLibreHostApi
import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.PointF
import android.graphics.RectF
import android.util.Log
import android.view.Gravity
import androidx.core.app.ActivityCompat
import com.itheamc.naxalibre.parsers.CameraUpdateArgsParser
import com.itheamc.naxalibre.parsers.LayerArgsParser
import com.itheamc.naxalibre.parsers.LocationEngineRequestArgsParser
import com.itheamc.naxalibre.parsers.SourceArgsParser
import com.itheamc.naxalibre.parsers.UiSettingsArgsParser
import com.itheamc.naxalibre.parsers.setupArgs
import com.itheamc.naxalibre.utils.ImageUtils
import com.itheamc.naxalibre.utils.JsonUtils
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import org.maplibre.android.camera.CameraUpdateFactory
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds
import org.maplibre.android.geometry.ProjectedMeters
import org.maplibre.android.location.LocationComponentActivationOptions
import org.maplibre.android.location.LocationComponentOptions
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.maps.MapView
import org.maplibre.android.style.expressions.Expression
import org.maplibre.android.style.sources.GeoJsonSource
import java.net.URI


/**
 * Controller for managing the MapLibre GL native map within a Flutter application.
 *
 * This class acts as the primary interface between the Flutter application and the
 * underlying MapLibre GL native map. It handles communication, data transfer, and
 * exposes various functionalities for interacting with the map.
 *
 * @param binaryMessenger The binary messenger used for communication with Flutter.
 * @param activity The current activity instance.
 * @param libreView The MapView instance.
 * @param libreMap The MapLibreMap instance.
 * @param creationParams Optional parameters passed from Flutter during view creation. These can include settings for the map.
 * @param activityPluginBinding The ActivityPluginBinding instance. It helps us to register request permissions result listeners.
 */
class NaxaLibreController(
    private val binaryMessenger: BinaryMessenger,
    private val activity: Activity,
    private val libreView: MapView,
    private val libreMap: MapLibreMap,
    private val creationParams: Map<*, *>?,
    private val activityPluginBinding: () -> ActivityPluginBinding?
) : NaxaLibreHostApi, PluginRegistry.RequestPermissionsResultListener {


    /**
     * A collection of listeners for events related to the Libre sensor and associated data.
     *
     * This property provides access to a set of callbacks that can be registered to receive
     * notifications about various Libre-related events, such as sensor readings, connection status
     * changes, and other relevant updates. These listeners are managed and dispatched by the
     * [NaxaLibreListeners] class.
     *
     * The listeners are lazily initialized, meaning they are created only when first accessed. This
     * helps to avoid unnecessary object creation and resource consumption if no listeners are ever
     * registered.
     *
     * @see NaxaLibreListeners For the full set of available listeners and their functionalities.
     * @see BinaryMessenger Used for communicating between Flutter and native code.
     * @see libreView A view component associated with the Libre sensor (if applicable).
     * @see libreMap A map component associated with the Libre sensor (if applicable).
     */
    val libreListeners by lazy {
        NaxaLibreListeners(
            binaryMessenger,
            libreView,
            libreMap,
            libreAnnotationsManager
        )
    }

    /**
     * Provides access to the NaxaLibre offline management functionality.
     *
     * This property lazily initializes an instance of [NaxaLibreOfflineManager], which is responsible
     * for managing offline map data within the application. It uses the provided [BinaryMessenger] to
     * communicate with the Flutter side, the [Activity] to access Android-specific resources, and the
     * [libreMap] instance to interact with the map itself.
     *
     * The instance is created only when it is first accessed, ensuring that resources are not consumed
     * until they are actually needed. Subsequent accesses will return the same instance.
     *
     * @see NaxaLibreOfflineManager
     * @see BinaryMessenger
     * @see Activity
     * @see libreMap
     */
    val libreOfflineManager by lazy { NaxaLibreOfflineManager(binaryMessenger, activity, libreMap) }

    /**
     * [libreAnnotationsManager] is a lazy-initialized property that provides an instance of [NaxaLibreAnnotationsManager].
     *
     * This manager is responsible for handling the creation, modification, and management of annotations
     * (e.g., markers, polygons, polylines) on the map.
     *
     * The manager requires several dependencies to function:
     *   - [libreView]: The underlying view associated with Libre. (Replace 'Any' type with the correct one).
     *   - [libreMap]: The [MapView] from osmdroid on which the annotations will be displayed.
     *
     * The lazy initialization ensures that the [NaxaLibreAnnotationsManager] is only created when it's first accessed,
     * optimizing performance by avoiding unnecessary object creation.
     */
    private val libreAnnotationsManager by lazy {
        NaxaLibreAnnotationsManager(
            libreView,
            libreMap
        )
    }

    /**
     * Initializes the NaxaLibreHostApi and sets up communication between the native and Flutter sides.
     *
     * This method initializes the NaxaLibreHostApi and sets it up to handle method calls from Flutter.
     * It also passes an instance of NaxaLibreController as the implementation to handle the calls.
     *
     * The binary messenger used for communication with Flutter.
     *
     */
    init {
        NaxaLibreHostApi.setUp(binaryMessenger, this)

        activityPluginBinding.invoke()?.addRequestPermissionsResultListener(this)

        if (!creationParams.isNullOrEmpty()) {
            val styleUrl = creationParams["styleUrl"] as? String
                ?: "https://demotiles.maplibre.org/style.json"

            libreMap.setStyle(styleUrl) {
                handleCreationParams()
            }
        }
    }

    /**
     * These are the methods that are invoked by the Flutter portion of the application.
     *
     * These methods facilitate communication and functionality sharing between the Flutter UI
     * and the native Android code.
     *
     */

    /**
     * Converts a screen location to geographical coordinates.
     *
     * @param point A list representing the x and y coordinates of the screen location.
     * @return A list containing the latitude and longitude of the corresponding geographical location.
     */
    override fun fromScreenLocation(point: List<Double>): List<Double> {
        val latLng =
            libreMap.projection.fromScreenLocation(
                PointF(
                    point.first().toFloat(),
                    point.last().toFloat()
                )
            )
        return listOf(latLng.latitude, latLng.longitude)
    }

    /**
     * Converts a list of screen locations to geographical coordinates.
     *
     * This function takes a list of screen points, where each point is represented by a list of
     * two doubles (x and y coordinates). It then iterates through these points, converting each
     * screen location to its corresponding geographical coordinates (latitude and longitude) using
     * the map's projection. The result is a list of lists, where each inner list contains the
     * latitude and longitude of the converted point.
     *
     * @param points A list of screen locations, where each location is a list of two doubles (x, y).
     * @param callback A callback function that receives the result.
     *
     */
    override fun fromScreenLocations(
        points: List<List<Double>>,
        callback: (Result<List<List<Any?>>>) -> Unit
    ) {
        try {

            if (points.isEmpty()) {
                callback(Result.success(listOf()))
                return
            }

            val inputArray = points.flatten().toDoubleArray()
            val outputArray = DoubleArray(inputArray.size)

            libreMap.projection.fromScreenLocations(inputArray, outputArray)

            callback(Result.success(outputArray.toList().chunked(2)))

        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Converts geographical coordinates to a screen location.
     * @param latLng A list containing the latitude and longitude.
     * @return A list containing the x and y coordinates of the corresponding screen location.
     */
    override fun toScreenLocation(latLng: List<Double>): List<Double> {
        val screenLocation =
            libreMap.projection.toScreenLocation(LatLng(latLng[0], latLng[1]))
        return listOf(screenLocation.x.toDouble(), screenLocation.y.toDouble())
    }

    /**
     * Converts a list of geographic coordinates (latitude and longitude) to screen locations (x and y coordinates).
     *
     * This function takes a list of lists, where each inner list contains a latitude and longitude pair.
     * It iterates through the input list and, for each pair, converts the geographic coordinates
     * to screen coordinates using the map's projection. The resulting screen coordinates (x, y)
     * are then added to a new list. Finally, the list of screen coordinates is passed to the
     * provided callback function.
     *
     * @param listOfLatLng A list of lists, where each inner list represents a geographic coordinate
     *                     pair [latitude, longitude].
     * @param callback A lambda function that will be invoked with the result of the conversion.
     *                 The result is a `Result` object, which either contains a list of screen
     *                 coordinates (x, y) on success or an exception on failure.
     */
    override fun toScreenLocations(
        listOfLatLng: List<List<Double>>,
        callback: (Result<List<List<Any?>>>) -> Unit
    ) {
        try {

            if (listOfLatLng.isEmpty()) {
                callback(Result.success(listOf()))
                return
            }

            val inputArray = listOfLatLng.flatten().toDoubleArray()
            val outputArray = DoubleArray(inputArray.size)

            libreMap.projection.toScreenLocations(inputArray, outputArray)

            callback(Result.success(outputArray.toList().chunked(2)))

        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Retrieves the geographical coordinates for a given set of projected meters.
     *
     * @param northing The northing component of the projected meters.
     * @param easting The easting component of the projected meters.
     * @return A list containing the latitude and longitude of the corresponding geographical location.
     */
    override fun getLatLngForProjectedMeters(northing: Double, easting: Double): List<Double> {
        val projectedMeters = ProjectedMeters(northing, easting)
        val latLng = libreMap.projection.getLatLngForProjectedMeters(projectedMeters)
        return listOf(latLng.latitude, latLng.longitude)
    }

    /**
     * Retrieves the visible geographical region of the map.
     *
     * @param ignorePadding Boolean to indicate whether to ignore padding.
     * @return A list of lists, each inner list representing a corner of the visible region (farLeft, farRight, nearLeft, nearRight), with latitude and longitude.
     */
    override fun getVisibleRegion(ignorePadding: Boolean): List<List<Double>> {
        val visibleRegion = libreMap.projection.getVisibleRegion(ignorePadding)
        return listOf(
            listOf(visibleRegion.farLeft!!.latitude, visibleRegion.farLeft!!.longitude),
            listOf(visibleRegion.farRight!!.latitude, visibleRegion.farRight!!.longitude),
            listOf(visibleRegion.nearLeft!!.latitude, visibleRegion.nearLeft!!.longitude),
            listOf(visibleRegion.nearRight!!.latitude, visibleRegion.nearRight!!.longitude)
        )
    }

    /**
     * Gets the projected meters for given geographical coordinates.
     *
     * @param latLng A list containing the latitude and longitude.
     * @return A list containing the easting and northing components of the projected meters.
     */
    override fun getProjectedMetersForLatLng(latLng: List<Double>): List<Double> {
        val projectedMeters =
            libreMap.projection.getProjectedMetersForLatLng(LatLng(latLng[0], latLng[1]))
        return listOf(projectedMeters.easting, projectedMeters.northing)
    }

    /**
     * Retrieves the current camera position of the map.
     *
     * @return A map containing the camera's bearing, target, tilt, zoom, and padding.
     */
    override fun getCameraPosition(): Map<String, Any> {
        val position = libreMap.cameraPosition
        return mapOf(
            "bearing" to position.bearing,
            "target" to listOf(position.target?.longitude, position.target?.latitude),
            "tilt" to position.tilt,
            "zoom" to position.zoom,
            "padding" to listOf(position.padding)
        )
    }

    /**
     * Retrieves the current zoom level of the map.
     *
     * @return The current zoom level.
     */
    override fun getZoom(): Double {
        return libreMap.cameraPosition.zoom
    }

    /**
     * Retrieves the height of the map view.
     *
     * @return The height of the map view in pixels.
     */
    override fun getHeight(): Double {
        return libreMap.height.toDouble()

    }

    /**
     * Retrieves the width of the map view.
     *
     * @return The width of the map view in pixels.
     */
    override fun getWidth(): Double {
        return libreMap.width.toDouble()

    }

    /**
     * Retrieves the minimum zoom level allowed on the map.
     *
     * @return The minimum zoom level.
     */
    override fun getMinimumZoom(): Double {
        return libreMap.minZoomLevel
    }

    /**
     * Retrieves the maximum zoom level allowed on the map.
     *
     * @return The maximum zoom level.
     */
    override fun getMaximumZoom(): Double {
        return libreMap.maxZoomLevel
    }

    /**
     * Retrieves the minimum pitch (tilt) allowed on the map.
     *
     * @return The minimum pitch angle in degrees.
     */
    override fun getMinimumPitch(): Double {
        return libreMap.minPitch
    }

    /**
     * Retrieves the maximum pitch (tilt) allowed on the map.
     *
     * @return The maximum pitch angle in degrees.
     */
    override fun getMaximumPitch(): Double {
        return libreMap.maxPitch
    }

    /**
     * Retrieves the pixel ratio of the map view.
     *
     * @return The pixel ratio.
     */
    override fun getPixelRatio(): Double {
        return libreView.pixelRatio.toDouble()
    }

    /**
     * Checks if the map view is destroyed.
     *
     * @return True if the map view is destroyed, false otherwise.
     */
    override fun isDestroyed(): Boolean {
        return libreView.isDestroyed
    }

    /**
     * Sets the maximum frames per second (FPS) that the map view can render.
     *
     * @param fps The desired maximum FPS value.
     */
    override fun setMaximumFps(fps: Long) {
        libreView.setMaximumFps(fps.toInt())
    }

    /**
     * Sets the style of the map using a style URI or JSON.
     *
     * @param style The style URI or JSON string.
     */
    override fun setStyle(style: String) {
        libreMap.setStyle(style)
    }

    /**
     * Sets the swap behavior to flush or not.
     *
     * @param flush True to enable flush, false to disable.
     */
    override fun setSwapBehaviorFlush(flush: Boolean) {
        libreMap.setSwapBehaviorFlush(flush)
    }

    /**
     * Enables or disables all gestures on the map.
     *
     * This method provides a global control over all user interactions with the map,
     * such as panning, zooming, rotating, and tilting.
     *
     * @param enabled `true` to enable all gestures, `false` to disable them.
     */
    override fun setAllGesturesEnabled(enabled: Boolean) {
        libreView.isClickable = enabled
        libreView.isLongClickable = enabled
        libreView.isFocusable = enabled
        libreMap.uiSettings.setAllGesturesEnabled(enabled)
    }

    /**
     * Animates the camera to a new position defined by the given arguments.
     *
     * @param args A map containing the camera update arguments.
     */
    override fun animateCamera(args: Map<String, Any?>) {
        val cameraUpdate = CameraUpdateArgsParser.parseArgs(args)
        val duration = args["duration"] as Long?
        if (duration == null) libreMap.animateCamera(cameraUpdate)
        else libreMap.animateCamera(cameraUpdate, duration.toInt())
    }

    /**
     * Eases the camera to a new position defined by the given arguments.
     * @param args A map containing the camera update arguments.
     */
    override fun easeCamera(args: Map<String, Any?>) {
        val cameraUpdate = CameraUpdateArgsParser.parseArgs(args)
        val duration = args["duration"] as Long?
        if (duration == null) libreMap.easeCamera(cameraUpdate)
        else libreMap.easeCamera(cameraUpdate, duration.toInt())
    }

    /**
     * Zooms the camera by a specified amount.
     * @param by The amount to zoom by.
     */
    override fun zoomBy(by: Double) {
        val cameraUpdate = CameraUpdateFactory.zoomBy(by)
        libreMap.animateCamera(cameraUpdate)
    }

    /**
     * Zooms the camera in by one level.
     */
    override fun zoomIn() {
        val cameraUpdate = CameraUpdateFactory.zoomIn()
        libreMap.animateCamera(cameraUpdate)
    }

    /**
     * Zooms the camera out by one level.
     */
    override fun zoomOut() {
        val cameraUpdate = CameraUpdateFactory.zoomOut()
        libreMap.animateCamera(cameraUpdate)
    }

    /**
     * Gets the camera position for given geographical bounds.
     *
     * @param bounds A map containing the north-east and south-west bounds.
     * @return A map containing the camera's bearing, target, tilt, zoom, and padding.
     */
    override fun getCameraForLatLngBounds(bounds: Map<String, Any?>): Map<String, Any?> {
        val northEast = bounds["north_east"] as List<*>
        val southWest = bounds["south_west"] as List<*>
        val latLngBounds = LatLngBounds.fromLatLngs(
            listOf(
                LatLng(southWest[0] as Double, southWest[1] as Double),
                LatLng(northEast[0] as Double, northEast[1] as Double)
            )
        )

        val cameraPosition = libreMap.getCameraForLatLngBounds(latLngBounds)

        if (cameraPosition != null) {
            return mapOf(
                "bearing" to cameraPosition.bearing,
                "target" to listOf(
                    cameraPosition.target?.latitude,
                    cameraPosition.target?.longitude
                ),
                "tilt" to cameraPosition.tilt,
                "zoom" to cameraPosition.zoom,
                "padding" to listOf(cameraPosition.padding),
            )
        }

        throw Exception("Camera position is null")
    }

    /**
     * Queries rendered features on the map.
     *
     * @param args A map containing the query parameters, such as point, rect, layer_ids, and filter.
     * @return A list of maps, each representing a rendered feature with its properties.
     */
    override fun queryRenderedFeatures(args: Map<String, Any?>): List<Map<Any?, Any?>> {
        val pointArgs = args["point"] as List<*>?
        val rectArgs = args["rect"] as List<*>?

        if (pointArgs == null && rectArgs == null) throw Exception("Point or rect is required")

        val point = pointArgs?.mapNotNull { it.toString().toFloatOrNull() }
        val rect = rectArgs?.mapNotNull { it.toString().toFloatOrNull() }

        if (point != null && point.size != 2) throw Exception("Point must have x and y coordinates")
        if (rect != null && rect.size != 4) throw Exception("Point must have 4 corners values")

        val layerIdsArgs = args["layerIds"] as List<*>?
        val filterArgs = args["filter"] as String?


        val layerIds = layerIdsArgs?.mapNotNull { it?.toString() } ?: emptyList()
        val filter = filterArgs?.let { Expression.raw(it) }


        val features = point?.let {
            libreMap.queryRenderedFeatures(
                PointF(it.first(), it.last()),
                filter,
                *layerIds.toTypedArray()
            )
        } ?: rect?.let {
            libreMap.queryRenderedFeatures(
                RectF(it[0], it[1], it[2], it[3]),
                filter,
                *layerIds.toTypedArray()
            )
        } ?: emptyList()



        return features.map { JsonUtils.jsonToMap(it.toJson(), keyConverter = { k -> k }) }
    }

    /**
     * Retrieves the last known location from the map's location component.
     *
     * This function accesses the `lastKnownLocation` property of the map's location component.
     * If a location is available, it returns a list containing the latitude, longitude, and altitude.
     *
     * @return A List of Double representing the last known location in the format [latitude, longitude, altitude].
     * @throws Exception If the `lastKnownLocation` is null, indicating that no location data is currently available.
     */
    override fun lastKnownLocation(): List<Double> {
        val location = libreMap.locationComponent.lastKnownLocation
            ?: throw Exception("Last known location is null")

        return listOf(location.latitude, location.longitude, location.altitude)
    }

    /**
     * Sets the margins for the logo.
     *
     * @param left The left margin.
     * @param top The top margin.
     * @param right The right margin.
     * @param bottom The bottom margin.
     */
    override fun setLogoMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setLogoMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    /**
     * Checks if the logo is enabled in the map's UI settings.
     *
     * The logo, typically a branding element, may be displayed in the corner of the map view.
     * This function provides a way to determine whether the display of the logo is currently enabled or disabled.
     *
     * @return `true` if the logo is enabled and should be displayed, `false` otherwise.
     */
    override fun isLogoEnabled(): Boolean {
        return libreMap.uiSettings.isLogoEnabled
    }

    /**
     * Sets the margins for the compass.
     *
     * @param left The left margin.
     * @param top The top margin.
     * @param right The right margin.
     * @param bottom The bottom margin.
     */
    override fun setCompassMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setCompassMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    /**
     * Sets the compass image.
     *
     * @param bytes The byte array of the image.
     */
    override fun setCompassImage(bytes: ByteArray) {
        val drawable = ImageUtils.byteArrayToDrawable(activity, bytes)
        if (drawable != null) {
            libreMap.uiSettings.setCompassImage(drawable)
        } else {
            throw Exception("Failed to set compass image")
        }
    }

    /**
     * Sets whether the compass should fade when facing north.
     *
     * @param compassFadeFacingNorth True to fade when facing north, false otherwise.
     */
    override fun setCompassFadeFacingNorth(compassFadeFacingNorth: Boolean) {
        libreMap.uiSettings.setCompassFadeFacingNorth(compassFadeFacingNorth)
    }

    /**
     * Checks if the compass is enabled.
     * @return True if the compass is enabled, false otherwise.
     */
    override fun isCompassEnabled(): Boolean {
        return libreMap.uiSettings.isCompassEnabled
    }

    /**
     * Checks if the compass fades when facing north.
     * @return True if the compass fades when facing north, false otherwise.
     */
    override fun isCompassFadeWhenFacingNorth(): Boolean {
        return libreMap.uiSettings.isCompassFadeWhenFacingNorth
    }

    /**
     * Sets the margins for the attribution logo.
     *
     * The attribution logo is typically used to display the data source or copyright information.
     *
     * @param left The left margin in pixels.
     * @param top The top margin in pixels.
     * @param right The right margin in pixels.
     * @param bottom The bottom margin in pixels.
     */
    override fun setAttributionMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setAttributionMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    /**
     * Returns whether the attribution control is enabled.
     *
     * The attribution control displays copyright and data provider information.
     *
     * @return True if the attribution control is enabled, false otherwise.
     */
    override fun isAttributionEnabled(): Boolean {
        return libreMap.uiSettings.isAttributionEnabled
    }

    /**
     * Sets the tint color for the attribution logo.
     *
     * The tint color will be applied to the attribution logo, allowing customization of its appearance.
     *
     * @param color The color to tint the attribution logo, represented as an ARGB color value.
     */
    override fun setAttributionTintColor(color: Long) {
        libreMap.uiSettings.setAttributionTintColor(color.toInt())
    }

    /**
     * Gets the current style URI of the map.
     *
     * The style URI represents the source from which the map's visual style is loaded.
     *
     * @return The current style URI as a string.
     */
    override fun getUri(): String {
        return libreMap.style!!.uri
    }

    /**
     * Gets the style JSON string of the current map style.
     *
     * The style JSON defines the visual appearance of the map.
     * @return The style JSON string.
     */
    override fun getJson(callback: (Result<String>) -> Unit) {
        try {
            val json = libreMap.style!!.json
            callback(Result.success(json))
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Retrieves the current light properties from the map's style.
     *
     * This function accesses the light object within the map's style and returns
     * a map containing its properties: anchor, color, and intensity.
     *
     * @return A map containing the light properties. The map has the following structure:
     *   - "anchor": The light anchor as a String (e.g., "viewport", "map").
     *   - "color": The light color as a String in hexadecimal format (e.g., "#RRGGBB").
     *   - "intensity": The light intensity as a Float (e.g., 0.5, 1.0).
     *
     * @throws Exception If the light object is null within the map's style. This indicates
     *   that no light properties have been defined for the map.
     */
    override fun getLight(): Map<String, Any> {
        val light = libreMap.style?.light

        if (light != null) {
            return mapOf(
                "anchor" to light.anchor,
                "color" to light.color,
                "intensity" to light.intensity
            )
        }

        throw Exception("Light is null")
    }

    /**
     * Checks if the current map style is fully loaded.
     *
     * A style is considered fully loaded when all of its components (layers, sources, images, etc.) have been loaded.
     * @return True if the style is fully loaded, false otherwise.
     */
    override fun isFullyLoaded(): Boolean {
        return libreMap.style!!.isFullyLoaded
    }

    /**
     * Retrieves information about a specific layer in the map's style.
     *
     * This function attempts to find a layer with the given ID within the map's current style.
     * If the layer is found, it returns a map containing key information about the layer.
     *
     * @param id The ID of the layer to retrieve.
     * @return A map containing the following information about the layer, if found:
     *   - "id": The layer's ID (String).
     *   - "min_zoom": The minimum zoom level at which the layer is visible (Double).
     *   - "max_zoom": The maximum zoom level at which the layer is visible (Double).
     *   - "is_detached": Whether the layer is detached from the style (Boolean).
     * @throws Exception If a layer with the specified ID is not found in the map's style.
     */
    override fun getLayer(id: String): Map<Any?, Any?> {
        val layer = libreMap.style?.getLayer(id)

        if (layer != null) {
            return LayerArgsParser.extractArgsFromLayer(layer)
        }

        throw Exception("Layer not found")
    }

    /**
     * Retrieves a list of layer information from the map style.
     *
     * This function extracts details about each layer in the current map style,
     * including its ID, minimum zoom level, maximum zoom level, and whether it's detached.
     *a
     * @return A list of maps, where each map represents a layer and contains the following keys:
     *         - "id": The layer's unique identifier (String).
     *         - "min_zoom": The minimum zoom level at which the layer is visible (Float).
     *         - "max_zoom": The maximum zoom level at which the layer is visible (Float).
     *         - "is_detached": A boolean indicating if the layer is detached from the style. (Boolean).
     *         Returns an empty list if the map style has no layers or if the style is not loaded.
     *
     * exceptions are explicitly thrown by this function. However, potential exceptions from underlying map library operations might propagate.
     */
    override fun getLayers(): List<Map<Any?, Any?>> {
        val layers = libreMap.style?.layers

        return if (layers.isNullOrEmpty()) {
            emptyList()
        } else {
            layers.map {
                LayerArgsParser.extractArgsFromLayer(it)
            }
        }
    }

    /**
     * Retrieves information about a source from the map style.
     *
     * This function attempts to retrieve a source with the specified ID from the map's current style.
     * If the source is found, it returns a map containing the source's ID, attribution, and volatile status.
     * If the source is not found, it throws an exception.
     *
     * @param id The ID of the source to retrieve.
     * @return A map containing the source's information:
     *         - "id": The source's ID (String).
     *         - "attribution": The source's attribution (String?).
     *         - "is_volatile": Whether the source is volatile (Boolean).
     * @throws Exception If a source with the given ID is not found.
     */
    override fun getSource(id: String): Map<Any?, Any?> {
        val source = libreMap.style?.getSource(id)

        if (source != null) {
            return mapOf(
                "id" to source.id,
                "attribution" to source.attribution,
                "is_volatile" to source.isVolatile,
            )
        }

        throw Exception("Source not found")
    }

    /**
     * Retrieves a list of source information from the map's style.
     *
     * This function iterates through the sources present in the current map style and extracts
     * relevant details like source ID, attribution, and volatility status.
     *
     * @return A list of maps, where each map represents a source and contains the following keys:
     *   - "id": The unique identifier of the source (String).
     *   - "attribution": The attribution text associated with the source (String or null if not available).
     *   - "is_volatile": A boolean indicating whether the source is volatile (Boolean).
     *
     *
     * @throws IllegalStateException if the underlying map style is null. In this case, it will return empty list.
     */
    override fun getSources(): List<Map<Any?, Any?>> {
        val sources = libreMap.style?.sources

        return if (sources.isNullOrEmpty()) {
            emptyList()
        } else {
            sources.map {
                mapOf(
                    "id" to it.id,
                    "attribution" to it.attribution,
                    "is_volatile" to it.isVolatile,
                )
            }
        }
    }

    /**
     * Adds an image to the map style.
     *
     * This function takes an image name and its byte representation, converts it to a Bitmap,
     * and then adds it to the LibreMap style. If the byte array cannot be converted to a Bitmap,
     * an exception is thrown.
     *
     * @param name The unique name of the image to be added. This name will be used to reference
     *             the image when applying it to layers or other map elements.
     * @param bytes The byte array representing the image data (e.g., PNG, JPEG).
     * @throws Exception If the byte array cannot be converted to a valid Bitmap, or if there's an issue adding it to the map style.
     * @see ImageUtils.byteArrayToBitmap
     */
    override fun addImage(name: String, bytes: ByteArray) {
        val bitmap = ImageUtils.byteArrayToBitmap(bytes)
        if (bitmap != null) {
            libreMap.style?.addImage(name, bitmap)
        } else {
            throw Exception("Failed to add image")
        }
    }

    /**
     * Adds images to the map style.
     *
     * This function takes a map of image names (String) to image data (ByteArray) and adds them
     * as images to the underlying map style.  It first converts the byte arrays to Bitmaps.
     * It then attempts to add these images to the style. If all images cannot be converted or added, it throws an exception.
     *
     * @param images A map where the key is the image name (String) and the value is the image data as a ByteArray.
     *
     * @throws Exception If no images were successfully converted and added to the style.
     *
     * @see ImageUtils.byteArrayToBitmap for how the byte array is converted to a Bitmap
     */
    override fun addImages(images: Map<String, ByteArray>) {
        val hashMap = HashMap<String, Bitmap>()

        for ((name, bytes) in images) {
            try {
                val bitmap = ImageUtils.byteArrayToBitmap(bytes)
                bitmap?.let {
                    hashMap[name] = it
                }
            } catch (_: Exception) {
            }
        }

        if (hashMap.isNotEmpty()) {
            libreMap.style?.addImages(hashMap)
        } else {
            throw Exception("Failed to add images")
        }
    }

    /**
     * Adds a layer to the map's style.
     *
     * This function provides flexible ways to add a layer, allowing you to specify its position
     * relative to other layers or simply appending it to the end of the layer stack.
     *
     * The layer's position can be controlled in three ways:
     *
     * 1. **Index:** If the "index" key is present in the `layer` map and its value is a `Long`,
     *    the layer will be inserted at that specific index in the layer stack.
     *    - `index`: (Long) The zero-based index where the layer should be inserted.
     *
     * 2. **Below:** If the "below" key is present and its value is a `String`, the new layer
     *    will be placed immediately below the layer with the specified ID.
     *    - `below`: (String) The ID of the layer below which the new layer should be placed.
     *
     * 3. **Above:** If the "above" key is present and its value is a `String`, the new layer
     *    will be placed immediately above the layer with the specified ID.
     *    - `above`: (String) The ID of the layer above which the new layer should be placed.
     *
     * If none of the "index", "below", or "above" keys are provided, the layer will be added
     * to the end of the layer stack.
     *
     * @param layer A map containing the layer's definition. This map should include:
     *              - The layer's type, id, and other style properties as defined by the
     *                LibreMap style specification.
     *              - Optionally, one of "index", "below", or "above" to control the layer's
     *                position.
     *
     * @throws ClassCastException if the value associated with "index" is not a Long, or if the values associated with "below" or "above" are not Strings
     * @throws IllegalArgumentException If the provided layer data is invalid according to LayerUtils.fromArgs
     * @throws RuntimeException If the underlying libreMap style or its addLayer/addLayerAt/addLayerBelow/addLayerAbove method throw an exception.
     */
    override fun addLayer(layer: Map<String, Any?>) {
        val styleLayer = LayerArgsParser.parseArgs(layer)

        val index = layer["index"] as Long?
        if (index != null) {
            libreMap.style?.addLayerAt(styleLayer, index.toInt())
            return
        }

        val below = layer["below"] as String?
        if (below != null) {
            libreMap.style?.addLayerBelow(styleLayer, below)
            return
        }

        val above = layer["above"] as String?
        if (above != null) {
            libreMap.style?.addLayerAbove(styleLayer, above)
            return
        }

        libreMap.style?.addLayer(styleLayer)
    }

    /**
     * Adds a new source to the map's style.
     *
     * This function takes a map representing a source definition, checks if a source with the same ID
     * already exists, and if not, creates the source and adds it to the map's style.
     *
     * @param source A map containing the source definition.
     *               It should contain at least a "type" key indicating the source type (e.g., "geojson", "vector", "raster").
     *               It can also include other source-specific parameters like "data" for GeoJSON sources or "url" for vector tiles.
     *               It should contain a "details" key which is a map itself that contains an "id" key.
     *               Example:
     *               ```
     *               mapOf(
     *                   "type" to "geojson",
     *                   "data" to "some_geojson_data",
     *                   "details" to mapOf("id" to "my-geojson-source")
     *               )
     *               ```
     * @throws Exception if a source with the same ID already exists.
     * @throws ClassCastException if the provided source map is malformed, specifically if "details" is not a Map or "id" within details is not a String.
     * @throws NullPointerException if the details or id keys are not present in the source map.
     */
    override fun addSource(source: Map<String, Any?>) {
        val details = source["details"] as Map<*, *>?
        if (isSourceExist(details?.get("id") as String?)) throw Exception("Source already exists")
        val styleSource = SourceArgsParser.parseArgs(source)
        libreMap.style?.addSource(styleSource)
    }

    /**
     * Sets the GeoJSON data for a specified GeoJSON source in the map style.
     *
     * This function takes a source ID and a GeoJSON string as input. It retrieves the
     * GeoJSON source from the map style using the provided source ID and then updates
     * the source's data with the new GeoJSON string.
     *
     * @param sourceId The ID of the GeoJSON source to update. This ID should correspond
     *                 to a source that has already been added to the map style.
     * @param jsonString The GeoJSON data as a string. This string should be a valid
     *                   GeoJSON representation of the desired data.
     *
     * @throws ClassCastException if the source with the given `sourceId` is not a GeoJsonSource.
     * @throws IllegalStateException if the style is null, or if the source with `sourceId` does not exist.
     *
     */
    override fun setGeoJsonData(
        sourceId: String,
        jsonString: String
    ) {
        val source = libreMap.style?.getSourceAs<GeoJsonSource>(sourceId)
        source?.setGeoJson(jsonString)
    }

    /**
     * Sets the GeoJSON data source URI for a given source ID.
     *
     * This function updates the GeoJSON data associated with a source in the map's style.
     * It retrieves the specified GeoJSON source from the map's style and updates its URI.
     * If the source is not found or is not a GeoJsonSource, no action is taken.
     *
     * @param sourceId The ID of the GeoJSON source to update. This ID must correspond to a source
     *                 that has been added to the map's style.
     * @param uri      The new URI for the GeoJSON data. This should be a valid URI string that
     *                 points to the GeoJSON data (e.g., a URL or a local file path).
     *
     * @throws IllegalArgumentException If the provided URI string is not a valid URI.
     * @throws IllegalStateException If the map style is null.
     *
     */
    override fun setGeoJsonUri(sourceId: String, uri: String) {
        val source = libreMap.style?.getSourceAs<GeoJsonSource>(sourceId)
        source?.setUri(URI.create(uri))
    }

    /**
     * Adds an annotation to the Libre Annotations Manager.
     *
     * @param annotation A map containing annotation data where the key represents the annotation property
     *                   and the value is the corresponding data. Nullable values are allowed.
     *
     * @return A map containing the annotation's data.
     */
    override fun addAnnotation(annotation: Map<String, Any?>): Map<String, Any?> {
        return libreAnnotationsManager.addAnnotation(annotation)
    }

    /**
     * Updates an existing annotation with the given ID.
     *
     * This function delegates the actual update operation to the `LibreAnnotationsManager`.
     * It receives an annotation ID and a map containing the new annotation data, and then
     * passes these to the underlying manager. The function then returns the updated annotation.
     *
     * @param id The ID of the annotation to update. Must be a positive Long.
     * @param annotation A map representing the new data for the annotation.
     *                   Keys are the annotation fields (e.g., "content", "author"),
     *                   and values are the corresponding data. Values can be nullable.
     * @return A map representing the updated annotation, or potentially an empty map if the update fails,
     *         depending on the implementation of `LibreAnnotationsManager.updateAnnotation`.
     *
     */
    override fun updateAnnotation(id: Long, annotation: Map<String, Any?>): Map<String, Any?> {
        return libreAnnotationsManager.updateAnnotation(id, annotation)
    }

    /**
     * Retrieves an annotation by its unique identifier.
     *
     * This function delegates the retrieval of an annotation to the underlying
     * `libreAnnotationsManager`. It fetches an annotation associated with the provided ID.
     *
     * @param id The unique identifier of the annotation to retrieve.
     * @return A map representing the annotation's data
     *
     */
    override fun getAnnotation(id: Long): Map<String, Any?>? {
        return libreAnnotationsManager.getAnnotation(id)
    }

    /**
     * Removes a layer from the map style by its ID.
     *
     * This function attempts to remove a layer with the given ID from the current map style.
     * If the style is not loaded or if the layer does not exist, it will return false.
     * If the layer is successfully removed, it will return true.
     *
     * @param id The ID of the layer to remove.
     * @return `true` if the layer was successfully removed, `false` otherwise.
     */
    override fun removeLayer(id: String): Boolean {
        return libreMap.style?.removeLayer(id) ?: false
    }

    /**
     * Removes the layer at the specified index from the map's style.
     *
     * This function delegates the removal to the underlying LibreMap's style object.
     * It attempts to remove the layer at the given index within the style's layer stack.
     * If the style is null or the layer cannot be removed (e.g., index out of bounds), it returns false.
     *
     * @param index The index of the layer to remove. The index starts at 0 for the bottom-most layer.
     * @return `true` if the layer was successfully removed, `false` otherwise.
     *
     * @throws IndexOutOfBoundsException if the provided index is negative or beyond the total layer count.
     * It is however caught within the method and will return false.
     */
    override fun removeLayerAt(index: Long): Boolean {
        return libreMap.style?.removeLayerAt(index.toInt()) == true
    }

    /**
     * Removes a source with the given ID from the map's style.
     *
     * @param id The ID of the source to remove.
     * @return `true` if the source was successfully removed, `false` otherwise.
     *         This will also return false if the style is null or if a source with the specified ID does not exist.
     *
     */
    override fun removeSource(id: String): Boolean {
        return libreMap.style?.removeSource(id) ?: false
    }

    /**
     * Removes an image from the style's image collection.
     *
     * This function removes an image that was previously added to the style.
     * If the image doesn't exist, this function will have no effect.
     *
     * @param name The name of the image to remove. This should be the same name
     *             used when the image was originally added using `addImage`.
     *
     */
    override fun removeImage(name: String) {
        libreMap.style?.removeImage(name)
    }

    /**
     * Removes an annotation from the underlying annotation management system.
     *
     * This function delegates the removal operation to the `LibreAnnotationsManager`.
     * The annotation to be removed is identified by the data provided in the `args` map.
     *
     */
    override fun removeAnnotation(args: Map<String, Any?>) {
        Log.d("TAG", "removeAnnotation: ${args}")
        libreAnnotationsManager.deleteAnnotation(args)
    }

    /**
     * Removes all annotations from the current document.
     *
     * This function delegates the removal of all annotations of given type to the underlying
     * `libreAnnotationsManager`. It effectively clears all annotations of type defined on the args.
     *
     */
    override fun removeAllAnnotations(args: Map<String, Any?>) {
        libreAnnotationsManager.deleteAllAnnotations(args)
    }

    /**
     * Retrieves an image from the current map style by its identifier and returns it as a byte array.
     *
     * @param id The unique identifier of the image in the map style.
     * @return A [ByteArray] representation of the image.
     * @throws Exception if the image with the specified [id] is not found.
     */
    override fun getImage(id: String): ByteArray {
        val image = libreMap.style?.getImage(id)

        val byteArray = image?.let { ImageUtils.bitmapToByteArray(it) }

        if (byteArray != null) return byteArray

        throw Exception("Image not found")
    }

    /**
     * Takes a snapshot of the current map view and provides it as a byte array.
     *
     * This function captures the current state of the map rendered by the underlying
     * `libreMap` instance. The resulting snapshot is then converted into a byte array
     * representation of a PNG image. The outcome of this operation, success or failure,
     * is communicated back via the provided callback function.
     *
     * @param callback A lambda function that receives a `Result` object.
     * - `Result.success(ByteArray)`:  Indicates successful snapshot capture and
     *    conversion. The `ByteArray` contains the PNG image data of the map.
     * - `Result.failure(Exception)`: Indicates an error occurred during the process.
     *    The `Exception` contains details about the failure.
     *
     * @throws IllegalStateException if the `libreMap` has not been initialized correctly.
     */
    override fun snapshot(callback: (Result<ByteArray>) -> Unit) {
        libreMap.snapshot {
            val byteArray = ImageUtils.bitmapToByteArray(it)
            if (byteArray != null) {
                callback(Result.success(byteArray))
            } else {
                callback(Result.failure(Exception("Failed to get snapshot")))
            }
        }
    }

    /**
     * Triggers a repaint of the underlying map view.
     *
     * This function delegates the repaint request to the underlying `libreMap` instance.
     * It's typically used to force a visual update of the map when changes have been
     * made that are not automatically reflected on the screen.
     *
     * Common scenarios where a repaint might be necessary include:
     *   - Updating data sources that affect the map's appearance.
     *   - Modifying style layers or their properties.
     *   - Making changes to camera position that might not be automatically animated.
     *   - Performing operations that require immediate rendering updates.
     *
     * Calling this function ensures that any pending or queued visual changes are
     * rendered immediately.
     *
     * Note: Excessive repaints can impact performance, so use this method judiciously.
     */
    override fun triggerRepaint() {
        libreMap.triggerRepaint()
    }

    /**
     * Resets the map's orientation to North.
     *
     * This function delegates the task of resetting the map's orientation to
     * the underlying `libreMap` object. It ensures that the map is displayed
     * with North pointing upwards.
     */
    override fun resetNorth() {
        libreMap.resetNorth()
    }

    /**
     * Downloads a region based on the provided arguments.
     *
     * This function delegates the actual download operation to the `libreOfflineManager`.
     * It takes a map of arguments specifying the region to be downloaded and a callback
     * function to handle the result of the download operation.
     *
     * @param args A map containing the arguments required to specify the region to download.
     * @param callback A callback function that will be invoked with the result of the download operation.
     *
     */
    override fun downloadRegion(
        args: Map<String, Any?>,
        callback: (Result<Map<Any?, Any?>>) -> Unit
    ) {
        libreOfflineManager.download(args, callback)
    }

    /**
     * Cancels the download of an offline region with the given ID.
     *
     * This function delegates the cancellation request to the underlying OfflineManager from the MapLibre Maps SDK.
     * It attempts to cancel an ongoing download identified by the provided region ID.
     *
     * @param id The ID of the offline region to cancel. This ID should correspond to a previously
     *           initiated download region managed by the [OfflineManager].
     * @param callback A lambda function that is invoked when the cancellation operation is completed.
     *
     */
    override fun cancelDownloadRegion(id: Long, callback: (Result<Boolean>) -> Unit) {
        libreOfflineManager.cancelDownload(id, callback)
    }

    /**
     * Retrieves a region's details from the offline manager.
     *
     * This function fetches the details of a specific region identified by its ID.
     * It delegates the actual retrieval to the `libreOfflineManager`.
     *
     * @param id The unique identifier of the region to retrieve.
     * @param callback A callback function that will be invoked with the result of the operation.
     *
     */
    override fun getRegion(id: Long, callback: (Result<Map<Any?, Any?>>) -> Unit) {
        libreOfflineManager.getRegion(id, callback)
    }

    /**
     * Deletes a region with the specified ID.
     *
     * This function delegates the region deletion operation to the underlying [libreOfflineManager].
     * It asynchronously attempts to delete the region and reports the success or failure via the provided callback.
     *
     * @param id The ID of the region to delete.
     * @param callback A callback function that is invoked with the result of the deletion operation.
     *                 - Result.success(true): If the region was successfully deleted.
     *                 - Result.failure(exception): If an error occurred during deletion. The exception will contain details about the failure.
     */
    override fun deleteRegion(id: Long, callback: (Result<Boolean>) -> Unit) {
        libreOfflineManager.deleteRegion(id, callback)
    }

    /**
     * Deletes all downloaded offline regions.
     *
     * This function initiates the deletion of all currently downloaded offline regions managed
     * by the `libreOfflineManager`. The result of the deletion operation is delivered via a callback.
     *
     * @param callback A lambda function that receives the result of the deletion operation.
     *                 The result is a `Result` object that wraps a `Map<Long, Boolean>`.
     *
     */
    override fun deleteAllRegions(callback: (Result<Map<Long, Boolean>>) -> Unit) {
        libreOfflineManager.deleteAllRegions(callback)
    }

    /**
     * Lists the available offline regions.
     *
     * This function delegates the task of listing available offline regions to the underlying
     * `libreOfflineManager`.  It provides a callback mechanism to handle the results, whether
     * successful or failed.
     *
     * @param callback A callback function that will be invoked with the result of the operation.
     *
     */
    override fun listRegions(callback: (Result<List<Map<Any?, Any?>>>) -> Unit) {
        libreOfflineManager.listRegions(callback)
    }

    /**
     * Checks if a source with the given ID exists.
     *
     * This function attempts to retrieve a source using the provided ID.
     * If the source is found (getSource() succeeds), it indicates the source exists, and the function returns `true`.
     * If `getSource()` throws an exception (e.g., the source is not found), it's considered that the source does not exist, and the function returns `false`.
     * If the provided ID is `null`, it's also considered that the source doesn't exist, and the function returns `false`.
     *
     * @param id The ID of the source to check for. Can be `null`.
     * @return `true` if a source with the given ID exists, `false` otherwise.
     */
    private fun isSourceExist(id: String?): Boolean {
        return if (id != null) {
            try {
                getSource(id)
                true
            } catch (_: Exception) {
                false
            }
        } else {
            false
        }
    }

    /**
     * Handles the initial parameters passed to the map view.
     *
     * This function parses the initial parameters, specifically focusing on UI settings,
     * and applies them to the provided MapLibreMap instance.
     *
     * @see UiSettingsArgsParser.parseArgs for details on how UI settings are parsed.
     * @see handleUiSettings for how the UI settings are applied to the map.
     */
    private fun handleCreationParams() {
        val uiSettings = UiSettingsArgsParser.parseArgs(
            creationParams?.get("uiSettings") as? Map<*, *> ?: emptyMap<Any, Any>()
        )
        handleUiSettings(uiSettings)

        val locationComponentParams =
            creationParams?.get("locationSettings") as? Map<*, *>
        setupLocationComponent(params = locationComponentParams)
    }

    /**
     * Handles the configuration of the MapLibre map's UI settings based on the provided `NaxaLibreUiSettings`.
     *
     * This function takes a `MapLibreMap` instance and a `NaxaLibreUiSettings` object as input.
     * It then applies the settings from `NaxaLibreUiSettings` to the map's UI, controlling
     * aspects like logo visibility, compass visibility, attribution visibility, gesture controls, and margins.
     *
     * @param uiSettings An instance of `UiSettingsUtils.NaxaLibreUiSettings` containing the desired UI settings.
     *
     * @see MapLibreMap
     * @see UiSettingsArgsParser.NaxaLibreUiSettings
     */
    private fun handleUiSettings(
        uiSettings: UiSettingsArgsParser.NaxaLibreUiSettings
    ) {
        libreMap.uiSettings.apply {
            isLogoEnabled = uiSettings.logoEnabled
            isCompassEnabled = uiSettings.compassEnabled
            isAttributionEnabled = uiSettings.attributionEnabled

            if (uiSettings.logoGravity != null) {
                logoGravity = when (uiSettings.logoGravity) {
                    "topLeft" -> Gravity.TOP or Gravity.START
                    "topRight" -> Gravity.TOP or Gravity.END
                    "bottomLeft" -> Gravity.BOTTOM or Gravity.START
                    "bottomRight" -> Gravity.BOTTOM or Gravity.END
                    else -> Gravity.NO_GRAVITY
                }
            }
            if (uiSettings.compassGravity != null) {
                compassGravity = when (uiSettings.compassGravity) {
                    "topLeft" -> Gravity.TOP or Gravity.START
                    "topRight" -> Gravity.TOP or Gravity.END
                    "bottomLeft" -> Gravity.BOTTOM or Gravity.START
                    "bottomRight" -> Gravity.BOTTOM or Gravity.END
                    else -> Gravity.NO_GRAVITY
                }
            }
            if (uiSettings.attributionGravity != null) {
                attributionGravity = when (uiSettings.attributionGravity) {
                    "topLeft" -> Gravity.TOP or Gravity.START
                    "topRight" -> Gravity.TOP or Gravity.END
                    "bottomLeft" -> Gravity.BOTTOM or Gravity.START
                    "bottomRight" -> Gravity.BOTTOM or Gravity.END
                    else -> Gravity.NO_GRAVITY
                }
            }

            isRotateGesturesEnabled = uiSettings.rotateGesturesEnabled
            isTiltGesturesEnabled = uiSettings.tiltGesturesEnabled
            isZoomGesturesEnabled = uiSettings.zoomGesturesEnabled
            isScrollGesturesEnabled = uiSettings.scrollGesturesEnabled
            isHorizontalScrollGesturesEnabled = uiSettings.horizontalScrollGesturesEnabled
            isDoubleTapGesturesEnabled = uiSettings.doubleTapGesturesEnabled
            isQuickZoomGesturesEnabled = uiSettings.quickZoomGesturesEnabled
            isScaleVelocityAnimationEnabled = uiSettings.scaleVelocityAnimationEnabled
            isRotateVelocityAnimationEnabled = uiSettings.rotateVelocityAnimationEnabled
            isFlingVelocityAnimationEnabled = uiSettings.flingVelocityAnimationEnabled
            isDisableRotateWhenScaling = uiSettings.disableRotateWhenScaling
            isIncreaseScaleThresholdWhenRotating = uiSettings.increaseRotateThresholdWhenScaling

            if (uiSettings.logoMargins != null && uiSettings.logoMargins.size == 4) {
                setLogoMargins(
                    uiSettings.logoMargins[0],
                    uiSettings.logoMargins[1],
                    uiSettings.logoMargins[2],
                    uiSettings.logoMargins[3]
                )
            }

            if (uiSettings.compassMargins != null && uiSettings.compassMargins.size == 4) {
                setCompassMargins(
                    uiSettings.compassMargins[0],
                    uiSettings.compassMargins[1],
                    uiSettings.compassMargins[2],
                    uiSettings.compassMargins[3]
                )
            }

            if (uiSettings.attributionMargins != null && uiSettings.attributionMargins.size == 4) {
                setAttributionMargins(
                    uiSettings.attributionMargins[0],
                    uiSettings.attributionMargins[1],
                    uiSettings.attributionMargins[2],
                    uiSettings.attributionMargins[3]
                )
            }

            if (uiSettings.focalPoint != null) focalPoint = uiSettings.focalPoint
            if (uiSettings.flingThreshold != null) flingThreshold = uiSettings.flingThreshold

            if (uiSettings.attributions != null) {
                setAttributionDialogManager(
                    NaxaLibreAttributionDialogManager(
                        activity,
                        libreMap,
                        uiSettings.attributions
                    )
                )
            }
        }
    }

    /**
     * Sets up the MapLibre location component.
     *
     * This function configures the location component to display the user's current
     * location on the map, including a pulsing effect, custom colors, and a
     * high-accuracy location engine.
     *
     * @throws SecurityException if the necessary location permissions are not granted.
     *
     * @SuppressLint("MissingPermission")
     * Suppresses the lint warning about missing location permission checks.
     * This is because the function is assumed to be called only after
     * the necessary permissions have been granted elsewhere.
     */
    @SuppressLint("MissingPermission")
    private fun setupLocationComponent(params: Map<*, *>?) {
        try {
            val locationEnabled =
                if (params?.containsKey("locationEnabled") == true && params["locationEnabled"] is Boolean) {
                    params["locationEnabled"] as Boolean
                } else {
                    false
                }

            if (!locationEnabled) return

            val shouldRequestPermission =
                if (params?.containsKey("shouldRequestAuthorizationOrPermission") == true && params["shouldRequestAuthorizationOrPermission"] is Boolean) {
                    params["shouldRequestAuthorizationOrPermission"] as Boolean
                } else {
                    false
                }

            if (shouldRequestPermission) {
                val hasPermission = hasLocationPermissions()
                if (!hasPermission) {
                    requestLocationPermissions()
                    return
                }
            }

            val componentOptionsParams = params?.get("locationComponentOptions") as? Map<*, *>
            val locationEngineRequestParams =
                params?.get("locationEngineRequestOptions") as? Map<*, *>
            val provider = locationEngineRequestParams?.get("provider") as String?

            val locationComponentOptions = LocationComponentOptions
                .builder(activity)
                .trackingGesturesManagement(true)
                .setupArgs(componentOptionsParams)
                .build()

            libreMap.getStyle { style ->
                if (style.isFullyLoaded) {
                    val locationComponentActivationOptions = LocationComponentActivationOptions
                        .builder(activity, style)
                        .locationComponentOptions(locationComponentOptions)
                        .useDefaultLocationEngine(false)
                        .locationEngineRequest(
                            LocationEngineRequestArgsParser.fromArgs(
                                locationEngineRequestParams ?: emptyMap<Any, Any>()
                            ).build()
                        )
                        .locationEngine(
                            NaxaLibreLocationEngine.create(
                                activity,
                                provider,
                                isStyleFullyLoaded = { style.isFullyLoaded }
                            )
                        )
                        .build()

                    libreMap.locationComponent.apply {
                        activateLocationComponent(locationComponentActivationOptions)
                        isLocationComponentEnabled = true
                        setupArgs(params)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * Checks if the app has been granted both ACCESS_COARSE_LOCATION and ACCESS_FINE_LOCATION permissions.
     *
     * This function verifies whether the application currently holds the necessary permissions to access
     * the device's location, both approximate (coarse) and precise (fine). It checks against both
     * `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` permissions.
     *
     * @return `true` if the app has both `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION` permissions,
     *         `false` otherwise.
     *
     */
    private fun hasLocationPermissions(): Boolean {
        return ActivityCompat.checkSelfPermission(
            activity,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
            activity,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * Requests location permissions (ACCESS_FINE_LOCATION and ACCESS_COARSE_LOCATION) from the user.
     *
     * This function initiates a permission request flow to obtain the user's consent for
     * accessing their device's location. It requests both fine and coarse location permissions.
     *
     * @see ActivityCompat.requestPermissions
     * @see android.app.Activity.onRequestPermissionsResult
     */
    private fun requestLocationPermissions() {
        val locationPermissions = arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )
        ActivityCompat.requestPermissions(
            activity,
            locationPermissions,
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    /**
     * Callback for the result from requesting permissions. This method is invoked for every call on
     * {@link #requestPermissions(String[], int)}.
     *
     * Handles the result of a location permission request. If the request code matches
     * `LOCATION_PERMISSION_REQUEST_CODE` and all permissions are granted, it proceeds to set up
     * the location component.
     *
     * @param requestCode The request code passed in {@link #requestPermissions(String[], int)}.
     * @param permissions The requested permissions. Never null.
     * @param grantResults The grant results for the corresponding permissions which is either
     *     {@link PackageManager#PERMISSION_GRANTED} or {@link PackageManager#PERMISSION_DENIED}.
     *     Never null.
     * @return `true` if the request code matches `LOCATION_PERMISSION_REQUEST_CODE`, regardless of
     *     whether the permissions were granted. `false` otherwise.
     *
     */
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            val isGranted =
                grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }

            if (isGranted) {
                val locationComponentParams =
                    creationParams?.get("locationSettings") as? Map<*, *>
                setupLocationComponent(params = locationComponentParams)
            }

            return true
        }
        return false
    }

    /**
     * Request code used to identify the location permission request.
     * This constant is used when requesting location permissions from the user and
     * in the `onRequestPermissionsResult` callback to determine if the result
     * corresponds to the location permission request.
     *
     * The value `101` is arbitrary and can be any positive integer,
     * but it should be unique within the application to avoid collisions with
     * other permission request codes.
     */
    companion object {
        const val LOCATION_PERMISSION_REQUEST_CODE = 101
    }
}