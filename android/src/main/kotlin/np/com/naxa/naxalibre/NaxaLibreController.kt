package np.com.naxa.naxalibre

import NaxaLibreHostApi
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.PointF
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import np.com.naxa.naxalibre.utils.CameraUpdateUtils
import np.com.naxa.naxalibre.utils.ImageUtils
import np.com.naxa.naxalibre.utils.LayerUtils
import np.com.naxa.naxalibre.utils.SourceUtils
import org.maplibre.android.camera.CameraUpdateFactory
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds
import org.maplibre.android.geometry.ProjectedMeters
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.maps.MapView

private const val TAG = "NaxaLibreController"

class NaxaLibreController(
    binaryMessenger: BinaryMessenger,
    private val activity: Activity,
    private val libreView: MapView,
    private val libreMap: MapLibreMap
) : NaxaLibreHostApi {

    init {
        Log.d(TAG, "onInit: NaxaLibreController()")
        NaxaLibreHostApi.setUp(binaryMessenger, this)
    }

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

    override fun toScreenLocation(latLng: List<Double>): List<Double> {
        val screenLocation =
            libreMap.projection.toScreenLocation(LatLng(latLng.first(), latLng.last()))
        return listOf(screenLocation.x.toDouble(), screenLocation.y.toDouble())
    }

    override fun getLatLngForProjectedMeters(northing: Double, easting: Double): List<Double> {
        val projectedMeters = ProjectedMeters(northing, easting)
        val latLng = libreMap.projection.getLatLngForProjectedMeters(projectedMeters)
        return listOf(latLng.latitude, latLng.longitude)
    }

    override fun getVisibleRegion(ignorePadding: Boolean): List<List<Double>> {
        val visibleRegion = libreMap.projection.getVisibleRegion(ignorePadding)
        return listOf(
            listOf(visibleRegion.farLeft!!.latitude, visibleRegion.farLeft!!.longitude),
            listOf(visibleRegion.farRight!!.latitude, visibleRegion.farRight!!.longitude),
            listOf(visibleRegion.nearLeft!!.latitude, visibleRegion.nearLeft!!.longitude),
            listOf(visibleRegion.nearRight!!.latitude, visibleRegion.nearRight!!.longitude)
        )
    }

    override fun getProjectedMetersForLatLng(latLng: List<Double>): List<Double> {
        val projectedMeters =
            libreMap.projection.getProjectedMetersForLatLng(LatLng(latLng.first(), latLng.last()))
        return listOf(projectedMeters.easting, projectedMeters.northing)
    }

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

    override fun getZoom(): Double {
        return libreMap.cameraPosition.zoom
    }

    override fun getHeight(): Double {
        return libreMap.height.toDouble()

    }

    override fun getWidth(): Double {
        return libreMap.width.toDouble()

    }

    override fun getMinimumZoom(): Double {
        return libreMap.minZoomLevel
    }

    override fun getMaximumZoom(): Double {
        return libreMap.maxZoomLevel
    }

    override fun getMinimumPitch(): Double {
        return libreMap.minPitch
    }

    override fun getMaximumPitch(): Double {
        return libreMap.maxPitch
    }

    override fun getPixelRatio(): Double {
        return libreView.pixelRatio.toDouble()
    }

    override fun isDestroyed(): Boolean {
        return libreView.isDestroyed
    }

    override fun setMaximumFps(fps: Long) {
        libreView.setMaximumFps(fps.toInt())
    }

    override fun setStyle(style: String) {
        libreMap.setStyle(style)
    }

    override fun setSwapBehaviorFlush(flush: Boolean) {
        libreMap.setSwapBehaviorFlush(flush)
    }

    override fun animateCamera(args: Map<String, Any?>) {
        val cameraUpdate = CameraUpdateUtils.cameraUpdateFromArgs(args)
        val duration = args["duration"] as Long?
        if (duration == null) libreMap.animateCamera(cameraUpdate)
        else libreMap.animateCamera(cameraUpdate, duration.toInt())
    }

    override fun easeCamera(args: Map<String, Any?>) {
        val cameraUpdate = CameraUpdateUtils.cameraUpdateFromArgs(args)
        val duration = args["duration"] as Long?
        if (duration == null) libreMap.easeCamera(cameraUpdate)
        else libreMap.easeCamera(cameraUpdate, duration.toInt())
    }

    override fun zoomBy(by: Long) {
        val cameraUpdate = CameraUpdateFactory.zoomBy(-by.toDouble())
        libreMap.animateCamera(cameraUpdate)
    }

    override fun zoomIn() {
        val cameraUpdate = CameraUpdateFactory.zoomIn()
        libreMap.animateCamera(cameraUpdate)
    }

    override fun zoomOut() {
        val cameraUpdate = CameraUpdateFactory.zoomOut()
        libreMap.animateCamera(cameraUpdate)
    }

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

    override fun queryRenderedFeatures(args: Map<String, Any?>): List<Map<String, Any?>> {
        TODO("Not yet implemented")
    }

    override fun setLogoMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setLogoMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    override fun isLogoEnabled(): Boolean {
        return libreMap.uiSettings.isLogoEnabled
    }

    override fun setCompassMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setCompassMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    override fun setCompassImage(bytes: ByteArray) {
        val drawable = ImageUtils.byteArrayToDrawable(activity, bytes)
        if (drawable != null) {
            libreMap.uiSettings.setCompassImage(drawable)
        } else {
            throw Exception("Failed to set compass image")
        }
    }

    override fun setCompassFadeFacingNorth(compassFadeFacingNorth: Boolean) {
        libreMap.uiSettings.setCompassFadeFacingNorth(compassFadeFacingNorth)
    }

    override fun isCompassEnabled(): Boolean {
        return libreMap.uiSettings.isCompassEnabled
    }

    override fun isCompassFadeWhenFacingNorth(): Boolean {
        return libreMap.uiSettings.isCompassFadeWhenFacingNorth
    }

    override fun setAttributionMargins(left: Double, top: Double, right: Double, bottom: Double) {
        libreMap.uiSettings.setAttributionMargins(
            left.toInt(),
            top.toInt(),
            right.toInt(),
            bottom.toInt()
        )
    }

    override fun isAttributionEnabled(): Boolean {
        return libreMap.uiSettings.isAttributionEnabled
    }

    override fun setAttributionTintColor(color: Long) {
        libreMap.uiSettings.setAttributionTintColor(color.toInt())
    }

    override fun getUri(): String {
        return libreMap.style!!.uri
    }

    override fun getJson(): String {
        return libreMap.style!!.json
    }

    override fun getLight(): Map<String, Any> {
        val light = libreMap.style!!.light

        if (light != null) {
            return mapOf(
                "anchor" to light.anchor,
                "color" to light.color,
                "intensity" to light.intensity
            )
        }

        throw Exception("Light is null")
    }

    override fun isFullyLoaded(): Boolean {
        return libreMap.style!!.isFullyLoaded
    }

    override fun getLayer(id: String): Map<String, Any?> {
        val layer = libreMap.style?.getLayer(id)

        if (layer != null) {
            return mapOf(
                "id" to layer.id,
                "min_zoom" to layer.minZoom,
                "max_zoom" to layer.maxZoom,
                "is_detached" to layer.isDetached,
            )
        }

        throw Exception("Layer not found")
    }

    override fun getLayers(id: String): List<Map<String, Any?>> {
        val layers = libreMap.style?.layers

        return if (layers.isNullOrEmpty()) {
            emptyList()
        } else {
            layers.map {
                mapOf(
                    "id" to it.id,
                    "min_zoom" to it.minZoom,
                    "max_zoom" to it.maxZoom,
                    "is_detached" to it.isDetached,
                )
            }
        }
    }

    override fun getSource(id: String): Map<String, Any?> {
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

    override fun getSources(): List<Map<String, Any?>> {
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

    override fun addImage(name: String, bytes: ByteArray) {
        val bitmap = ImageUtils.byteArrayToBitmap(bytes)
        if (bitmap != null) {
            libreMap.style?.addImage(name, bitmap)
        } else {
            throw Exception("Failed to add image")
        }
    }

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

    override fun addLayer(layer: Map<String, Any?>) {
        val styleLayer = LayerUtils.fromArgs(layer)
        libreMap.style?.addLayer(styleLayer)
    }

    override fun addSource(source: Map<String, Any?>) {
        val details = source["details"] as Map<*, *>?
        if (isSourceExist(details?.get("id") as String?)) throw Exception("Source already exists")
        val styleSource = SourceUtils.fromArgs(source)
        libreMap.style?.addSource(styleSource)
    }

    override fun removeLayer(id: String): Boolean {
        return libreMap.style?.removeLayer(id) ?: false
    }

    override fun removeLayerAt(index: Long): Boolean {
        return libreMap.style?.removeLayerAt(index.toInt()) ?: false
    }

    override fun removeSource(id: String): Boolean {
        return libreMap.style?.removeSource(id) ?: false
    }

    override fun removeImage(name: String) {
        libreMap.style?.removeImage(name)
    }

    override fun getImage(id: String): ByteArray {
        val image = libreMap.style?.getImage(id)

        val byteArray = image?.let { ImageUtils.bitmapToByteArray(it) }

        if (byteArray != null) return byteArray

        throw Exception("Image not found")
    }


    private fun isSourceExist(id: String?): Boolean {
        return if (id != null) {
            try {
                getSource(id)
                true
            } catch (e: Exception) {
                false
            }
        } else {
            false
        }
    }

}