package com.itheamc.naxalibre

import android.annotation.SuppressLint
import android.graphics.PointF
import android.view.MotionEvent
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import com.itheamc.naxalibre.parsers.AnnotationArgsParser
import com.itheamc.naxalibre.utils.JsonUtils
import org.maplibre.android.geometry.LatLng
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
 * Type alias for the listener that handles annotation drag events.
 *
 * This listener is invoked when an annotation is being dragged. It provides
 * information about the annotation being dragged, its updated state, and the
 * type of drag event.
 *
 * - id: The unique identifier of the annotation.
 * - type: The type of the annotation (e.g., Circle, Polyline, Polygon, Symbol).
 * - annotation: The original annotation object before the drag.
 * - updatedAnnotation: The updated annotation object after the drag.
 * - event: The type of drag event (e.g., "start", "drag", "end").
 */
typealias OnAnnotationDragListener = (id: Long, type: NaxaLibreAnnotationsManager.AnnotationType, annotation: NaxaLibreAnnotationsManager.Annotation<*>, updatedAnnotation: NaxaLibreAnnotationsManager.Annotation<*>, event: String) -> Unit

/**
 * Manages the creation, manipulation, and storage of annotations on a MapLibre map.
 *
 * This class acts as an intermediary between the Flutter application and the underlying
 * MapLibre map view, facilitating the addition of various types of annotations like circles,
 * polyline, polygons, and symbols. It handles the conversion of data from Flutter to
 * MapLibre-compatible objects and maintains a registry of all added annotations.
 *
 * @property libreView The MapLibre map view.
 * @property libreMap The MapLibre map instance.
 */
class NaxaLibreAnnotationsManager(
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
     * The annotation that is currently being dragged by the user.
     *
     * This property holds a reference to the [Annotation] instance that is currently
     * being manipulated (dragged) by the user within the view. If no annotation is
     * being dragged, this property will be `null`.
     *
     * It's crucial for tracking the state of the user interaction, especially when
     * implementing features like updating the annotation's position on the view
     * during a drag gesture or triggering actions upon the completion of a drag.
     *
     * The generic type parameter `*` indicates that this property can hold an
     * instance of any concrete subclass of `Annotation`.
     */
    var draggingAnnotation: Annotation<*>? = null

    /**
     * A list of listeners that will be notified when an annotation is dragged.
     *
     * Each listener is a lambda that takes the following parameters:
     *
     *  - id: The unique identifier of the annotation.
     *  - type: The type of the annotation (e.g., LINE, RECTANGLE, etc.).
     *  - annotation: The original annotation before the drag event.
     *  - updatedAnnotation: The annotation after the drag event has occurred, reflecting the new position/size.
     *  - event: The type of drag event that occurred. This can be used to differentiate between different stages of a drag, such as "start", "drag", and "end".
     *
     * The listener function is invoked whenever an annotation's position or size is changed due to a drag operation.
     * This allows for external components to be notified and react to these changes, such as updating UI or data structures.
     *
     */
    private val annotationDragListeners =
        mutableListOf<OnAnnotationDragListener>()

    /**
     * Adds a listener to be notified of annotation drag events.
     *
     * This function registers an [OnAnnotationDragListener] to receive callbacks
     * related to the dragging of annotations. The listener will be added to an
     * internal list of listeners and will be invoked whenever an annotation drag
     * event occurs. Multiple listeners can be added, and they will be notified
     * in the order they were added.
     *
     * @param listener The [OnAnnotationDragListener] to be added. This listener
     *
     */
    fun addAnnotationDragListener(listener: OnAnnotationDragListener) {
        annotationDragListeners.add(listener)
    }

    /**
     * Removes all registered annotation drag listeners.
     *
     * This function clears the internal list of listeners that are notified when
     * an annotation drag event occurs. After calling this function, no more
     * listeners will receive drag event notifications.
     *
     */
    fun removeAnnotationDragListeners() {
        annotationDragListeners.clear()
    }

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

    /**
     * Retrieves an annotation by its unique ID from the available annotation collections.
     *
     * This function searches through the `circleAnnotations`, `polylineAnnotations`,
     * `polygonAnnotations`, and `symbolAnnotations` in that order to find an annotation
     * with the matching ID. If an annotation with the specified ID is found in any of the
     * collections, it is converted to a `Map<String, Any?>` representation and returned.
     *
     * @param id The unique ID of the annotation to retrieve.
     * @return A `Map<String, Any?>` representing the found annotation, or `null` if no
     *         annotation with the specified ID is found in any of the collections.
     */
    fun getAnnotation(id: Long): Map<String, Any?>? {
        return allAnnotations.firstOrNull { it.id == id }?.toMap()
    }

    /**
     * Deletes an annotation from the map based on the provided arguments.
     *
     * This function removes a specific annotation (Circle, Polyline, Polygon, or Symbol)
     * from the map's style and the corresponding annotation list. It requires the
     * annotation's unique ID and its type to perform the deletion.
     *
     * @param args A map containing the arguments required for deleting the annotation.
     *             It should include the following key-value pairs:
     *             - "id": (Long) The unique identifier of the annotation to be deleted.
     *             - "type": (String) The type of the annotation (e.g., "Circle", "Polyline", "Polygon", "Symbol").
     *
     * @throws Exception If:
     *             - The `args` map is null.
     *             - The "id" argument is missing or is not a Long.
     *             - The "type" argument is missing or is not a valid AnnotationType.
     *             - Any issue occurs when removing layer or source from style.
     *
     */
    fun deleteAnnotation(args: Map<String, Any?>?) {
        args?.let {
            // Getting the id of the annotation
            val id = it["id"] as? Long ?: throw Exception("Id argument is required")

            // Getting the annotation type args from the arguments
            val typeArgs = it["type"] as? String

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
            } ?: throw Exception("Annotation type argument is required")

            // Handling delete as per type
            when (type) {
                AnnotationType.Circle -> {
                    circleAnnotations.firstOrNull { it.id == id }?.let {
                        libreMap.style?.removeLayer(it.layer.id)
                        libreMap.style?.removeSource(it.layer.sourceId)
                        circleAnnotations.remove(it)
                    }
                }

                AnnotationType.Polyline -> {
                    polylineAnnotations.firstOrNull { it.id == id }?.let {
                        libreMap.style?.removeLayer(it.layer.id)
                        libreMap.style?.removeSource(it.layer.sourceId)
                        polylineAnnotations.remove(it)
                    }
                }

                AnnotationType.Polygon -> {
                    polygonAnnotations.firstOrNull { it.id == id }?.let {
                        libreMap.style?.removeLayer(it.layer.id)
                        libreMap.style?.removeSource(it.layer.sourceId)
                        polygonAnnotations.remove(it)
                    }

                }

                AnnotationType.Symbol -> {
                    symbolAnnotations.firstOrNull { it.id == id }?.let {
                        libreMap.style?.removeLayer(it.layer.id)
                        libreMap.style?.removeSource(it.layer.sourceId)
                        symbolAnnotations.remove(it)
                    }
                }
            }
        } ?: throw Exception("Invalid arguments")
    }


    /**
     * Deletes all annotations of a specified type.
     * @param args A map containing the annotation type to be deleted
     * @throws Exception when arguments are invalid or the annotation type is missing or invalid
     */
    fun deleteAllAnnotations(args: Map<String, Any?>?) {
        if (args == null) throw Exception("Invalid arguments")

        // Extract and validate annotation type
        val typeString = args["type"] as? String
            ?: throw Exception("Annotation type argument is required")

        // Convert type string to enum with proper error handling
        val type = try {
            AnnotationType.valueOf(
                typeString.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault())
                    else it.toString()
                }
            )
        } catch (_: IllegalArgumentException) {
            throw Exception("Invalid annotation type: $typeString")
        }

        // Get annotation list based on type
        val annotations = when (type) {
            AnnotationType.Circle -> circleAnnotations
            AnnotationType.Polyline -> polylineAnnotations
            AnnotationType.Polygon -> polygonAnnotations
            AnnotationType.Symbol -> symbolAnnotations
        }

        // Use a reversed loop to avoid index issues during removal
        for (i in annotations.indices.reversed()) {
            val annotation = annotations[i]
            val sourceId = when (annotation.type) {
                AnnotationType.Circle -> (annotation.layer as CircleLayer).sourceId
                AnnotationType.Polyline -> (annotation.layer as LineLayer).sourceId
                AnnotationType.Polygon -> (annotation.layer as FillLayer).sourceId
                AnnotationType.Symbol -> (annotation.layer as SymbolLayer).sourceId
            }

            // Remove layer and source
            libreMap.style?.removeLayer(annotation.layer.id)
            libreMap.style?.removeSource(sourceId)

            // Remove from the correct collection based on type
            when (annotation.type) {
                AnnotationType.Circle -> circleAnnotations.removeAt(i)
                AnnotationType.Polyline -> polylineAnnotations.removeAt(i)
                AnnotationType.Polygon -> polygonAnnotations.removeAt(i)
                AnnotationType.Symbol -> symbolAnnotations.removeAt(i)
            }
        }
    }


    /**
     * Checks if an annotation exists at a given LatLng on the map.
     *
     * This function queries the rendered features on the map at the screen location
     * corresponding to the provided LatLng. It then checks if any of the found features
     * belong to the annotation layers managed by the libreAnnotationsManager.
     * If a feature is found and it has an "id" property, it's considered an annotation.
     *
     * @param latLng The LatLng (latitude and longitude) to check for annotations.
     * @return A Pair:
     *         - First element (Boolean): True if an annotation is found at the given LatLng, false otherwise.
     *         - Second element (JsonObject?): The properties of the first annotation found at the given LatLng, or null if no annotation is found.
     *                                        The properties are represented as a JsonObject.
     *
     * @throws Exception if there's an issue with map operations or querying features.
     *         Although the function catches and handles exceptions internally to return a default value.
     *
     */
    fun isAnnotationAtLatLng(latLng: LatLng): Pair<Boolean, JsonObject?> {
        return try {
            val point = libreMap.projection.toScreenLocation(latLng)

            val features = libreMap.queryRenderedFeatures(
                point,
                *allAnnotations.map { it.layer.id }.toTypedArray()
            )

            val first = features.firstOrNull()
            val properties = first?.properties()

            Pair(properties != null && properties.has("id"), properties)
        } catch (_: Exception) {
            Pair(false, null)
        }
    }

    /**
     * Checks if a given JSON object represents a draggable element.
     *
     * This function attempts to extract the value of the "draggable" key from the provided JSON object.
     * If the key exists and its value is a boolean `true`, the function returns `true`.
     * If the key is missing, the value is not a boolean, or any exception occurs during the process,
     * the function returns `false`.
     *
     * @param jsonObject The JSON object to check. Can be `null`.
     * @return `true` if the JSON object has a "draggable" key with a value of `true`, `false` otherwise.
     */
    fun isDraggable(jsonObject: JsonObject?): Boolean {
        return try {
            jsonObject?.get("draggable")?.asBoolean == true
        } catch (_: Exception) {
            false
        }
    }

    /**
     * Handles the start of a dragging operation for a specific annotation.
     *
     * This function takes a JsonObject containing annotation properties, extracts the annotation's ID,
     * and sets up the necessary state to track the dragging annotation. It also ensures that the
     * annotation drag listener is added if it hasn't been already.
     *
     * @param annotationProperties A JsonObject containing properties of the annotation that is being dragged.
     *  It is expected to have a property named "id" representing the unique
     *  identifier of the annotation.
     *
     */
    fun handleDragging(annotationProperties: JsonObject) {
        // Convert the annotation properties to a map
        val properties = JsonUtils.jsonToMap(Gson().toJson(annotationProperties), String::toString)

        // Parse the annotation id from properties
        val annotationId = properties["id"]?.toString()?.toDoubleOrNull()?.toLong()
        if (annotationId == null) return

        // Find the annotation from the all added annotations by id
        draggingAnnotation = allAnnotations.firstOrNull { it.id == annotationId }

        // Add the drag listener
        draggingAnnotation?.let {
            applyTouchListenerToDetectDrag()
        }
    }

    /**
     * Adds a touch listener to the `libreView` to handle dragging of annotations on the map.
     *
     * This function enables the dragging functionality for point, line, and polygon geometries.
     * It utilizes touch events to track the user's finger movements and updates the position of the
     * currently dragged annotation accordingly.
     *
     */
    @SuppressLint("ClickableViewAccessibility")
    private fun applyTouchListenerToDetectDrag() {
        var lastLatLng: LatLng? = null
        var dragging = false

        libreView.setOnTouchListener { _, event ->
            val currentLatLng = libreMap.projection.fromScreenLocation(PointF(event.x, event.y))

            // MotionEvent.ACTION_DOWN is not triggered so we need to handle it manually
            // with the help of dragging flag
            if (!dragging) {
                dragging = true
                lastLatLng = currentLatLng

                draggingAnnotation?.let { annotation ->
                    annotationDragListeners.forEach {
                        it.invoke(
                            annotation.id,
                            annotation.type,
                            annotation,
                            annotation,
                            "start"
                        )
                    }
                }
            }

            if (event.action == MotionEvent.ACTION_MOVE || event.action == MotionEvent.ACTION_UP || event.action == MotionEvent.ACTION_CANCEL) {
                val updated = when (val geometry = draggingAnnotation?.geometry) {
                    is Point -> handlePointDrag(currentLatLng, geometry)
                    is LineString -> handleLineDrag(currentLatLng, lastLatLng, geometry)
                    is Polygon -> handlePolygonDrag(currentLatLng, lastLatLng, geometry)
                    else -> null
                }

                updated?.let { updatedAnnotation ->
                    draggingAnnotation?.let { annotation ->
                        annotationDragListeners.forEach {
                            it.invoke(
                                updatedAnnotation.id,
                                updatedAnnotation.type,
                                annotation,
                                updatedAnnotation,
                                if (event.action == MotionEvent.ACTION_MOVE) "dragging" else "end"
                            )
                        }
                    }
                }
            }

            if (event.action == MotionEvent.ACTION_UP || event.action == MotionEvent.ACTION_CANCEL) {
                draggingAnnotation = null
                lastLatLng = null
                dragging = false
                return@setOnTouchListener false
            }

            return@setOnTouchListener draggingAnnotation != null
        }
    }


    /**
     * Handles the dragging of a point annotation on the map.
     *
     * This function updates the position of a dragged point annotation (either a Circle or a Symbol)
     * based on the new latitude and longitude provided by the drag event. It also takes into consideration
     * if the original geometry had altitude set and preserves it.
     *
     * @param currentLatLng The new LatLng representing the current position of the drag.
     * @param geometry The original Point geometry of the annotation being dragged. This is used to check for altitude.
     *
     * @return An updated Annotation object with the new geometry.
     *
     */
    private fun handlePointDrag(currentLatLng: LatLng, geometry: Point): Annotation<*>? {
        val newPoint = Point.fromLngLat(
            currentLatLng.longitude,
            currentLatLng.latitude,
            if (geometry.hasAltitude()) geometry.altitude() else currentLatLng.altitude
        )

        val updated = draggingAnnotation?.copy(geometry = newPoint) ?: return null

        when (updated.type) {
            AnnotationType.Circle -> updateCircleAnnotation(updated, newPoint)
            AnnotationType.Symbol -> updateSymbolAnnotation(updated, newPoint)
            else -> {}
        }

        return updated
    }


    /**
     * Handles the dragging of a line (LineString) on the map.
     *
     * This function is responsible for updating the coordinates of a LineString
     * when it's being dragged by the user. It calculates the change in longitude
     * and latitude between the current and previous drag positions and applies this
     * change to all points within the LineString.
     *
     * @param currentLatLng The current geographical position (LatLng) of the drag event.
     *                      This represents the new location where the user has dragged to.
     * @param lastLatLng The previous geographical position (LatLng) of the drag event.
     *                   This represents the starting location of the drag. If null,
     *                   it indicates the beginning of the drag, and the function returns early.
     * @param geometry The original LineString geometry being dragged. This is the
     *                 geometrical representation of the line.
     * @return An updated Annotation object with the new geometry.
     *
     */
    private fun handleLineDrag(
        currentLatLng: LatLng,
        lastLatLng: LatLng?,
        geometry: LineString
    ): Annotation<*>? {
        return lastLatLng?.let {
            // Calculate the delta between current and previous positions
            val deltaLng = currentLatLng.longitude - it.longitude
            val deltaLat = currentLatLng.latitude - it.latitude

            // Update all points in the line by applying the delta
            val updatedCoordinates = geometry.coordinates().map { point ->
                Point.fromLngLat(
                    point.longitude() + deltaLng,
                    point.latitude() + deltaLat,
                    if (point.hasAltitude()) point.altitude() else currentLatLng.altitude
                )
            }

            val newLineString = LineString.fromLngLats(updatedCoordinates)
            val updated = draggingAnnotation?.copy(geometry = newLineString) ?: return null

            updatePolylineAnnotation(updated, newLineString)

            updated
        }
    }


    /**
     * Handles the dragging of a polygon on the map.
     *
     * This function calculates the difference in longitude and latitude between the current
     * and previous drag positions and applies this difference (delta) to each point of the
     * polygon's rings, effectively moving the entire polygon.
     *
     * @param currentLatLng The current LatLng where the drag is occurring.
     * @param lastLatLng The previous LatLng where the drag occurred. If null, the function returns early as no drag has started or moved.
     * @param geometry The Polygon geometry that is being dragged.
     * @return An updated Annotation object with the new geometry.
     *
     */
    private fun handlePolygonDrag(
        currentLatLng: LatLng,
        lastLatLng: LatLng?,
        geometry: Polygon
    ): Annotation<*>? {
        return lastLatLng?.let {
            // Calculate the delta between current and previous positions
            val deltaLng = currentLatLng.longitude - it.longitude
            val deltaLat = currentLatLng.latitude - it.latitude

            // Update all points in each ring of the polygon by applying the delta
            val updatedRings = geometry.coordinates().map { ring ->
                ring.map { point ->
                    Point.fromLngLat(
                        point.longitude() + deltaLng,
                        point.latitude() + deltaLat,
                        if (point.hasAltitude()) point.altitude() else currentLatLng.altitude
                    )
                }
            }

            val newPolygon = Polygon.fromLngLats(updatedRings)
            val updated = draggingAnnotation?.copy(geometry = newPolygon) ?: return null

            updatePolygonAnnotation(updated, newPolygon)

            updated
        }
    }


    /**
     * Updates an existing circle annotation's geometry and replaces it in the internal list.
     *
     * @param updated The updated annotation object. It should contain the new properties for the circle annotation. It is expected that the layer of this annotation is a CircleLayer.
     * @param newGeometry The new geographical coordinates (latitude and longitude) as a `Point` where the circle annotation should be located.
     *
     */
    private fun updateCircleAnnotation(updated: Annotation<*>, newGeometry: Point) {
        val index = circleAnnotations.indexOfFirst { it.id == updated.id }
        if (index >= 0) {
            circleAnnotations.removeAt(index)
            circleAnnotations.add(index, updated as Annotation<CircleLayer>)
        }

        updateAnnotationSource(updated.layer, newGeometry)
    }


    /**
     * Updates an existing symbol annotation in the internal list and its source data.
     *
     * @param updated The updated annotation object. This object should contain the updated properties of the annotation,
     * but its ID should match the ID of the annotation being replaced. The type of the annotation should be `Annotation<LineLayer>`.
     * @param newGeometry The new point geometry that should be applied to the annotation's GeoJsonSource.
     *
     */
    private fun updateSymbolAnnotation(updated: Annotation<*>, newGeometry: Point) {
        val index = symbolAnnotations.indexOfFirst { it.id == updated.id }
        if (index >= 0) {
            symbolAnnotations.removeAt(index)
            symbolAnnotations.add(index, updated as Annotation<SymbolLayer>)
        }

        updateAnnotationSource(updated.layer, newGeometry)
    }


    /**
     * Updates a polyline annotation in the `polylineAnnotations` list and its associated GeoJsonSource.
     *
     * @param updated The updated annotation object. This object should contain the updated properties of the annotation,
     * but its ID should match the ID of the annotation being replaced. The type of the annotation should be `Annotation<LineLayer>`.
     * @param newGeometry The new LineString geometry that should be applied to the annotation's GeoJsonSource.
     *
     */
    private fun updatePolylineAnnotation(updated: Annotation<*>, newGeometry: LineString) {
        val index = polylineAnnotations.indexOfFirst { it.id == updated.id }
        if (index >= 0) {
            polylineAnnotations.removeAt(index)
            polylineAnnotations.add(index, updated as Annotation<LineLayer>)
        }

        updateAnnotationSource(updated.layer, newGeometry)
    }


    /**
     * Updates a polygon annotation in the `polygonAnnotations` list and its corresponding data source.
     *
     * @param updated The updated annotation object. It must be an `Annotation` instance with a type parameter compatible with `FillLayer`.
     * @param newGeometry The new `Polygon` geometry representing the updated shape of the annotation.
     *
     */
    private fun updatePolygonAnnotation(updated: Annotation<*>, newGeometry: Polygon) {
        val index = polygonAnnotations.indexOfFirst { it.id == updated.id }
        if (index >= 0) {
            polygonAnnotations.removeAt(index)
            polygonAnnotations.add(index, updated as Annotation<FillLayer>)
        }

        updateAnnotationSource(updated.layer, newGeometry)
    }


    /**
     * Updates the GeoJSON source of a given layer with a new geometry and associated properties.
     *
     * This function is designed to update the underlying data source of a Mapbox layer
     * (CircleLayer, SymbolLayer, LineLayer, or FillLayer) with a new geometric shape and
     * a set of properties. It is typically used to dynamically change the visual
     * representation of a feature on the map, such as when an annotation is dragged and
     * its location needs to be updated.
     *
     * @param layer       The Mapbox layer to update. Must be one of: CircleLayer, SymbolLayer,
     *                    LineLayer, or FillLayer. If the layer is null or of an unsupported type,
     *                    the function returns early without performing any action.
     * @param newGeometry The new geometry (e.g., Point, LineString, Polygon) to be associated
     *                    with the feature. This will replace the existing geometry in the data source.
     *
     */
    private fun updateAnnotationSource(layer: Layer?, newGeometry: Geometry) {
        val sourceId = when (layer) {
            is CircleLayer -> layer.sourceId
            is SymbolLayer -> layer.sourceId
            is LineLayer -> layer.sourceId
            is FillLayer -> layer.sourceId
            else -> return
        }

        val source = libreMap.style?.getSource(sourceId) as? GeoJsonSource ?: return

        val properties = JsonParser.parseString(
            JsonUtils.mapToJson(draggingAnnotation?.toMap() ?: emptyMap<String, Any?>())
        ).asJsonObject

        source.setGeoJson(Feature.fromGeometry(newGeometry, properties))
    }
}