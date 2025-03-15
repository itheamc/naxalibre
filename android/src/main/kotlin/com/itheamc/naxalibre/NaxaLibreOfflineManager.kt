package com.itheamc.naxalibre

import DoubleEvent
import IntEvent
import NaxaLibreEvent
import PigeonEventSink
import StreamEventsStreamHandler
import android.app.Activity
import com.itheamc.naxalibre.parsers.OfflineRegionDefinitionArgsParser
import com.itheamc.naxalibre.utils.JsonUtils
import io.flutter.plugin.common.BinaryMessenger
import org.maplibre.android.maps.MapLibreMap
import org.maplibre.android.offline.OfflineGeometryRegionDefinition
import org.maplibre.android.offline.OfflineManager
import org.maplibre.android.offline.OfflineRegion
import org.maplibre.android.offline.OfflineRegionError
import org.maplibre.android.offline.OfflineRegionStatus
import java.nio.charset.StandardCharsets

/**
 * Manages offline map capabilities within the NaxaLibre application.
 *
 * This class provides functionality for downloading, managing, and monitoring offline map regions.
 * It interacts with MapLibre's [OfflineManager] to handle offline data storage and retrieval.
 *
 * @param binaryMessenger The [BinaryMessenger] used for communication with Flutter.
 * @param activity The current [Activity] context.
 * @param libreMap The [MapLibreMap] instance.
 */
class NaxaLibreOfflineManager(
    private val binaryMessenger: BinaryMessenger,
    private val activity: Activity,
    private val libreMap: MapLibreMap,
) {


    /**
     * An instance of the LibreOffice OfflineManager.
     *
     * This property provides access to the LibreOffice OfflineManager, which is responsible
     * for managing offline capabilities of the LibreOffice application. This includes features
     * like caching, offline document access, and synchronization.
     *
     * The instance is lazily initialized, meaning it is only created when it's first accessed.
     * Subsequent accesses will return the same instance.
     *
     * It's initialized with the application context to ensure it has the necessary resources
     * for managing offline operations.
     */
    private val libreOfflineManager by lazy { OfflineManager.getInstance(activity.applicationContext) }


    /**
     * A mutable map storing the currently downloading offline regions.
     *
     * Key: The region's ID (Long).
     * Value: The OfflineRegion object representing the downloading region.
     *
     * This map is used to keep track of the offline regions that are currently
     * being downloaded, allowing for easy access and management of these regions.
     */
    private var downloadingRegions = mutableMapOf<Long, OfflineRegion>()

    /**
     * Downloads a region for offline use based on provided arguments.
     *
     * This function takes a map of arguments containing the region's definition and metadata,
     * parses them, and then initiates the offline download using the LibreOfflineManager.
     *
     * @param args A map containing the following keys:
     *  - "definition": A map describing the offline region definition.
     *  - "metadata": A map containing metadata associated with the offline region.
     *
     * @throws ClassCastException if the "definition" or "metadata" values in the `args` map are not maps.
     * @throws Exception if `OfflineRegionDefinitionArgsParser.parseArgs()` throws an exception.
     *                 (or any other errors during metadata conversion)
     *
     * @see OfflineRegionDefinitionArgsParser
     * @see JsonUtils
     */
    fun download(
        args: Map<String, Any?>,
        callback: (Result<Map<Any?, Any?>>) -> Unit
    ) {
        // Download Progress Event Listener
        val progressEventListener = DownloadProgressEventListener()

        // Setting stream handler
        StreamEventsStreamHandler.register(binaryMessenger, progressEventListener)

        // Defining region variable for temporary usages
        var region: OfflineRegion? = null

        try {
            // Definition
            val definitionArgs = args["definition"] as? Map<*, *>
                ?: throw IllegalArgumentException("Missing or invalid 'definition' in arguments")
            val definition = OfflineRegionDefinitionArgsParser.parseArgs(
                definitionArgs, activity, libreMap
            )

            // Metadata
            val metadataArgs = args["metadata"] as? Map<*, *>
                ?: throw IllegalArgumentException("Missing or invalid 'metadata' in arguments")
            val metadataObject = JsonUtils.mapToJson(metadataArgs)
            val metadata = metadataObject.toByteArray()

            // Creating Offline Region
            libreOfflineManager.createOfflineRegion(
                definition,
                metadata,
                object : OfflineManager.CreateOfflineRegionCallback {
                    override fun onCreate(offlineRegion: OfflineRegion) {

                        // Triggering success event
                        callback.invoke(Result.success(regionAsArgs(offlineRegion)))

                        // Triggering on started download event
                        progressEventListener.onDownloadStarted(offlineRegion.id)

                        // Setting download state to active
                        offlineRegion.setDownloadState(OfflineRegion.STATE_ACTIVE)

                        // Updating temporary region variable
                        region = offlineRegion

                        // Adding region to downloading regions
                        downloadingRegions[offlineRegion.id] = offlineRegion

                        // Monitor the download progress using setObserver
                        offlineRegion.setObserver(object : OfflineRegion.OfflineRegionObserver {
                            override fun onStatusChanged(status: OfflineRegionStatus) {
                                // Calculate the download progress
                                val progress = if (status.requiredResourceCount > 0)
                                    status.completedResourceCount.toDouble() / status.requiredResourceCount.toDouble() else 0.0

                                // Triggering on downloading event
                                progressEventListener.onDownloading(progress)

                                // If download is complete, trigger onDownloaded event
                                if (status.isComplete) {
                                    // Download complete
                                    progressEventListener.onDownloaded()
                                    offlineRegion.setDownloadState(OfflineRegion.STATE_INACTIVE)
                                    // Remove the observer to prevent memory leaks
                                    offlineRegion.setObserver(null)
                                    downloadingRegions.remove(offlineRegion.id)
                                }
                            }

                            override fun mapboxTileCountLimitExceeded(limit: Long) {
                                // Handle tile count limit exceeded
                                val errorMessage = "Tile limit exceeded: $limit tiles"
                                progressEventListener.onError(errorMessage)
                                offlineRegion.setDownloadState(OfflineRegion.STATE_INACTIVE)
                                offlineRegion.setObserver(null)
                                downloadingRegions.remove(offlineRegion.id)
                            }

                            override fun onError(error: OfflineRegionError) {
                                progressEventListener.onError(error.message)
                                offlineRegion.setDownloadState(OfflineRegion.STATE_INACTIVE)
                                offlineRegion.setObserver(null)
                                downloadingRegions.remove(offlineRegion.id)
                            }
                        })
                    }

                    override fun onError(error: String) {
                        progressEventListener.onError(error)
                        downloadingRegions.remove(region?.id)
                        callback.invoke(Result.failure(Exception(error)))
                    }
                }
            )
        } catch (e: Exception) {
            progressEventListener.onError("Failed to start download: ${e.message}")
            downloadingRegions.remove(region?.id)
            callback.invoke(Result.failure(e))
        }
    }


    /**
     * Cancels the download of an offline region with the given ID.
     *
     * This function attempts to cancel an ongoing download identified by the provided [id].
     * It retrieves the corresponding [OfflineRegion] from the [downloadingRegions] map.
     * If a region with the given ID is found, it sets its state to [OfflineRegion.STATE_INACTIVE],
     * removes any existing observers, and then invokes the [callback] with a successful result.
     * If any exception occurs during the cancellation process, the [callback] is invoked with
     * a failure result containing the exception.
     *
     * If no region is found with the specified ID in [downloadingRegions], this function does nothing.
     *
     * @param id The unique identifier of the offline region to cancel.
     * @param callback A lambda function that is called with the result of the cancellation attempt.
     *                 - [Result.success(true)] if the cancellation was successful.
     *                 - [Result.failure(e)] if an error occurred during cancellation, where `e` is the exception.
     */
    fun cancelDownload(
        id: Long,
        callback: (Result<Boolean>) -> Unit
    ) {
        downloadingRegions[id]?.let {
            try {
                it.setDownloadState(OfflineRegion.STATE_INACTIVE)
                it.setObserver(null)
                callback(Result.success(true))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    /**
     * Retrieves an offline region from the LibreOfflineManager by its ID.
     *
     * This function attempts to fetch an offline region based on the provided `id`.
     * It uses a callback to communicate the result of the operation, whether it
     * succeeded or failed.
     *
     * @param id The ID of the offline region to retrieve.
     * @param callback A callback function that will be invoked with the result of the operation.
     *   - On success: The callback receives a `Result.success` containing a map.
     *   - On failure: The callback receives a `Result.failure` containing an `Exception` with
     *     an error message indicating the cause of the failure.
     *     Possible error messages:
     *       - "Region not found": If the region with the specified ID does not exist.
     *       - Any error message returned by the underlying `OfflineManager`.
     *       - The error message of any `Exception` thrown during the operation.
     *
     * @throws Exception if any error occurs during the process of retrieving the region. The error will be passed through the result callback.
     */
    fun getRegion(
        id: Long,
        callback: (Result<Map<Any?, Any?>>) -> Unit
    ) {
        try {
            libreOfflineManager.getOfflineRegion(
                id,
                object : OfflineManager.GetOfflineRegionCallback {
                    override fun onError(error: String) {
                        callback(Result.failure(Exception(error)))
                    }

                    override fun onRegion(offlineRegion: OfflineRegion) {
                        callback(Result.success(regionAsArgs(offlineRegion)))
                    }

                    override fun onRegionNotFound() {
                        callback(Result.failure(Exception("Region not found")))
                    }
                }
            )
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Lists all currently available offline regions.
     *
     * This function asynchronously retrieves a list of offline regions managed by the Mapbox Offline Manager.
     * It communicates the result via a callback function.
     *
     * @param callback A callback function that will be invoked with the result of the operation.
     *   The callback receives a `Result` object which can be either:
     *   - `Result.success(List<Map<Any?, Any?>>)`: If the operation was successful,
     *     this contains a list of maps, each representing an offline region.
     *   - `Result.failure(Exception)`: If the operation failed, this contains an `Exception`
     *     describing the error.
     *
     * @throws Exception If an unexpected error occurs during the listing process, it will be caught
     *                 and delivered to the callback as a `Result.failure`.
     */
    fun listRegions(
        callback: (Result<List<Map<Any?, Any?>>>) -> Unit
    ) {
        try {
            libreOfflineManager.listOfflineRegions(
                object : OfflineManager.ListOfflineRegionsCallback {
                    override fun onError(error: String) {
                        callback(Result.failure(Exception(error)))
                    }

                    override fun onList(offlineRegions: Array<OfflineRegion>?) {
                        val list = offlineRegions?.map { regionAsArgs(it) } ?: emptyList()
                        callback(Result.success(list))
                    }
                }
            )
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Deletes an offline region with the specified ID.
     *
     * This function attempts to delete an offline region identified by the given `id`.
     * It uses the `OfflineManager` to retrieve the region and then initiates the deletion process.
     * The result of the operation (success or failure) is communicated through the provided `callback`.
     *
     * @param id The ID of the offline region to delete.
     * @param callback A callback function that receives the result of the deletion attempt.
     *
     * @throws Exception if an unexpected error occurs during the process. (Wrapped in the Result.failure)
     */
    fun deleteRegion(id: Long, callback: (Result<Boolean>) -> Unit) {
        try {
            libreOfflineManager.getOfflineRegion(
                id,
                object : OfflineManager.GetOfflineRegionCallback {
                    override fun onError(error: String) {
                        callback(Result.failure(Exception(error)))
                    }

                    override fun onRegion(offlineRegion: OfflineRegion) {
                        offlineRegion.delete(object : OfflineRegion.OfflineRegionDeleteCallback {
                            override fun onDelete() {
                                callback(Result.success(true))
                            }

                            override fun onError(error: String) {
                                callback(Result.failure(Exception(error)))
                            }
                        })
                    }

                    override fun onRegionNotFound() {
                        callback(Result.failure(Exception("Region not found")))
                    }
                }
            )
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Deletes all offline regions managed by the `libreOfflineManager`.
     *
     * This function asynchronously retrieves a list of all offline regions and then proceeds to
     * delete them one by one. It provides detailed feedback on the success or failure of each deletion
     * through the `callback`.
     *
     * @param callback A lambda function that receives the result of the operation.
     *
     */
    fun deleteAllRegions(callback: (Result<Map<Long, Boolean>>) -> Unit) {
        try {
            libreOfflineManager.listOfflineRegions(
                object : OfflineManager.ListOfflineRegionsCallback {
                    override fun onError(error: String) {
                        callback(Result.failure(Exception(error)))
                    }

                    override fun onList(offlineRegions: Array<OfflineRegion>?) {
                        val response = emptyMap<Long, Boolean>().toMutableMap()
                        deleteOfflineRegionsRecursively(
                            offlineRegions,
                            onSuccess = { id ->
                                response[id] = true
                            },
                            onError = { id, _ ->
                                response[id] = false
                            },
                            onComplete = {
                                callback(Result.success(response))
                            },
                        )
                    }
                }
            )
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    /**
     * Recursively deletes offline regions.
     *
     * This function deletes offline regions one by one in a recursive manner
     * to ensure they are deleted sequentially.
     *
     * @param offlineRegions The array of offline regions to delete
     * @param index The current index in the array (default 0 to start at the beginning)
     * @param onComplete Callback invoked when all regions are deleted
     * @param onError Callback invoked if any error occurs during deletion
     */
    private fun deleteOfflineRegionsRecursively(
        offlineRegions: Array<OfflineRegion>?,
        index: Int = 0,
        onComplete: () -> Unit,
        onSuccess: (Long) -> Unit,
        onError: (Long, String) -> Unit,
    ) {
        // If regions are null or empty, or we've processed all regions, call onComplete
        if (offlineRegions.isNullOrEmpty() || index >= offlineRegions.size) {
            onComplete()
            return
        }

        // Getting region from array
        val region = offlineRegions[index]

        // Delete the current region
        region.delete(object : OfflineRegion.OfflineRegionDeleteCallback {
            override fun onDelete() {
                // Call the onSuccess callback
                onSuccess(region.id)

                // Successfully deleted this region, move to the next one
                deleteOfflineRegionsRecursively(
                    offlineRegions,
                    index + 1,
                    onComplete,
                    onSuccess,
                    onError
                )
            }

            override fun onError(error: String) {
                // If there's an error, call the onError callback
                onError(region.id, error)

                // Continue with the next region even if there was an error with this one
                deleteOfflineRegionsRecursively(
                    offlineRegions,
                    index + 1,
                    onComplete,
                    onSuccess,
                    onError
                )
            }
        })
    }

    /**
     * Converts an `OfflineRegion` object into a map of arguments suitable for inter-process communication or data serialization.
     *
     * This function extracts the relevant information from an `OfflineRegion` and its definition, metadata, and ID,
     * then structures it into a `Map<String, Any?>` for easier handling in different contexts.
     *
     * @param region The `OfflineRegion` object to convert.
     * @return A `Map<String, Any?>` containing the region's ID, definition details, and metadata.
     */
    private fun regionAsArgs(region: OfflineRegion): Map<Any?, Any?> {

        // Getting metadata from region
        val metadata = region.metadata

        // Convert ByteArray back to String
        val metadataJsonString = metadata.toString(StandardCharsets.UTF_8)

        // Convert JSONObject to map
        val metadataMap = JsonUtils.jsonToMap(metadataJsonString, keyConverter = { k -> k })

        // Converting definition to map
        val definition = mapOf<String, Any?>(
            "styleUrl" to region.definition.styleURL,
            "minZoom" to region.definition.minZoom,
            "maxZoom" to region.definition.maxZoom,
            "pixelRatio" to region.definition.pixelRatio,
            "includeIdeographs" to region.definition.includeIdeographs
        ).toMutableMap()

        // If region definition is OfflineGeometryRegionDefinition
        // Adding geometry to definition
        // Else adding bounds to definition
        if (region.definition is OfflineGeometryRegionDefinition) {
            val geometry = (region.definition as OfflineGeometryRegionDefinition).geometry
            definition["geometry"] =
                JsonUtils.jsonToMap(geometry!!.toJson(), keyConverter = { k -> k })
        } else {
            definition["bounds"] = listOf(
                region.definition.bounds?.southWest?.longitude,
                region.definition.bounds?.southWest?.latitude,
                region.definition.bounds?.northWest?.longitude,
                region.definition.bounds?.northWest?.latitude
            )
        }


        // Creating final response
        val response = mapOf<Any?, Any?>(
            "id" to region.id,
            "definition" to definition,
            "metadata" to metadataMap,
        )

        // Returning response
        return response
    }

    private class DownloadProgressEventListener : StreamEventsStreamHandler() {
        private var eventSink: PigeonEventSink<NaxaLibreEvent>? = null

        override fun onListen(p0: Any?, sink: PigeonEventSink<NaxaLibreEvent>) {
            eventSink = sink
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }

        fun onDownloadStarted(id: Long) {
            eventSink?.success(IntEvent(id))
        }

        fun onDownloading(progress: Double) {
            eventSink?.success(DoubleEvent(data = progress))
        }

        fun onError(error: String) {
            eventSink?.error("DOWNLOAD_ERROR", error, null)
        }

        fun onDownloaded() {
            eventSink?.endOfStream()
            eventSink = null
        }
    }
}