package com.itheamc.naxalibre.utils

/**
 * Utility object for generating random numbers of different digit lengths.
 */
object IdUtils {

    /**
     * Generates a random 4-digit number between 1000 and 9999.
     * @return A randomly generated 4-digit integer.
     */
    fun rand4(): Long = (1000L..9999L).random()

    /**
     * Generates a random 5-digit number between 10000 and 99999.
     * @return A randomly generated 5-digit integer.
     */
    fun rand5(): Long = (10000L..99999L).random()

    /**
     * Generates a random 6-digit number between 100000 and 999999.
     * @return A randomly generated 6-digit integer.
     */
    fun rand6(): Long {
        return (100000L..999999L).random()
    }

    /**
     * Generates a random 7-digit number between 1000000 and 9999999.
     * @return A randomly generated 7-digit integer.
     */
    fun rand7(): Long {
        return (1000000L..9999999L).random()
    }

    /**
     * Generates a random 8-digit number between 10000000 and 99999999.
     * @return A randomly generated 8-digit integer.
     */
    fun rand8(): Long {
        return (10000000L..99999999L).random()
    }
}
