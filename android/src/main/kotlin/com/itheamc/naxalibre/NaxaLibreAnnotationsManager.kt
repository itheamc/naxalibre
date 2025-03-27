package com.itheamc.naxalibre

import android.app.Activity
import com.google.gson.JsonParser
import com.itheamc.naxalibre.parsers.AnnotationArgsParser
import com.itheamc.naxalibre.utils.JsonUtils
import io.flutter.plugin.common.BinaryMessenger
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.maps.MapView
import org.maplibre.android.style.layers.CircleLayer
import org.maplibre.android.style.layers.FillLayer
import org.maplibre.android.style.layers.Layer
import org.maplibre.android.style.layers.LineLayer
import org.maplibre.android.style.layers.SymbolLayer
import org.maplibre.android.style.sources.GeoJsonSource
import org.maplibre.geojson.Feature
import org.maplibre.geojson.Geometry
import org.maplibre.geojson.LineString
import org.maplibre.geojson.Point
import org.maplibre.geojson.Polygon
import java.util.Locale

/**
 * Manages the creation, manipulation, and storage of annotations on a MapLibre map.
 *
 * This class acts as an intermediary between the Flutter application and the underlying
 * MapLibre map view, facilitating the addition of various types of annotations like circles,
 * polyline, polygons, and symbols. It handles the conversion of data from Flutter to
 * MapLibre-compatible objects and maintains a registry of all added annotations.
 *
 * @property binaryMessenger The binary messenger used for communication with the Flutter side.
 * @property activity The Android activity the map view is attached to.
 * @property libreView The MapLibre map view.
 * @property libreMap The MapLibre map instance.
 */
class NaxaLibreAnnotationsManager(
    private val binaryMessenger: BinaryMessenger,
    private val activity: Activity,
    private val libreView: MapView,
    private val libreMap: MapLibreMap,
) {

    /**
     * Represents the different types of annotations that can be drawn on a map or image.
     *
     * Each type defines a distinct visual representation and interaction behavior:
     *
     * - **Circle:**  Represents a circular area on the map. Useful for highlighting a region or showing a radius.
     * - **Polyline:** Represents a connected series of line segments. Ideal for paths, routes, or boundaries.
     * - **Polygon:** Represents a closed shape formed by connected line segments. Suitable for areas, regions, or buildings.
     * - **Symbol:** Represents a point marker with an associated icon or text label. Used for locations, points of interest, or icons.
     */
    enum class AnnotationType { Circle, Polyline, Polygon, Symbol }

    /**
     * Represents an annotation on a map, such as a marker, line, or polygon.
     *
     * An annotation consists of visual properties (paint), spatial properties (layout),
     * data associated with the annotation, and whether it can be dragged.
     *
     * @property id A unique identifier for the annotation.
     * @property type The type of the annotation (e.g., Marker, Line, Polygon).
     * @property layer The actual layer object representing the annotation on the map.
     * @property geometry The geometry of the annotation, such as a point, linestring, or polygon.
     * @property data A map of arbitrary key-value pairs associated with the annotation.
     *               This can be used to store custom data relevant to the annotation.
     *               Defaults to an empty map.
     * @property draggable Whether the annotation can be dragged by the user. Defaults to `false`.
     */
    data class Annotation<T>(
        val id: Long,
        val type: AnnotationType,
        val layer: T,
        val geometry: Geometry? = null,
        val data: Map<String, Any?> = emptyMap(),
        val draggable: Boolean = false,
    ) where T : Layer

    /**
     * Converts an Annotation object to a map representation.
     *
     * This function takes an `Annotation` object and transforms it into a `Map<String, Any?>` where:
     * - **"id"**: Represents the unique identifier of the annotation, converted to an Integer.
     * - **"type"**: Represents the name of the annotation type.
     * - **"data"**: Represents the data associated with the annotation.
     * - **"draggable"**: Represents whether the annotation is draggable.
     * - **"geometry"**: Represents the geometric information of the annotation, serialized to a JSON string
     *   and then converted to a map. If the geometry is null, this will be null.
     *
     * @param T The type of the Layer associated with the annotation.
     * @receiver The Annotation object to be converted.
     * @return A Map<String, Any?> representing the annotation's properties.
     * @throws Exception if there is an issue during Json conversion.
     *
     */
    private fun <T : Layer> Annotation<T>.toMap(): Map<String, Any?> {
        return mapOf(
            "id" to id.toInt(),
            "type" to type.name,
            "data" to data,
            "draggable" to draggable,
            "geometry" to geometry?.toJson()
                ?.let { JsonUtils.jsonToMap(it) { k -> k.toString() } }
        )
    }

    /**
     * A list of annotations representing circles drawn on the map.
     *
     * Each [Annotation] in this list represents a single circle.
     * These annotations can be used to visualize areas of interest,
     * radius around a point, or any other circular region on the map.
     *
     * The list is mutable, meaning annotations can be added or removed dynamically.
     *
     */
    private val circleAnnotations: MutableList<Annotation<CircleLayer>> = mutableListOf()


    /**
     * A list of annotations that represent polylines drawn on the map.
     *
     * Each annotation in this list defines a polyline's visual representation, including:
     * - The points (coordinates) that make up the polyline.
     * - The stroke (line) color, width, and other drawing properties.
     * - Any associated metadata or identifiers.
     *
     * These annotations are typically used to visually highlight routes, boundaries,
     * or other linear features on a map. They are rendered as a sequence of connected
     * line segments.
     *
     */
    private val polylineAnnotations: MutableList<Annotation<LineLayer>> = mutableListOf()

    /**
     * A list of annotations representing polygons drawn on the map.
     *
     * Each [Annotation] in this list represents a single polygon.
     * These annotations are used to visualize closed areas on the map.
     *
     * Polygons are defined by a list of coordinates that form their boundaries.
     *
     */
    private val polygonAnnotations: MutableList<Annotation<FillLayer>> = mutableListOf()

    /**
     * A list of annotations representing symbols (markers, icons) placed on the map.
     *
     * Each [Annotation] in this list represents a single symbol.
     * These annotations are used to mark specific points of interest on the map.
     *
     * Symbols can be customized with various icons, text labels, and other visual properties.
     *
     */
    private val symbolAnnotations: MutableList<Annotation<SymbolLayer>> = mutableListOf()


    /**
     * A list containing all annotations currently present on the map.
     * This includes circle, polyline, polygon, and symbol annotations.
     */
    val allAnnotations: List<Annotation<*>>
        get() = circleAnnotations + polylineAnnotations + polygonAnnotations + symbolAnnotations

    /**
     * Adds an annotation based on the provided arguments.
     *
     * This function takes a map of arguments and attempts to create an annotation of a specific type.
     * The "type" key in the map is used to determine the type of annotation.
     * The function currently checks for a valid annotation type and throws an exception if the provided type is valid.
     *
     * @param args A map containing the arguments for creating the annotation.
     *             It is expected to have a key "type" whose value is a string
     *             representing the desired annotation type.
     *             The string should match one of the values in the `AnnotationType` enum (case-insensitive).
     *
     * @throws Exception If the annotation type provided in the `args` map is valid.
     *                   This is currently intentional as the function logic expects an invalid type and throws an error when it is valid.
     *                   This behavior should be addressed in the future to properly add annotations.
     *
     * @throws ClassCastException If the value associated with the "type" key in the `args` map is not a String.
     * @throws IllegalArgumentException if the string value of the type does not match one of the enum values in `AnnotationType`.
     *
     */
    fun addAnnotation(args: Map<*, *>?): Map<String, Any?> {

        // Getting the annotation type args from the arguments
        val typeArgs = args?.get("type") as? String

        // Getting the annotation type from the type args
        val type = typeArgs?.let { t ->
            try {
                AnnotationType.valueOf(
                    t.replaceFirstChar {
                        if (it.isLowerCase()) it.titlecase(
                            Locale.getDefault()
                        ) else it.toString()
                    }
                )
            } catch (_: Exception) {
                null
            }
        }

        // Checking if the annotation type is valid
        // If it is not valid, throw an exception
        if (type == null) throw Exception("Invalid annotation type")

        // Adding the annotation based on the type
        val annotation = when (type) {
            AnnotationType.Circle -> addCircleAnnotation(args)
            AnnotationType.Polyline -> addPolylineAnnotation(args)
            AnnotationType.Polygon -> addPolygonAnnotation(args)
            AnnotationType.Symbol -> addSymbolAnnotation(args)
        }

        // Returning Map
        return annotation.toMap()
    }


    /**
     * Adds a circle annotation to the map.
     *
     * This function adds a circle to the map at a specified point with optional
     * styling and data. It handles the creation of the GeoJsonSource and CircleLayer
     * and adds them to the map's style.  It also supports updating existing circle annotations by
     * removing and re-adding them if they already exist. The function stores the created annotation
     * in the `circleAnnotations` list.
     *
     * @param args A map containing the arguments for the circle annotation. It should contain the following:
     *   - `options`: A map containing the options for the circle.
     *   - `point`: (Required) A list of two numbers representing the longitude and latitude of the circle's center.
     *              Example: `listOf(longitude, latitude)` where longitude and latitude are doubles.
     *   - `data`: (Optional) A map of string key-value pairs to associate with the circle. This data can be used
     *             later for interacting with the circle.
     *   - `draggable`: (Optional) A boolean indicating whether the circle can be dragged by the user. Defaults to `false`.
     *   -  Other options as defined by `AnnotationArgsParser.parseArgs<CircleLayer>`: Refer to documentation for `AnnotationArgsParser`
     *      and `CircleLayer` to learn about other possible options. These include styling properties like `circle-color`,
     *      `circle-radius`, etc.
     * @throws Exception If the `point` argument is missing or invalid.
     *   - "Point argument is required": If the `point` key is not present in the `options` map.
     *   - "Point argument must be a list of two numbers": If the `point` list contains fewer than two numbers, or contains non-numeric elements.
     * @throws Exception if `AnnotationArgsParser.parseArgs` throws an error
     *
     */
    private fun addCircleAnnotation(args: Map<*, *>?): Annotation<CircleLayer> {

        val optionsArgs = args?.get("options") as? Map<*, *>

        val pointArg =
            optionsArgs?.get("point") as? List<*> ?: throw Exception("Point argument is required")

        val point = pointArg.mapNotNull { it.toString().toDoubleOrNull() }
        if (point.size < 2) throw Exception("Point argument must be a list of two numbers")

        val annotation = AnnotationArgsParser.parseArgs<CircleLayer>(args = args).copy(
            geometry = Point.fromLngLat(point.last(), point.first()),
        )

        if (libreMap.style?.getLayer(annotation.layer.id) != null) {
            libreMap.style?.removeLayer(annotation.layer.id)
        }

        if (libreMap.style?.getSource(annotation.layer.sourceId) != null) {
            libreMap.style?.removeSource(annotation.layer.sourceId)
        }

        libreMap.style?.addSource(
            GeoJsonSource(
                annotation.layer.sourceId,
                Feature.fromGeometry(
                    annotation.geometry,
                    JsonParser.parseString(JsonUtils.mapToJson(annotation.toMap())).asJsonObject
                )
            )
        ).also {
            libreMap.style?.addLayer(annotation.layer)
        }

        circleAnnotations.add(annotation)

        return annotation
    }

    /**
     * Adds a polyline annotation to the map.
     *
     * This function takes a map of arguments, extracts the necessary data to define a polyline,
     * and then adds it as an annotation to the Mapbox map. The polyline is represented by a
     * sequence of geographic points. The function also supports custom data and draggable
     * properties for the polyline. It handles the addition and removal of layers and sources
     * if they already exist to avoid duplicates.
     *
     * @param args A map containing the necessary arguments for creating the polyline annotation.
     *   - `options` (Map): Contains the configuration for the polyline.
     *   - `points` (List<List<Double>>): A list of point coordinates. Each point is represented
     *        as a list of two doubles: [latitude, longitude]. **This is a required argument**.
     *   - `data` (Map<String, Any>?): Optional custom data to be associated with the polyline.
     *   - `draggable` (Boolean?): Optional. Indicates whether the polyline should be draggable.
     *        Defaults to `false`.
     *   - other keys are used to config the [LineLayer] annotation, such as `"id"`, `"sourceId"`, `"style"`
     *        and other supported properties from [LineLayer]
     *
     */
    private fun addPolylineAnnotation(args: Map<*, *>?): Annotation<LineLayer> {
        val optionsArgs = args?.get("options") as? Map<*, *>

        val pointsArg =
            optionsArgs?.get("points") as? List<*> ?: throw Exception("Points argument is required")

        val points = pointsArg.mapNotNull { it as? List<*> }.mapNotNull {
            if (it.size >= 2 && it.first() is Double) Point.fromLngLat(
                it[1] as Double,
                it[0] as Double
            ) else null
        }

        if (points.isEmpty()) throw Exception("Points argument must be a list of list double")

        val annotation = AnnotationArgsParser.parseArgs<LineLayer>(args = args).copy(
            geometry = LineString.fromLngLats(points),
        )

        if (libreMap.style?.getLayer(annotation.layer.id) != null) {
            libreMap.style?.removeLayer(annotation.layer.id)
        }

        if (libreMap.style?.getSource(annotation.layer.sourceId) != null) {
            libreMap.style?.removeSource(annotation.layer.sourceId)
        }

        libreMap.style?.addSource(
            GeoJsonSource(
                annotation.layer.sourceId,
                Feature.fromGeometry(
                    annotation.geometry,
                    JsonParser.parseString(JsonUtils.mapToJson(annotation.toMap())).asJsonObject
                )
            )
        ).also {
            libreMap.style?.addLayer(annotation.layer)
        }

        polylineAnnotations.add(annotation)

        return annotation
    }

    /**
     * Adds a polygon annotation to the map.
     *
     * This function takes a map of arguments to define the polygon's properties,
     * including its vertices, associated data, and draggable state. It creates
     * a new polygon layer on the map using the provided information. If a layer or source with the same id
     * already exists it will remove it before add the new one.
     *
     * @param args A map containing the arguments for the polygon annotation.
     *   It should contain the following keys within the "options" nested map:
     *   - points: (Required) A list of lists of doubles, representing the
     *               coordinates of the polygon's vertices. Each inner list
     *               should contain two doubles: [longitude, latitude].
     *               Example: `[[10.0, 20.0], [30.0, 40.0], [50.0, 20.0]]`
     *               The points must be in longitude, latitude order.
     *               The list of points must be a closed polygon
     *   - data: (Optional) A map of key-value pairs representing custom
     *             data associated with the polygon. Keys should be strings.
     *   - draggable: (Optional) A boolean indicating whether the polygon
     *                  should be draggable. Defaults to `false`.
     *   - and the rest of the argument from [AnnotationArgsParser.parseArgs]
     *
     */
    private fun addPolygonAnnotation(args: Map<*, *>?): Annotation<FillLayer> {
        val optionsArgs = args?.get("options") as? Map<*, *>

        val pointsArg =
            optionsArgs?.get("points") as? List<*> ?: throw Exception("Points argument is required")

        val points =
            pointsArg.mapNotNull { l1 -> (l1 as? List<*>)?.mapNotNull { l2 -> l2 as? List<*> } }
                .map { l1 ->
                    l1.mapNotNull { l2 ->
                        if (l2.size >= 2 && l2.first() is Double) Point.fromLngLat(
                            l2[1] as Double,
                            l2[0] as Double
                        ) else null
                    }
                }

        if (points.isEmpty()) throw Exception("Points argument must be a list of list double")

        val annotation = AnnotationArgsParser.parseArgs<FillLayer>(args = args).copy(
            geometry = Polygon.fromLngLats(points),
        )

        if (libreMap.style?.getLayer(annotation.layer.id) != null) {
            libreMap.style?.removeLayer(annotation.layer.id)
        }

        if (libreMap.style?.getSource(annotation.layer.sourceId) != null) {
            libreMap.style?.removeSource(annotation.layer.sourceId)
        }

        libreMap.style?.addSource(
            GeoJsonSource(
                annotation.layer.sourceId,
                Feature.fromGeometry(
                    annotation.geometry,
                    JsonParser.parseString(JsonUtils.mapToJson(annotation.toMap())).asJsonObject
                )
            )
        ).also {
            libreMap.style?.addLayer(annotation.layer)
        }

        polygonAnnotations.add(annotation)

        return annotation
    }

    /**
     * Adds a symbol annotation to the map.
     *
     * This function takes a map of arguments, extracts necessary information,
     * constructs a symbol annotation object, and adds it to the map's style.
     * It handles creating or updating the necessary source and layer for the
     * annotation and manages a collection of all symbol annotations.
     *
     * @param args A map containing the arguments for the symbol annotation.
     *             If "options" is null or not a map, it's ignored.
     *             If "point" is not provided in "options" or it's not a list of two numbers, an exception will be thrown.
     *             If "data" is not provided, it defaults to an empty map.
     *             If "draggable" is not provided, it defaults to false.
     * @throws Exception Throws an exception if:
     *                  - The "point" argument is missing.
     *                  - The "point" argument is not a list of two numbers.
     *
     */
    private fun addSymbolAnnotation(args: Map<*, *>?): Annotation<SymbolLayer> {
        val optionsArgs = args?.get("options") as? Map<*, *>

        val pointArg =
            optionsArgs?.get("point") as? List<*> ?: throw Exception("Point argument is required")

        val point = pointArg.mapNotNull { it.toString().toDoubleOrNull() }
        if (point.size < 2) throw Exception("Point argument must be a list of two numbers")

        val annotation = AnnotationArgsParser.parseArgs<SymbolLayer>(args = args).copy(
            geometry = Point.fromLngLat(point.last(), point.first()),
        )

        if (libreMap.style?.getLayer(annotation.layer.id) != null) {
            libreMap.style?.removeLayer(annotation.layer.id)
        }

        if (libreMap.style?.getSource(annotation.layer.sourceId) != null) {
            libreMap.style?.removeSource(annotation.layer.sourceId)
        }

        libreMap.style?.addSource(
            GeoJsonSource(
                annotation.layer.sourceId,
                Feature.fromGeometry(
                    annotation.geometry,
                    JsonParser.parseString(JsonUtils.mapToJson(annotation.toMap())).asJsonObject
                )
            )
        ).also {
            libreMap.style?.addLayer(annotation.layer)
        }

        symbolAnnotations.add(annotation)

        return annotation
    }

}