package np.com.naxa.naxalibre

import android.app.Activity
import android.app.AlertDialog
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.net.Uri
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Toast
import org.maplibre.android.MapStrictMode
import org.maplibre.android.R.layout
import org.maplibre.android.R.string
import org.maplibre.android.maps.AttributionDialogManager
import org.maplibre.android.maps.MapLibreMap

/**
 * `NaxaLibreAttributionDialogManager` is a custom implementation of
 * `AttributionDialogManager` specifically designed to handle attribution
 * display for the NaxaLibre project. It shows a dialog listing attribution
 * sources and provides links to their respective websites when clicked.
 *
 * This class extends `AttributionDialogManager` and implements
 * `View.OnClickListener` and `DialogInterface.OnClickListener` to handle
 * user interactions with the attribution button and the dialog itself.
 */
class NaxaLibreAttributionDialogManager(
    private val context: Context,
    maplibreMap: MapLibreMap,
    private val attributions: Map<String, String>,
) : AttributionDialogManager(context, maplibreMap),
    View.OnClickListener, DialogInterface.OnClickListener {
    private var dialog: AlertDialog? = null

    /**
     * Handles the click event for the view.
     *
     * This function is called when the view is clicked. It checks if the associated
     * context is an Activity and whether that Activity is finishing. If the Activity
     * is not finishing, it proceeds to display the attribution dialog.
     *
     * @param view The view that was clicked.
     */
    override fun onClick(view: View) {
        var isActivityFinishing = false
        if (context is Activity) {
            isActivityFinishing = context.isFinishing
        }

        if (!isActivityFinishing) {
            this.showAttributionDialog(this.attributionTitles)
        }
    }

    /**
     * Displays an attribution dialog listing the provided attribution titles.
     *
     * This function creates and shows an AlertDialog that presents a list of attributions.
     * Each attribution title in the input array will be displayed as a separate item in the list.
     * The dialog uses a simple list layout and is dismissed when the user clicks on any item.
     *
     * @param attributionTitles An array of strings representing the titles of the attributions to display.
     *                          Each string in this array will be shown as a separate item in the attribution list.
     *                          May contain null values, which will be displayed as empty items in the list.
     *
     * @throws IllegalStateException If the context used to build the dialog is not valid.
     * @throws RuntimeException If an error occurs while creating or showing the dialog.
     *
     * @see AlertDialog
     * @see ArrayAdapter
     */
    override fun showAttributionDialog(attributionTitles: Array<String?>) {
        val builder = AlertDialog.Builder(this.context)
        builder.setTitle("NaxaLibre")
        builder.setAdapter(
            ArrayAdapter<Any?>(
                this.context,
                layout.maplibre_attribution_list_item,
                attributionTitles
            ),
            this
        )
        this.dialog = builder.show()
    }

    private val attributionTitles: Array<String?> = attributions.map { it.key }.toTypedArray()

    /**
     * Handles the click event on an item in a dialog.
     *
     * This method is called when an item in a dialog is clicked. It delegates the
     * action to the `showMapAttributionWebPage` method, passing the index of the
     * clicked item as an argument.
     *
     * @param dialog The dialog that was clicked.
     * @param which The index of the item that was clicked within the dialog's list of items.
     *              This value corresponds to the position of the item in the array
     *              or list used to populate the dialog's items.
     *              This index will be used to determine which attribution link should be displayed
     *              in the web page.
     */
    override fun onClick(dialog: DialogInterface, which: Int) {
        this.showMapAttributionWebPage(which)
    }

    /**
     * Called when the Fragment is no longer started.  This is generally
     * tied to {@link Activity#onStop() Activity.onStop} of the containing
     * Activity's lifecycle.  If this fragment's dialog is currently showing,
     * it will be dismissed.
     *
     * This ensures that any dialogs created by this fragment are properly
     * dismissed and their resources released when the fragment is stopped,
     * preventing potential memory leaks or unexpected behavior.
     */
    override fun onStop() {
        if (this.dialog != null && dialog!!.isShowing) {
            dialog!!.dismiss()
        }
    }

    /**
     * Displays the web page associated with a specific map attribution.
     *
     * This function takes an index representing a specific map attribution from the
     * `attributions` map and displays the corresponding web page in a web view.
     *
     * @param which The index of the desired attribution in the `attributions` map's key set.
     *              This index should be a valid index within the range of the `attributions`
     *              keys.
     * @throws IndexOutOfBoundsException if `which` is out of the valid index range of the `attributions` keys.
     * @throws IllegalStateException If the `attributions` map is empty.
     *
     * @see showWebPage
     */
    private fun showMapAttributionWebPage(which: Int) {
        val url = attributions[attributions.keys.toTypedArray()[which]]
        url?.let { this.showWebPage(it) }
    }

    /**
     * Opens a web page in the user's default web browser.
     *
     * @param url The URL of the web page to open.
     *
     * @throws ActivityNotFoundException if no activity is found to handle the intent (e.g., no web browser is installed).
     *
     */
    private fun showWebPage(url: String) {
        try {
            val intent = Intent("android.intent.action.VIEW")
            intent.setData(Uri.parse(url))
            intent.setFlags(FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        } catch (var3: ActivityNotFoundException) {
            Toast.makeText(context, string.maplibre_attributionErrorNoBrowser, Toast.LENGTH_LONG)
                .show()
            MapStrictMode.strictModeViolation(var3)
        }
    }

}