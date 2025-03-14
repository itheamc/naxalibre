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
     * Converts a JSON string to a Map with generic key type.
     *
     * This function parses a JSON string and transforms it into a Map where keys are of type K
     * and values can be of any type, including null. It utilizes the JSONObject class from the
     * org.json library for JSON parsing and then delegates to the [jsonObjectToMap] function to handle the
     * conversion of the JSONObject to a Map.
     *
     * @param jsonString The JSON string to be converted.
     * @param keyConverter A function to convert String keys to the desired key type K.
     * @return A Map representing the data in the JSON string with keys of type K.
     * @throws org.json.JSONException If the JSON string is not a valid JSON format.
     * @throws IllegalArgumentException if the input jsonString is empty or null.
     *
     * Example:
     * ```kotlin
     * val jsonString = """{"name": "John", "age": 30, "city": null}"""
     * val map = jsonToMap(jsonString) { it } // Using String keys
     * println(map) // Output: {name=John, age=30, city=null}
     *
     * // Or with enum keys
     * enum class UserField { NAME, AGE, CITY }
     * val enumMap = jsonToMap<UserField>(jsonString) { UserField.valueOf(it.uppercase()) }
     * ```
     */
    fun <K> jsonToMap(jsonString: String, keyConverter: (String) -> K): Map<K, Any?> {
        val jsonObject = JSONObject(jsonString)
        return jsonObjectToMap(jsonObject, keyConverter)
    }

    /**
     * Converts a JSONObject to a Map with generic key type K.
     *
     * This function recursively processes a JSONObject and transforms it into a Kotlin Map.
     * It handles nested JSONObjects and JSONArrays by converting them into nested Maps and Lists respectively.
     *
     * @param jsonObject The JSONObject to be converted.
     * @param keyConverter A function to convert String keys to the desired key type K.
     * @return A Map<K, Any?> representation of the input JSONObject.
     */
    private fun <K> jsonObjectToMap(
        jsonObject: JSONObject,
        keyConverter: (String) -> K
    ): Map<K, Any?> {
        val map = mutableMapOf<K, Any?>()
        jsonObject.keys().forEach { keyString ->
            val key = keyConverter(keyString)
            val value = jsonObject[keyString]
            map[key] = when (value) {
                is JSONObject -> jsonObjectToMap(value, keyConverter)
                is JSONArray -> jsonArrayToList(value, keyConverter)
                else -> value
            }
        }
        return map
    }

    /**
     * Converts a JSONArray to a List of Any?.
     *
     * This function recursively traverses the JSONArray, converting each element to the
     * appropriate type. JSONObject elements are converted to Maps, and nested
     * JSONArrays are converted to Lists via a recursive call. Other values are
     * kept as is.
     *
     * @param jsonArray The JSONArray to convert.
     * @param keyConverter A function to convert String keys to the desired key type K.
     * @return A List containing the converted elements from the JSONArray.
     *
     * @see jsonObjectToMap
     */
    private fun <K> jsonArrayToList(jsonArray: JSONArray, keyConverter: (String) -> K): List<Any?> {
        val list = mutableListOf<Any?>()
        for (i in 0 until jsonArray.length()) {
            val value = jsonArray[i]
            list.add(
                when (value) {
                    is JSONObject -> jsonObjectToMap(value, keyConverter)
                    is JSONArray -> jsonArrayToList(value, keyConverter)
                    else -> value
                }
            )
        }
        return list
    }

    /**
     * Converts a Map to a JSON string representation.
     *
     * This function takes a Map with any type of keys and values and transforms it into a JSON string.
     * It internally uses a [JSONObject] to represent the map and then returns the string representation of that object.
     *
     * **Note:** This function handles null values in the map by including them as "null" in the JSON output.
     * If the map contains complex objects as values, they must be convertible to JSON representations by the underlying JSONObject.
     *
     * @param map The Map to be converted to a JSON string.
     * @return A JSON string representing the input Map.
     * @throws org.json.JSONException If there is an error during the JSON object creation. This might occur if the map contains values that cannot be represented in JSON.
     */
    fun mapToJson(map: Map<*, *>): String {
        return mapToJsonObject(map).toString()
    }

    /**
     * Converts a Map object to a JSONObject.
     *
     * This function recursively traverses the input Map and converts it into a
     * corresponding JSONObject. It handles nested Maps and Lists by recursively
     * calling itself or `listToJsonArray`, respectively.  All other values are
     * directly added to the JSONObject. Keys are converted to strings.
     *
     * @param map The Map to convert. It can contain nested Maps and Lists.
     * @return A JSONObject representation of the input Map.
     * @throws org.json.JSONException if any error happens during the JSONObject creation.
     */
    private fun mapToJsonObject(map: Map<*, *>): JSONObject {
        val json = JSONObject()
        for ((key, value) in map) {
            when (value) {
                is Map<*, *> -> json.put(key.toString(), mapToJsonObject(value))
                is List<*> -> json.put(key.toString(), listToJsonArray(value))
                else -> json.put(key.toString(), value)
            }
        }
        return json
    }

    /**
     * Converts a List of mixed data types to a JSONArray.
     *
     * This function recursively traverses a list and converts its elements into a format
     * suitable for a JSONArray. It handles nested Maps and Lists, converting them into
     * JSONObjects and nested JSONArrays respectively. Other data types are added directly.
     *
     * @param list The List to convert. It can contain elements of any type, including Maps and Lists.
     * @return A JSONArray representing the input List.
     *
     * @throws org.json.JSONException if there's any error during the creation of JSONObjects or JSONArrays.
     *
     * @see mapToJsonObject
     */
    private fun listToJsonArray(list: List<*>): JSONArray {
        val jsonArray = JSONArray()
        for (item in list) {
            when (item) {
                is Map<*, *> -> jsonArray.put(mapToJsonObject(item))
                is List<*> -> jsonArray.put(listToJsonArray(item))
                else -> jsonArray.put(item)
            }
        }
        return jsonArray
    }

}