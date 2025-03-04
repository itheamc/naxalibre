package com.itheamc.naxalibre.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.core.graphics.drawable.toBitmapOrNull
import java.io.ByteArrayOutputStream

/**
 * `ImageUtils` is a utility object that provides methods for common image manipulation tasks,
 * such as converting between byte arrays, Drawables, and Bitmaps.
 */
object ImageUtils {

    /**
     * Method to Convert byte array to Drawable
     */
    fun byteArrayToDrawable(context: Context, byteArray: ByteArray): Drawable? {
        return try {
            val bitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
            bitmap?.let { BitmapDrawable(context.resources, it) }
        } catch (e: Exception) {
            null
        }
    }

    /**
     * Method to Convert byte array to Bitmap
     */
    fun byteArrayToBitmap(byteArray: ByteArray): Bitmap? {
        return try {
            BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
        } catch (e: Exception) {
            null
        }
    }

    /**
     * Method to Convert Drawable to byte array
     */
    fun drawableToByteArray(drawable: Drawable): ByteArray? {
        return try {
            val bitmap = drawable.toBitmapOrNull()
            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                stream.toByteArray()
            } else {
                null
            }
        } catch (e: Exception) {
            null
        }
    }

    /**
     * Method to Convert Bitmap to byte array
     */
    fun bitmapToByteArray(bitmap: Bitmap): ByteArray? {
        return try {
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        } catch (e: Exception) {
            null
        }
    }
}