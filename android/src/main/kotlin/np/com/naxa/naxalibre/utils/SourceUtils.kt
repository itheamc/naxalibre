package np.com.naxa.naxalibre.utils

import android.util.Log
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds
import org.maplibre.android.geometry.LatLngQuad
import org.maplibre.android.style.sources.GeoJsonOptions
import org.maplibre.android.style.sources.GeoJsonSource
import org.maplibre.android.style.sources.ImageSource
import org.maplibre.android.style.sources.RasterDemSource
import org.maplibre.android.style.sources.RasterSource
import org.maplibre.android.style.sources.RasterSource.Companion.DEFAULT_TILE_SIZE
import org.maplibre.android.style.sources.Source
import org.maplibre.android.style.sources.TileSet
import org.maplibre.android.style.sources.VectorSource
import java.net.URI

object SourceUtils {

    fun fromArgs(args: Map<String, Any?>): Source {
        val type = args["type"] as String?
        val details = args["details"] as Map<*, *>?

        if (type == null || details == null || details.isEmpty() || details["id"] == null) {
            throw IllegalArgumentException("Invalid source details")
        }

        val sourceId = details["id"].toString()
        val properties = details["properties"] as Map<*, *>?

        when (type) {
            "geojson" -> {
                val url = details["url"] as String?
                val data = details["data"] as String?

                if (url == null && data == null) {
                    throw IllegalArgumentException("Invalid geojson source details")
                }

                if (properties != null) {
                    val options = GeoJsonOptions()

                    val minZoom = properties["minzoom"] as Long?
                    val maxZoom = properties["maxzoom"] as Long?
                    val buffer = properties["buffer"] as Long?
                    val lineMetrics = properties["lineMetrics"] as Boolean?
                    val tolerance = properties["tolerance"] as Double?
                    val cluster = properties["cluster"] as Boolean?
                    val clusterRadius = properties["clusterRadius"] as Long?
                    val clusterMaxZoom = properties["clusterMaxZoom"] as Long?

                    if (minZoom != null) options.withMinZoom(minZoom.toInt())
                    if (maxZoom != null) options.withMaxZoom(maxZoom.toInt())
                    if (buffer != null) options.withBuffer(buffer.toInt())
                    if (lineMetrics != null) options.withLineMetrics(lineMetrics)
                    if (tolerance != null) options.withTolerance(tolerance.toFloat())
                    if (cluster != null) options.withCluster(cluster)
                    if (clusterRadius != null) options.withClusterRadius(clusterRadius.toInt())
                    if (clusterMaxZoom != null) options.withClusterMaxZoom(clusterMaxZoom.toInt())

                    val source = if (url != null) GeoJsonSource(
                        sourceId,
                        uri = URI.create(url),
                        options = options
                    ) else GeoJsonSource(sourceId, geoJson = data, options = options)

                    return source
                }

                val source = if (url != null) GeoJsonSource(
                    sourceId,
                    uri = URI.create(url),
                ) else GeoJsonSource(sourceId, geoJson = data)

                return source
            }

            "vector" -> {
                val url = details["url"] as String?
                val tilesArgs = details["tiles"] as List<*>?
                val tileSetArgs = details["tileSet"] as Map<*, *>?

                if (url == null && tilesArgs.isNullOrEmpty() && (tileSetArgs.isNullOrEmpty() || tileSetArgs["tiles"] == null)) {
                    throw IllegalArgumentException("Invalid vector source details")
                }

                val tiles =
                    tilesArgs?.mapNotNull { it.toString() }?.toTypedArray()
                        ?: (tileSetArgs!!["tiles"] as List<*>?)?.mapNotNull { it.toString() }
                            ?.toTypedArray() ?: arrayOf(url!!)

                val tileSet = TileSet(
                    tilejson = if (tileSetArgs != null) tileSetArgs["tileJson"]?.toString()
                        ?: "3.0.0" else "3.0.0",
                    tiles = tiles
                )

                var volatile: Boolean? = null
                var zoomDelta: Long? = null
                var tileUpdateInterval: Double? = null
                var maxOverScaleFactor: Long? = null

                if (properties != null) {

                    val bounds = properties["bounds"] as Map<*, *>?
                    val minZoom = properties["minzoom"] as Long?
                    val maxZoom = properties["maxzoom"] as Long?
                    val scheme = properties["scheme"] as String?
                    val attribution = properties["attribution"] as String?
                    volatile = properties["volatile"] as Boolean?
                    zoomDelta = properties["prefetchZoomDelta"] as Long?
                    tileUpdateInterval = properties["minimumTileUpdateInterval"] as Double?
                    maxOverScaleFactor = properties["maxOverScaleFactorForParentTiles"] as Long?

                    if (!bounds.isNullOrEmpty()) {
                        val southwest = bounds["southwest"] as List<*>
                        val northeast = bounds["northeast"] as List<*>

                        tileSet.setBounds(
                            LatLngBounds.fromLatLngs(
                                listOf(
                                    LatLng(southwest[0] as Double, southwest[1] as Double),
                                    LatLng(northeast[0] as Double, northeast[1] as Double)
                                )
                            )
                        )
                    }
                    if (minZoom != null) tileSet.minZoom = minZoom.toFloat()
                    if (maxZoom != null) tileSet.maxZoom = maxZoom.toFloat()
                    if (scheme != null) tileSet.scheme = scheme
                    if (attribution != null) tileSet.attribution = attribution

                }

                return VectorSource(id = sourceId, tileSet = tileSet).apply {
                    if (volatile != null) isVolatile = volatile!!
                    if (zoomDelta != null) prefetchZoomDelta = zoomDelta!!.toInt()
                    if (tileUpdateInterval != null) minimumTileUpdateInterval =
                        tileUpdateInterval!!.toLong()
                    if (maxOverScaleFactor != null) maxOverscaleFactorForParentTiles =
                        maxOverScaleFactor!!.toInt()

                }

            }

            "raster" -> {
                val url = details["url"] as String?
                val tilesArgs = details["tiles"] as List<*>?
                val tileSetArgs = details["tileSet"] as Map<*, *>?

                if (url == null && tilesArgs.isNullOrEmpty() && (tileSetArgs.isNullOrEmpty() || tileSetArgs["tiles"] == null)) {
                    throw IllegalArgumentException("Invalid raster source details")
                }

                val tiles =
                    tilesArgs?.mapNotNull { it.toString() }?.toTypedArray()
                        ?: (tileSetArgs?.get("tiles") as List<*>?)?.mapNotNull { it.toString() }
                            ?.toTypedArray() ?: arrayOf(url!!)

                val tileSet = TileSet(
                    tilejson = if (tileSetArgs != null) tileSetArgs["tileJson"]?.toString()
                        ?: "3.0.0" else "3.0.0",
                    tiles = tiles
                )

                var tileSize: Long? = null
                var volatile: Boolean? = null
                var zoomDelta: Long? = null
                var tileUpdateInterval: Double? = null
                var maxOverScaleFactor: Long? = null

                if (properties != null) {

                    val bounds = properties["bounds"] as Map<*, *>?
                    val minZoom = properties["minzoom"] as Long?
                    val maxZoom = properties["maxzoom"] as Long?
                    val scheme = properties["scheme"] as String?
                    val attribution = properties["attribution"] as String?
                    tileSize = properties["tileSize"] as Long?
                    volatile = properties["volatile"] as Boolean?
                    zoomDelta = properties["prefetchZoomDelta"] as Long?
                    tileUpdateInterval = properties["minimumTileUpdateInterval"] as Double?
                    maxOverScaleFactor = properties["maxOverScaleFactorForParentTiles"] as Long?

                    if (!bounds.isNullOrEmpty()) {
                        val southwest = bounds["southwest"] as List<*>
                        val northeast = bounds["northeast"] as List<*>

                        tileSet.setBounds(
                            LatLngBounds.fromLatLngs(
                                listOf(
                                    LatLng(southwest[0] as Double, southwest[1] as Double),
                                    LatLng(northeast[0] as Double, northeast[1] as Double)
                                )
                            )
                        )
                    }
                    if (minZoom != null) tileSet.minZoom = minZoom.toFloat()
                    if (maxZoom != null) tileSet.maxZoom = maxZoom.toFloat()
                    if (scheme != null) tileSet.scheme = scheme
                    if (attribution != null) tileSet.attribution = attribution

                }

                return RasterSource(
                    id = sourceId,
                    tileSet = tileSet,
                    tileSize = tileSize?.toInt() ?: DEFAULT_TILE_SIZE
                ).apply {
                    if (volatile != null) isVolatile = volatile ?: false
                    if (zoomDelta != null) prefetchZoomDelta = zoomDelta!!.toInt()
                    if (tileUpdateInterval != null) minimumTileUpdateInterval =
                        tileUpdateInterval!!.toLong()
                    if (maxOverScaleFactor != null) maxOverscaleFactorForParentTiles =
                        maxOverScaleFactor!!.toInt()

                }
            }

            "raster-dem" -> {
                val url = details["url"] as String?
                val tilesArgs = details["tiles"] as List<*>?
                val tileSetArgs = details["tileSet"] as Map<*, *>?

                if (url == null && tilesArgs.isNullOrEmpty() && (tileSetArgs.isNullOrEmpty() || tileSetArgs["tiles"] == null)) {
                    throw IllegalArgumentException("Invalid raster source details")
                }

                val tiles =
                    tilesArgs?.mapNotNull { it.toString() }?.toTypedArray()
                        ?: (tileSetArgs!!["tiles"] as List<*>?)?.mapNotNull { it.toString() }
                            ?.toTypedArray() ?: arrayOf(url!!)

                val tileSet = TileSet(
                    tilejson = if (tileSetArgs != null) tileSetArgs["tileJson"]?.toString()
                        ?: "3.0.0" else "3.0.0",
                    tiles = tiles
                )

                var tileSize: Long? = null
                var volatile: Boolean? = null
                var zoomDelta: Long? = null
                var tileUpdateInterval: Double? = null
                var maxOverScaleFactor: Long? = null

                if (properties != null) {

                    val bounds = properties["bounds"] as Map<*, *>?
                    val minZoom = properties["minzoom"] as Long?
                    val maxZoom = properties["maxzoom"] as Long?
                    val scheme = properties["scheme"] as String?
                    val attribution = properties["attribution"] as String?
                    val encoding = properties["encoding"] as String?
                    tileSize = properties["tileSize"] as Long?
                    volatile = properties["volatile"] as Boolean?
                    zoomDelta = properties["prefetchZoomDelta"] as Long?
                    tileUpdateInterval = properties["minimumTileUpdateInterval"] as Double?
                    maxOverScaleFactor = properties["maxOverScaleFactorForParentTiles"] as Long?

                    if (!bounds.isNullOrEmpty()) {
                        val southwest = bounds["southwest"] as List<*>
                        val northeast = bounds["northeast"] as List<*>

                        tileSet.setBounds(
                            LatLngBounds.fromLatLngs(
                                listOf(
                                    LatLng(southwest[0] as Double, southwest[1] as Double),
                                    LatLng(northeast[0] as Double, northeast[1] as Double)
                                )
                            )
                        )
                    }
                    if (minZoom != null) tileSet.minZoom = minZoom.toFloat()
                    if (maxZoom != null) tileSet.maxZoom = maxZoom.toFloat()
                    if (scheme != null) tileSet.scheme = scheme
                    if (attribution != null) tileSet.attribution = attribution
                    if (encoding != null) tileSet.encoding = encoding
                }

                return RasterDemSource(
                    id = sourceId,
                    tileSet = tileSet,
                    tileSize = tileSize?.toInt() ?: DEFAULT_TILE_SIZE
                ).apply {
                    if (volatile != null) isVolatile = volatile
                    if (zoomDelta != null) prefetchZoomDelta = zoomDelta.toInt()
                    if (tileUpdateInterval != null) minimumTileUpdateInterval =
                        tileUpdateInterval.toLong()
                    if (maxOverScaleFactor != null) maxOverscaleFactorForParentTiles =
                        maxOverScaleFactor.toInt()

                }
            }

            "image" -> {
                val url = details["url"] as String?
                val coordinates = details["coordinates"] as Map<*, *>?


                if (url == null || coordinates.isNullOrEmpty()) {
                    throw IllegalArgumentException("Invalid image source details")
                }

                val topLeft = coordinates["top_left"] as List<*>?
                val topRight = coordinates["top_right"] as List<*>?
                val bottomRight = coordinates["bottom_right"] as List<*>?
                val bottomLeft = coordinates["bottom_left"] as List<*>?

                if (topLeft.isNullOrEmpty() || topRight.isNullOrEmpty() || bottomRight.isNullOrEmpty() || bottomLeft.isNullOrEmpty()) {
                    throw IllegalArgumentException("Invalid image source details")
                }

                val topLeftLatLng = LatLng(topLeft.first() as Double, topLeft.last() as Double)
                val topRightLatLng = LatLng(topRight.first() as Double, topRight.last() as Double)
                val bottomRightLatLng =
                    LatLng(bottomRight.first() as Double, bottomRight.last() as Double)
                val bottomLeftLatLng =
                    LatLng(bottomLeft.first() as Double, bottomLeft.last() as Double)


                val zoomDelta: Long? =
                    if (properties != null && properties.containsKey("prefetchZoomDelta")) properties["prefetchZoomDelta"] as Long? else null


                return ImageSource(
                    sourceId,
                    LatLngQuad(topLeftLatLng, topRightLatLng, bottomRightLatLng, bottomLeftLatLng),
                    URI.create(url)
                ).apply {
                    if (zoomDelta != null) prefetchZoomDelta = zoomDelta.toInt()
                }
            }

            else -> {
                throw IllegalArgumentException("Invalid source type: $type")
            }

        }

    }
}