package com.itheamc.naxalibre.parsers

import com.itheamc.naxalibre.parsers.LayerArgsParser.layoutArgsToProperties
import com.itheamc.naxalibre.parsers.LayerArgsParser.paintArgsToProperties
import com.itheamc.naxalibre.parsers.LayerArgsParser.transitionArgsToTransitionOptions
import org.maplibre.android.style.expressions.Expression
import org.maplibre.android.style.layers.BackgroundLayer
import org.maplibre.android.style.layers.CircleLayer
import org.maplibre.android.style.layers.FillExtrusionLayer
import org.maplibre.android.style.layers.FillLayer
import org.maplibre.android.style.layers.HeatmapLayer
import org.maplibre.android.style.layers.HillshadeLayer
import org.maplibre.android.style.layers.Layer
import org.maplibre.android.style.layers.LineLayer
import org.maplibre.android.style.layers.RasterLayer
import org.maplibre.android.style.layers.SymbolLayer


/**
 * `UpdateLayerArgsParser` is a utility object that provides functionality for updating
 * MapLibre GL layers from a map of arguments. It supports various layer types including symbol,
 * fill, line, circle, raster, fill extrusion, heatmap, hillshade, and background layers.
 *
 * This object contains the main function parseAndUpdate used to update a layer.
 * It also contains helper functions to convert the layer properties and transitions from
 * the provided arguments.
 */
object UpdateLayerArgsParser {
    /**
     * Updates an existing [Layer] object with properties from a map of arguments.
     *
     * This function is responsible for parsing a map of arguments and applying
     * the updates to the appropriate type of map layer (e.g., SymbolLayer, FillLayer, LineLayer, etc.).
     * It handles different layer types, their properties (paint, layout, transitions),
     * filters, and zoom levels.
     *
     * @param layer The [Layer] object to be updated.
     * @param args A map containing the layer's details to update.
     *
     * @throws IllegalArgumentException If the provided layer type is not supported.
     *
     */
    fun parseAndUpdate(layer: Layer, args: Map<String, Any?>) {
        val properties = args["properties"] as Map<*, *>?

        when (layer) {
            is SymbolLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) this.sourceLayer = sourceLayer
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

            is FillLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) this.sourceLayer = sourceLayer
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

            is LineLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) this.sourceLayer = sourceLayer
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

            is CircleLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) this.sourceLayer = sourceLayer
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

            is RasterLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) setSourceLayer(sourceLayer)

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

                        val rasterBmt =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-brightness-min-transition"] as Map<*, *>?)
                        val rasterBmx =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-brightness-max-transition"] as Map<*, *>?)
                        val rasterS =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-saturation-transition"] as Map<*, *>?)
                        val rasterO =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-opacity-transition"] as Map<*, *>?)
                        val rasterH =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-hue-rotate-transition"] as Map<*, *>?)
                        val rasterC =
                            transitionArgsToTransitionOptions(transitionsArgs["raster-contrast-transition"] as Map<*, *>?)

                        if (rasterBmt != null) rasterBrightnessMinTransition = rasterBmt
                        if (rasterBmx != null) rasterBrightnessMaxTransition = rasterBmx
                        if (rasterS != null) rasterSaturationTransition = rasterS
                        if (rasterO != null) rasterOpacityTransition = rasterO
                        if (rasterH != null) rasterHueRotateTransition = rasterH
                        if (rasterC != null) rasterContrastTransition = rasterC
                    }

                }
            }

            is FillExtrusionLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (sourceLayer != null) setSourceLayer(sourceLayer)

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

                        val fillExb =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-base-transition"] as Map<*, *>?)


                        val fillExc =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-color-transition"] as Map<*, *>?)

                        val fillExh =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-height-transition"] as Map<*, *>?)

                        val fillExo =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-opacity-transition"] as Map<*, *>?)

                        val fillExp =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-pattern-transition"] as Map<*, *>?)

                        val fillExt =
                            transitionArgsToTransitionOptions(transitionsArgs["fill-extrusion-translate-transition"] as Map<*, *>?)

                        if (fillExb != null) fillExtrusionBaseTransition = fillExb
                        if (fillExc != null) fillExtrusionColorTransition = fillExc
                        if (fillExh != null) fillExtrusionHeightTransition = fillExh
                        if (fillExo != null) fillExtrusionOpacityTransition = fillExo
                        if (fillExp != null) fillExtrusionPatternTransition = fillExp
                        if (fillExt != null) fillExtrusionTranslateTransition = fillExt
                    }

                }
            }

            is HeatmapLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val filter = properties?.get("filter") as String?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (filter != null) setFilter(Expression.raw(filter))
                    if (sourceLayer != null) setSourceLayer(sourceLayer)

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

                        val heatmapInt =
                            transitionArgsToTransitionOptions(transitionsArgs["heatmap-intensity-transition"] as Map<*, *>?)

                        val heatmapOp =
                            transitionArgsToTransitionOptions(transitionsArgs["heatmap-opacity-transition"] as Map<*, *>?)

                        val heatmapRad =
                            transitionArgsToTransitionOptions(transitionsArgs["heatmap-radius-transition"] as Map<*, *>?)

                        if (heatmapInt != null) heatmapIntensityTransition = heatmapInt
                        if (heatmapOp != null) heatmapOpacityTransition = heatmapOp
                        if (heatmapRad != null) heatmapRadiusTransition = heatmapRad
                    }

                }
            }

            is HillshadeLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?
                val sourceLayer = properties?.get("source-layer") as String?

                layer.apply {
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()
                    if (sourceLayer != null) setSourceLayer(sourceLayer)

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

                        val hillShadeAct =
                            transitionArgsToTransitionOptions(transitionsArgs["hill-shade-accent-color-transition"] as Map<*, *>?)

                        val hillShadeEx =
                            transitionArgsToTransitionOptions(transitionsArgs["hill-shade-exaggeration-transition"] as Map<*, *>?)

                        val hillShadeHc =
                            transitionArgsToTransitionOptions(transitionsArgs["hill-shade-highlight-color-transition"] as Map<*, *>?)

                        val hillShadeSc =
                            transitionArgsToTransitionOptions(transitionsArgs["hill-shade-shadow-color-transition"] as Map<*, *>?)

                        if (hillShadeAct != null) hillshadeAccentColorTransition = hillShadeAct
                        if (hillShadeEx != null) hillshadeExaggerationTransition = hillShadeEx
                        if (hillShadeHc != null) hillshadeHighlightColorTransition = hillShadeHc
                        if (hillShadeSc != null) hillshadeShadowColorTransition = hillShadeSc
                    }

                }
            }

            is BackgroundLayer -> {
                val paintArgs = properties?.get("paint") as Map<*, *>?
                val layoutArgs = properties?.get("layout") as Map<*, *>?
                val transitionsArgs = properties?.get("transition") as Map<*, *>?
                val minZoom = properties?.get("minzoom") as Long?
                val maxZoom = properties?.get("maxzoom") as Long?

                layer.apply {
                    if (minZoom != null) this.minZoom = minZoom.toFloat()
                    if (maxZoom != null) this.maxZoom = maxZoom.toFloat()

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

                        val backgroundCt =
                            transitionArgsToTransitionOptions(transitionsArgs["background-color-transition"] as Map<*, *>?)

                        val backgroundOt =
                            transitionArgsToTransitionOptions(transitionsArgs["background-opacity-transition"] as Map<*, *>?)

                        val backgroundPt =
                            transitionArgsToTransitionOptions(transitionsArgs["background-pattern-transition"] as Map<*, *>?)


                        if (backgroundCt != null) backgroundColorTransition = backgroundCt
                        if (backgroundOt != null) backgroundOpacityTransition = backgroundOt
                        if (backgroundPt != null) backgroundPatternTransition = backgroundPt

                    }

                }
            }

            else -> throw IllegalArgumentException("Invalid layer")
        }
    }
}