package com.itheamc.naxalibre.parsers

import com.itheamc.naxalibre.NaxaLibreAnnotationsManager
import com.itheamc.naxalibre.NaxaLibreAnnotationsManager.AnnotationType
import com.itheamc.naxalibre.utils.IdUtils
import org.maplibre.android.style.expressions.Expression
import org.maplibre.android.style.layers.CircleLayer
import org.maplibre.android.style.layers.FillLayer
import org.maplibre.android.style.layers.Layer
import org.maplibre.android.style.layers.LayoutPropertyValue
import org.maplibre.android.style.layers.LineLayer
import org.maplibre.android.style.layers.PaintPropertyValue
import org.maplibre.android.style.layers.SymbolLayer
import org.maplibre.android.style.layers.TransitionOptions
import java.util.Locale

/**
 * `AnnotationArgsParser` is a utility object that provides functionality for creating and configuring
 * MapLibre GL annotations from a map of arguments. It supports various annotation types including symbol,
 * polygon, polyline ans circle annotations.
 *
 * This object contains the main function fromArgs used to generate a layer.
 * It also contains helper functions to convert the layer properties and transitions from
 * the provided arguments.
 */
object AnnotationArgsParser {

    fun <T : Layer> parseArgs(args: Map<*, *>?): NaxaLibreAnnotationsManager.Annotation<T> {
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

        // Getting the annotation id args from the arguments if for update
        val idArgs = try {
            args["id"] as? Long
        } catch (_: Exception) {
            null
        }

        // Creating the random annotation id if for new annotation else use the provided id
        val id = idArgs ?: (IdUtils.rand5() + IdUtils.rand4())

        // Creating layerId based on generated id
        val layerId = "libre_annotation_layer_$id"

        // Creating source id based on generated id
        val sourceId = "libre_annotation_source_$id"

        // Getting the annotation properties from the arguments
        val annotationOptions = args["options"] as Map<*, *>?

        // Getting the paint properties from the annotation options
        val paintArgs = annotationOptions?.get("paint") as Map<*, *>?

        // Getting the layout properties from the annotation options
        val layoutArgs = annotationOptions?.get("layout") as Map<*, *>?

        // Getting the transition properties from the annotation options
        val transitionsArgs = annotationOptions?.get("transition") as Map<*, *>?

        // Getting the data properties from the annotation options
        val data = (annotationOptions?.get("data") as? Map<*, *>)?.mapKeys { it.key.toString() }

        // Getting the draggable property from the annotation options
        val draggable = (annotationOptions?.get("draggable") as Boolean?) == true

        // Creating the layer based on the type
        val layer = when (type) {
            AnnotationType.Symbol -> {
                val modifiedLayoutArgs = layoutArgs?.toMutableMap()
                annotationOptions?.let {
                    modifiedLayoutArgs?.set("icon-image", "${it["icon-image"]}")
                }

                SymbolLayer(layerId, sourceId).apply {
                    when {
                        modifiedLayoutArgs != null && paintArgs != null -> {
                            setProperties(
                                *layoutArgsToProperties(
                                    modifiedLayoutArgs
                                ).toTypedArray(), *paintArgsToProperties(paintArgs).toTypedArray()
                            )
                        }

                        modifiedLayoutArgs != null -> {
                            setProperties(*layoutArgsToProperties(modifiedLayoutArgs).toTypedArray())
                        }

                        paintArgs != null -> {
                            setProperties(*paintArgsToProperties(paintArgs).toTypedArray())
                        }

                        else -> {
                            // Do nothing
                        }
                    }

                    if (transitionsArgs != null) {
                        val textCt =
                            transitionArgsToTransitionOptions(transitionsArgs["text-color-transition"] as Map<*, *>?)

                        val iconCt =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-color-transition"] as Map<*, *>?)

                        val textOt =
                            transitionArgsToTransitionOptions(transitionsArgs["text-opacity-transition"] as Map<*, *>?)

                        val iconOt =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-opacity-transition"] as Map<*, *>?)

                        val textHct =
                            transitionArgsToTransitionOptions(transitionsArgs["text-halo-color-transition"] as Map<*, *>?)

                        val iconHct =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-halo-color-transition"] as Map<*, *>?)

                        val textHwt =
                            transitionArgsToTransitionOptions(transitionsArgs["text-halo-width-transition"] as Map<*, *>?)

                        val iconHwt =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-halo-width-transition"] as Map<*, *>?)

                        val textTt =
                            transitionArgsToTransitionOptions(transitionsArgs["text-translate-transition"] as Map<*, *>?)

                        val iconTt =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-translate-transition"] as Map<*, *>?)

                        val textHbt =
                            transitionArgsToTransitionOptions(transitionsArgs["text-halo-blur-transition"] as Map<*, *>?)

                        val iconHbt =
                            transitionArgsToTransitionOptions(transitionsArgs["icon-halo-blur-transition"] as Map<*, *>?)

                        if (textCt != null) this.textColorTransition = textCt
                        if (iconCt != null) this.iconColorTransition = iconCt
                        if (textOt != null) this.textOpacityTransition = textOt
                        if (iconOt != null) this.iconOpacityTransition = iconOt
                        if (textHct != null) this.textHaloColorTransition = textHct
                        if (iconHct != null) this.iconHaloColorTransition = iconHct
                        if (textHwt != null) this.textHaloWidthTransition = textHwt
                        if (iconHwt != null) this.iconHaloWidthTransition = iconHwt
                        if (textTt != null) this.textTranslateTransition = textTt
                        if (iconTt != null) this.iconTranslateTransition = iconTt
                        if (textHbt != null) this.textHaloBlurTransition = textHbt
                        if (iconHbt != null) this.iconHaloBlurTransition = iconHbt
                    }

                }
            }

            AnnotationType.Polygon -> {
                FillLayer(layerId, sourceId).apply {
                    when {
                        layoutArgs != null && paintArgs != null -> {
                            setProperties(
                                *layoutArgsToProperties(
                                    layoutArgs
                                ).toTypedArray(), *paintArgsToProperties(paintArgs).toTypedArray()
                            )
                        }

                        layoutArgs != null -> {
                            setProperties(*layoutArgsToProperties(layoutArgs).toTypedArray())
                        }

                        paintArgs != null -> {
                            setProperties(*paintArgsToProperties(paintArgs).toTypedArray())
                        }

                        else -> {
                            // Do nothing
                        }
                    }

                    if (transitionsArgs != null) {
                        val fillTt =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-translate-transition"] as Map<*, *>?)

                        val fillPt =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-pattern-transition"] as Map<*, *>?)

                        val fillOct =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-outline-color-transition"] as Map<*, *>?)

                        val fillOt =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-opacity-transition"] as Map<*, *>?)

                        val fillCt =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-color-transition"] as Map<*, *>?)


                        if (fillTt != null) fillTranslateTransition = fillTt
                        if (fillPt != null) fillPatternTransition = fillPt
                        if (fillOct != null) fillOutlineColorTransition = fillOct
                        if (fillOt != null) fillOpacityTransition = fillOt
                        if (fillCt != null) fillColorTransition = fillCt
                    }

                }
            }

            AnnotationType.Polyline -> {
                LineLayer(layerId, sourceId).apply {
                    when {
                        layoutArgs != null && paintArgs != null -> {
                            setProperties(
                                *layoutArgsToProperties(
                                    layoutArgs
                                ).toTypedArray(), *paintArgsToProperties(paintArgs).toTypedArray()
                            )
                        }

                        layoutArgs != null -> {
                            setProperties(*layoutArgsToProperties(layoutArgs).toTypedArray())
                        }

                        paintArgs != null -> {
                            setProperties(*paintArgsToProperties(paintArgs).toTypedArray())
                        }

                        else -> {
                            // Do nothing
                        }
                    }

                    if (transitionsArgs != null) {

                        val lineWt =
                            transitionArgsToTransitionOptions(transitionsArgs["line-width-transition"] as Map<*, *>?)

                        val lineCt =
                            transitionArgsToTransitionOptions(transitionsArgs["line-color-transition"] as Map<*, *>?)

                        val lineBl =
                            transitionArgsToTransitionOptions(transitionsArgs["line-blur-transition"] as Map<*, *>?)

                        val lineDa =
                            transitionArgsToTransitionOptions(transitionsArgs["line-dash-array-transition"] as Map<*, *>?)

                        val lineGa =
                            transitionArgsToTransitionOptions(transitionsArgs["line-gap-width-transition"] as Map<*, *>?)


                        val lineOf =
                            transitionArgsToTransitionOptions(transitionsArgs["line-offset-transition"] as Map<*, *>?)

                        val lineOp =
                            transitionArgsToTransitionOptions(transitionsArgs["line-opacity-transition"] as Map<*, *>?)

                        val linePa =
                            transitionArgsToTransitionOptions(transitionsArgs["line-pattern-transition"] as Map<*, *>?)

                        val lineTr =
                            transitionArgsToTransitionOptions(transitionsArgs["line-translate-transition"] as Map<*, *>?)

                        if (lineWt != null) lineWidthTransition = lineWt
                        if (lineCt != null) lineColorTransition = lineCt
                        if (lineBl != null) lineBlurTransition = lineBl
                        if (lineDa != null) lineDasharrayTransition = lineDa
                        if (lineGa != null) lineGapWidthTransition = lineGa
                        if (lineOf != null) lineOffsetTransition = lineOf
                        if (lineOp != null) lineOpacityTransition = lineOp
                        if (linePa != null) linePatternTransition = linePa
                        if (lineTr != null) lineTranslateTransition = lineTr
                    }

                }
            }

            AnnotationType.Circle -> {
                CircleLayer(layerId, sourceId).apply {
                    when {
                        layoutArgs != null && paintArgs != null -> {
                            setProperties(
                                *layoutArgsToProperties(
                                    layoutArgs
                                ).toTypedArray(), *paintArgsToProperties(paintArgs).toTypedArray()
                            )
                        }

                        layoutArgs != null -> {
                            setProperties(*layoutArgsToProperties(layoutArgs).toTypedArray())
                        }

                        paintArgs != null -> {
                            setProperties(*paintArgsToProperties(paintArgs).toTypedArray())
                        }

                        else -> {
                            // Do nothing
                        }
                    }

                    if (transitionsArgs != null) {

                        val circleCt =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-color-transition"] as Map<*, *>?)

                        val circleRt =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-radius-transition"] as Map<*, *>?)

                        val circleBl =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-blur-transition"] as Map<*, *>?)

                        val circleOp =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-opacity-transition"] as Map<*, *>?)

                        val circleSt =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-stroke-color-transition"] as Map<*, *>?)

                        val circleSw =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-stroke-width-transition"] as Map<*, *>?)

                        val circleSo =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-stroke-opacity-transition"] as Map<*, *>?)

                        val circleTr =
                            transitionArgsToTransitionOptions(transitionsArgs["circle-translate-transition"] as Map<*, *>?)

                        if (circleCt != null) circleColorTransition = circleCt
                        if (circleRt != null) circleRadiusTransition = circleRt
                        if (circleBl != null) circleBlurTransition = circleBl
                        if (circleOp != null) circleOpacityTransition = circleOp
                        if (circleSt != null) circleStrokeColorTransition = circleSt
                        if (circleSw != null) circleStrokeWidthTransition = circleSw
                        if (circleSo != null) circleStrokeOpacityTransition = circleSo
                        if (circleTr != null) circleTranslateTransition = circleTr

                    }

                }
            }
        }

        return NaxaLibreAnnotationsManager.Annotation(
            id = id,
            type = type,
            layer = layer as T,
            data = data ?: emptyMap(),
            draggable = draggable
        )
    }


    /**
     * Method to convert layout args to [LayoutPropertyValue]
     */
    private fun layoutArgsToProperties(args: Map<*, *>): List<LayoutPropertyValue<Any>> {
        val properties = mutableListOf<LayoutPropertyValue<Any>>()

        for ((key, value) in args) {

            if (value is String && value.startsWith("[") && value.endsWith("]")) {
                val expression = Expression.raw(value)
                val property = LayoutPropertyValue<Any>(key.toString(), expression)
                properties.add(property)
                continue
            }

            val property = LayoutPropertyValue<Any>(key.toString(), value)
            properties.add(property)
        }

        return properties
    }

    /**
     * Method to convert paint args to [PaintPropertyValue]
     */
    private fun paintArgsToProperties(args: Map<*, *>): List<PaintPropertyValue<Any>> {
        val properties = mutableListOf<PaintPropertyValue<Any>>()

        for ((key, value) in args) {

            if (value is String && value.startsWith("[") && value.endsWith("]")) {
                val expression = Expression.raw(value)
                val property = PaintPropertyValue<Any>(key.toString(), expression)
                properties.add(property)
                continue
            }

            val property = PaintPropertyValue<Any>(key.toString(), value)
            properties.add(property)
        }

        return properties
    }

    /**
     * Method to convert transition args to [TransitionOptions]
     */
    private fun transitionArgsToTransitionOptions(args: Map<*, *>?): TransitionOptions? {

        if (args == null) return null

        val delay = args["delay"] as Long?
        val duration = args["duration"] as Long?

        if (delay == null || duration == null) {
            return null
        }

        return TransitionOptions(duration, delay)
    }
}