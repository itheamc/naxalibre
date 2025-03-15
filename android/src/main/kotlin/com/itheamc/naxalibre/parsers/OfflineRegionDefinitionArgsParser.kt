package com.itheamc.naxalibre.parsers

import android.app.Activity
import org.maplibre.android.geometry.LatLng
import org.maplibre.android.geometry.LatLngBounds
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.offline.OfflineGeometryRegionDefinition
import org.maplibre.android.offline.OfflineRegionDefinition
import org.maplibre.android.offline.OfflineTilePyramidRegionDefinition

/**
 * Utility object responsible for parsing arguments and constructing [OfflineRegionDefinition] instances.
 *
 * This object provides a single method, [parseArgs], to create either an [OfflineTilePyramidRegionDefinition]
 * or an [OfflineGeometryRegionDefinition] based on the provided arguments. It handles various inputs
 * such as bounds, geometry, style URL, zoom levels, and pixel ratio, ensuring proper validation and default values.
 */
object OfflineRegionDefinitionArgsParser {

    /**
     * Parses the given arguments to construct an [OfflineRegionDefinition].
     *
     * @param args A map containing the arguments required for creating an offline region definition.
     * @param activity The current [Activity], used to access display metrics.
     * @param libreMap The [MapLibreMap] instance to fetch the style URL.
     * @return A constructed [OfflineRegionDefinition] instance.
     */
    fun parseArgs(
        args: Map<*, *>,
        activity: Activity,
        libreMap: MapLibreMap
    ): OfflineRegionDefinition {

        // LatLng Bounds
        val boundsArgs = args["bounds"] as? Map<*, *>

        // Geometry
        val geometryArgs = args["geometry"] as? Map<*, *>

        // Style URL
        val styleURL = args["styleUrl"] as? String ?: libreMap.style?.uri

        // Min Zoom
        val minZoom = args["minZoom"] as? Double ?: libreMap.minZoomLevel

        // Max Zoom
        val maxZoom = args["maxZoom"] as? Double ?: libreMap.maxZoomLevel

        // Pixel Ratio
        val pixelRatio = activity.resources.displayMetrics.density

        // Include Ideographs
        val includeIdeographs = args["includeIdeographs"] as? Boolean ?: true

        // If bounds args and geometry args both are null, throw an exception
        if (boundsArgs == null && geometryArgs == null) {
            throw IllegalArgumentException("Either 'bounds' or 'geometry' must be provided")
        }


        // If bounds args is not null, parse it
        // and return an OfflineTilePyramidRegionDefinition
        if (boundsArgs != null) {
            val northEast = boundsArgs["northeast"] as? List<*>
            val southWest = boundsArgs["southwest"] as? List<*>

            if (northEast == null || southWest == null) {
                throw IllegalArgumentException("Invalid bounds format")
            }

            val latLngBounds = LatLngBounds.fromLatLngs(
                listOf(
                    LatLng(southWest[0] as Double, southWest[1] as Double),
                    LatLng(northEast[0] as Double, northEast[1] as Double)
                )
            )

            return OfflineTilePyramidRegionDefinition(
                styleURL = styleURL,
                bounds = latLngBounds,
                minZoom = minZoom,
                maxZoom = maxZoom,
                pixelRatio = pixelRatio,
                includeIdeographs = includeIdeographs
            )
        }

        // Else parse geometry args
        // and return an OfflineGeometryRegionDefinition
        val geometry = GeometryArgsParser.parseArgs(geometryArgs!!)

        return OfflineGeometryRegionDefinition(
            styleURL = styleURL,
            geometry = geometry,
            minZoom = minZoom,
            maxZoom = maxZoom,
            pixelRatio = pixelRatio,
            includeIdeographs = includeIdeographs
        )
    }
}