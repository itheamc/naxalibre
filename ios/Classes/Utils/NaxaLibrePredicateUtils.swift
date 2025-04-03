//
//  NaxaLibrePredicateUtils.swift
//  naxalibre
//
//  Created by Amit on 03/04/2025.
//

import Foundation
import MapLibre


/// Utility struct for handling NSPredicate
struct NaxaLibrePredicateUtils {
    
    /// Converts a given value into an `NSPredicate`.
    ///
    /// - Parameters:
    ///   - value: The value to be converted into an expression. Can be a string, number, or other valid type.
    /// - Returns: An `NSPredicate` representing the given value.
    static func predicateFromValue(_ value: Any?) -> NSPredicate? {
        // Attempt to parse the value as a JSON-based MapLibre predicate
        if let predicate = parsePredicate(value) {
            return predicate
        }
        
        return nil
    }
    
    /// Parses a JSON-based NSPredicate from a string.
    ///
    /// - Parameter value: The value to be parsed, expected to be a string in JSON format enclosed in brackets (`[...]`).
    /// - Returns: An `NSPredicate` if parsing succeeds, otherwise `nil`.
    private static func parsePredicate(_ value: Any?) -> NSPredicate? {
        // Ensure the value is a string formatted as a JSON array (e.g., "[...]", as required by predicate)
        if let stringValue = value as? String, stringValue.hasPrefix("["), stringValue.hasSuffix("]") {
            do {
                // Convert the string to UTF-8 encoded data
                let data = stringValue.data(using: .utf8)!
                // Deserialize JSON into an object
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                // Convert JSON object into an NSPredicate
                return NSPredicate(mglJSONObject: json)
            } catch {
                return nil
            }
        }
        return nil
    }
    
}
