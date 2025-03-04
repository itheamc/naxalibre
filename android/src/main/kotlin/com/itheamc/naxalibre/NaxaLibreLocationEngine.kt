package com.itheamc.naxalibre

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Context
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Looper
import org.maplibre.android.location.engine.LocationEngineCallback
import org.maplibre.android.location.engine.LocationEngineImpl
import org.maplibre.android.location.engine.LocationEngineProxy
import org.maplibre.android.location.engine.LocationEngineRequest
import org.maplibre.android.location.engine.LocationEngineResult


/**
 * A custom location engine implementation that utilizes the Android system's LocationManager.
 *
 * This class provides a way to receive location updates from the system and interact with
 * the underlying LocationManager. It prioritizes different location providers based on their
 * availability and the Android version. It also provides methods for obtaining the last
 * known location and requesting/removing location updates.
 *
 * This class implements the {@link LocationEngineImpl} interface, making it compatible
 * with MapLibre's location services framework.
 */
class NaxaLibreLocationEngine(
    private val context: Context,
    locationProvider: String? = null
) : LocationEngineImpl<LocationListener> {

    /**
     * Provides access to the system location services.
     *
     * This property is initialized with the LocationManager obtained from the system
     * service. It allows interacting with location-related features such as retrieving
     * the last known location, requesting location updates, and checking for enabled
     * location providers.
     *
     * @see Context.getSystemService
     * @see LocationManager
     */
    private val locationManager by lazy { context.getSystemService(Context.LOCATION_SERVICE) as LocationManager }


    /**
     * The location provider to be used for location updates.
     *
     * This property determines the most suitable location provider based on the device's capabilities and
     * available providers. It prioritizes the following providers in order:
     *
     * 1. **Fused Location Provider (API 31+):** If the device is running Android 12 (API 31) or higher and
     *    the Fused Location Provider is available, it is used. This provider is recommended for its
     *    accuracy and efficiency.
     *
     * 2. **GPS Provider:** If the Fused Location Provider is not available, or if the device is running
     *    an older Android version, and the GPS provider is available, it is used. This provider uses
     *    satellite-based positioning and is generally very accurate outdoors.
     *
     * 3. **Network Provider:** If neither the Fused Location Provider nor the GPS provider is available,
     *    and the Network provider is available, it is used. This provider uses Wi-Fi and cellular
     *    networks for location, which can be less accurate but works indoors.
     *
     * 4. **Passive Provider:** If none of the above providers are available, the Passive provider is used
     *    as a fallback. This provider does not actively request location updates but passively receives
     *    location updates from other applications.
     *
     * The choice of provider is determined once during initialization and remains constant throughout
     * the lifecycle of the instance.
     */
    private val provider by lazy {
        locationProvider?.let {
            if (locationManager.allProviders.contains(it) && locationManager.isProviderEnabled(it)) it else null
        } ?: run {
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                        locationManager.hasProvider(LocationManager.FUSED_PROVIDER) -> LocationManager.FUSED_PROVIDER

                locationManager.allProviders.contains(LocationManager.GPS_PROVIDER) &&
                        locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) -> LocationManager.GPS_PROVIDER

                locationManager.allProviders.contains(LocationManager.NETWORK_PROVIDER) &&
                        locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER) -> LocationManager.NETWORK_PROVIDER

                else -> LocationManager.PASSIVE_PROVIDER
            }
        }
    }

    /**
     * Creates a LocationListener that wraps a LocationEngineCallback.
     *
     * This function is responsible for bridging the gap between the standard Android
     * LocationListener and the Mapbox LocationEngineCallback. It receives a
     * LocationEngineCallback and returns a LocationListener. When a new location is
     * received by the LocationListener, it is wrapped in a LocationEngineResult and
     * passed to the onSuccess method of the provided LocationEngineCallback.
     *
     * @param callback The LocationEngineCallback to be notified of new locations.
     *                 Can be null if no callback is needed.
     * @return A LocationListener that forwards location updates to the provided
     *         LocationEngineCallback.
     */
    override fun createListener(callback: LocationEngineCallback<LocationEngineResult>?): LocationListener {
        return LocationListener {
            callback?.onSuccess(LocationEngineResult.create(it))
        }
    }


    /**
     * Retrieves the last known location from available location providers.
     *
     * This function attempts to get the last known location from the following providers, in order of preference:
     * 1. GPS_PROVIDER
     * 2. NETWORK_PROVIDER
     * 3. FUSED_PROVIDER (if available on the device, Android S and above)
     *
     * It iterates through the providers and returns the first non-null last known location.
     * If no location is found from any provider, it invokes the `onFailure` callback.
     *
     * @param callback The callback to be invoked with the result.
     *                 - `onSuccess` will be called with a `LocationEngineResult` containing the last known location if one is found.
     *                 - `onFailure` will be called with an `Exception` if no location is available.
     *
     * @throws SecurityException if the app lacks the necessary location permissions (ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION).
     *
     * @SuppressLint("MissingPermission") is used because we are assuming the calling code will check the permissions,
     * otherwise, a SecurityException is expected to be thrown by the locationManager.
     */
    @SuppressLint("MissingPermission")
    override fun getLastLocation(callback: LocationEngineCallback<LocationEngineResult>) {
        try {
            locationManager.getLastKnownLocation(provider)?.let {
                callback.onSuccess(LocationEngineResult.create(it))
            } ?: callback.onFailure(Exception("No location available"))
        } catch (e: Exception) {
            callback.onFailure(Exception(e.message))
        }
    }

    /**
     * Requests location updates from the GPS provider.
     *
     * This function registers a request for location updates with the system's
     * LocationManager using the GPS provider. The updates will be delivered to the
     * provided PendingIntent.
     *
     * **Note:** This function requires the appropriate location permissions
     * (e.g., ACCESS_FINE_LOCATION) to be granted by the user. Calling this
     * function without the required permissions will result in a runtime
     * exception. The @SuppressLint("MissingPermission") annotation is used to
     * suppress the lint warning about missing permissions. It's crucial that the
     * caller ensures the permissions are granted before calling this method.
     *
     * @param request A [LocationEngineRequest] object specifying the desired
     *                update parameters such as the interval.
     * @param intent A [PendingIntent] to be invoked when a new location
     *               update is available. This PendingIntent will receive a
     *               location as an extra.
     *
     * @throws SecurityException if the caller does not have the appropriate
     *                           location permissions.
     */
    @SuppressLint("MissingPermission")
    override fun requestLocationUpdates(request: LocationEngineRequest, intent: PendingIntent) {
        locationManager.requestLocationUpdates(
            provider,
            request.interval,
            request.displacement,
            intent
        )
    }

    /**
     * Requests location updates from the GPS provider.
     *
     * This function registers a listener to receive periodic location updates based on the provided
     * [LocationEngineRequest]. The updates are provided via the specified [LocationListener] callback.
     *
     * Note: This function requires the ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION permission.
     *       It's crucial to handle these permissions appropriately in your application before calling this function.
     *
     * @param request The [LocationEngineRequest] defining the parameters for location updates, such as
     *                the desired update interval.
     * @param listener The [LocationListener] to receive location updates.
     * @param looper The [Looper] on which to dispatch the location updates. If null, the main Looper will be used.
     *
     * @throws SecurityException if the required location permissions are not granted.
     *
     * @see LocationManager.requestLocationUpdates
     * @see LocationListener
     * @see LocationEngineRequest
     */
    @SuppressLint("MissingPermission")
    override fun requestLocationUpdates(
        request: LocationEngineRequest,
        listener: LocationListener,
        looper: Looper?
    ) {
        locationManager.requestLocationUpdates(
            provider,
            request.interval,
            request.displacement,
            listener,
            looper
        )
    }

    /**
     * This class (or a class containing this method) likely handles location updates.
     */
    @SuppressLint("MissingPermission")
    override fun removeLocationUpdates(listener: LocationListener?) {
        listener?.let { locationManager.removeUpdates(it) }
    }

    /**
     * Removes location updates for the specified PendingIntent.
     *
     * This function stops receiving location updates that were previously requested
     * using a PendingIntent. It utilizes the LocationManager to remove the updates
     * associated with the given PendingIntent. If the provided PendingIntent is null,
     * this function will have no effect.
     *
     * @param intent The PendingIntent that was used to request location updates.
     *               Pass null if there's no PendingIntent associated with the
     *               location updates to remove.
     * @see LocationManager.removeUpdates
     */
    override fun removeLocationUpdates(intent: PendingIntent?) {
        intent?.let {
            locationManager.removeUpdates(it)
        }
    }

    companion object {
        /**
         * Creates and returns a [LocationEngineProxy] instance wrapping a [NaxaLibreLocationEngine].
         *
         * This function provides a convenient way to obtain a location engine that utilizes the NaxaLibre
         * library for location services. The returned [LocationEngineProxy] provides an abstraction layer
         * over the underlying [NaxaLibreLocationEngine], allowing for easier interaction with location updates.
         *
         * @param context The application context, used by the underlying [NaxaLibreLocationEngine] for
         *                accessing system resources and services.
         * @param locationProvider The provider for the location update. E.g. gps, network, fused etc.
         * @return A [LocationEngineProxy] instance that wraps a [NaxaLibreLocationEngine] initialized with the
         *         provided context.
         */
        fun create(context: Context, locationProvider: String? = null) =
            LocationEngineProxy(NaxaLibreLocationEngine(context, locationProvider))
    }
}