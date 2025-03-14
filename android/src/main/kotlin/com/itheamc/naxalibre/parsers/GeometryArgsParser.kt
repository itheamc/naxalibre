package com.itheamc.naxalibre.parsers

import com.itheamc.naxalibre.utils.JsonUtils
import org.maplibre.geojson.Geometry
import org.maplibre.geojson.LineString
import org.maplibre.geojson.MultiLineString
import org.maplibre.geojson.MultiPoint
import org.maplibre.geojson.MultiPolygon
import org.maplibre.geojson.Point
import org.maplibre.geojson.Polygon

/**
 * Utility object for parsing GeoJSON Geometry arguments.
 *
 * This object provides a function to parse a map of arguments into a GeoJSON Geometry object.
 * It handles the conversion from a map representation of a GeoJSON object to the corresponding
 * `Geometry` subclass.
 */
object GeometryArgsParser {

    /**
     * Parses a map of arguments into a GeoJSON Geometry object.
     *
     * This function takes a map of arguments, typically representing a GeoJSON object, and attempts to
     * deserialize it into a specific GeoJSON Geometry type. It expects the map to contain a "type"
     * key, which determines the specific GeoJSON geometry type. The rest of the map is then converted to json format to be able to be parsed.
     *
     * @param args A map containing the GeoJSON object's data. It must contain a "type" key whose value
     *             is a string representing the GeoJSON type (e.g., "Point", "LineString", etc.).
     *             Other keys and values in the map represent the geometry's coordinates and
     *             other properties.
     * @return A Geometry object corresponding to the specified type in the map, or `null` if:
     *         - The "type" key is missing or its value is not a string.
     *         - The "type" value is not one of the supported GeoJSON geometry types.
     *         - An error occurred during the deserialization of the JSON data.
     */
    fun parseArgs(args: Map<*, *>): Geometry? {
        // Extract the type from the args map
        // If type is null, return null
        val type = args["type"] as? String ?: return null

        // Else getting json string from args
        val jsonString = JsonUtils.mapToJson(args)

        // Convert the JSON string to a Geometry object
        // as per type and return it
        return when (type) {
            "Point" -> Point.fromJson(jsonString)
            "LineString" -> LineString.fromJson(jsonString)
            "Polygon" -> Polygon.fromJson(jsonString)
            "MultiPoint" -> MultiPoint.fromJson(jsonString)
            "MultiLineString" -> MultiLineString.fromJson(jsonString)
            "MultiPolygon" -> MultiPolygon.fromJson(jsonString)
            else -> null
        }
    }
}