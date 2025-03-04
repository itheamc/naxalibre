package com.itheamc.naxalibre.utils

import org.json.JSONArray
import org.json.JSONObject

/**
 * Utility object for converting JSON strings, JSONObjects, and JSONArrays to Kotlin data structures.
 *
 * This object provides methods to easily convert between JSON representations and Kotlin's Map and List
 * types. It handles nested structures recursively and provides error handling for invalid JSON inputs.
 */
object JsonUtils {

    /**
     * Converts a JSON string to a Map.
     *
     * This function parses a JSON string and transforms it into a Map where keys are strings
     * and values can be of any type, including null. It utilizes the JSONObject class from the
     * org.json library for JSON parsing and then delegates to the [jsonObjectToMap] function to handle the
     * conversion of the JSONObject to a Map.
     *
     * @param jsonString The JSON string to be converted.
     * @return A Map representing the data in the JSON string.
     * @throws org.json.JSONException If the JSON string is not a valid JSON format.
     * @throws IllegalArgumentException if the input jsonString is empty or null.
     *
     * Example:
     * ```kotlin
     * val jsonString = """{"name": "John", "age": 30, "city": null}"""
     * val map = jsonToMap(jsonString)
     * println(map) // Output: {name=John, age=30, city=null}
     * ```
     */
    fun jsonToMap(jsonString: String): Map<Any?, Any?> {
        val jsonObject = JSONObject(jsonString)
        return jsonObjectToMap(jsonObject)
    }

    /**
     * Converts a JSONObject to a Map<String, Any?>.
     *
     * This function recursively processes a JSONObject and transforms it into a Kotlin Map.
     * It handles nested JSONObjects and JSONArrays by converting them into nested Maps and Lists respectively.
     *
     * @param jsonObject The JSONObject to be converted.
     * @return A Map<String, Any?> representation of the input JSONObject.
     *
     */
    private fun jsonObjectToMap(jsonObject: JSONObject): Map<Any?, Any?> {
        val map = mutableMapOf<Any?, Any?>()
        jsonObject.keys().forEach { key ->
            val value = jsonObject[key]
            map[key] = when (value) {
                is JSONObject -> jsonObjectToMap(value)
                is JSONArray -> jsonArrayToList(value)
                else -> value
            }
        }
        return map
    }

    /**
     * Converts a JSONArray to a List of Any?.
     *
     * This function recursively traverses the JSONArray, converting each element to the
     * appropriate type.  JSONObject elements are converted to Maps, and nested
     * JSONArrays are converted to Lists via a recursive call. Other values are
     * kept as is.
     *
     * @param jsonArray The JSONArray to convert.
     * @return A List containing the converted elements from the JSONArray.
     *
     * @see jsonObjectToMap
     */
    private fun jsonArrayToList(jsonArray: JSONArray): List<Any?> {
        val list = mutableListOf<Any?>()
        for (i in 0 until jsonArray.length()) {
            val value = jsonArray[i]
            list.add(
                when (value) {
                    is JSONObject -> jsonObjectToMap(value)
                    is JSONArray -> jsonArrayToList(value)
                    else -> value
                }
            )
        }
        return list
    }
}