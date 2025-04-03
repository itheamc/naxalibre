//
//  NaxaLibreExpressionsUtils.swift
//  naxalibre
//
//  Created by Amit on 24/02/2025.
//

import Foundation
import MapLibre


/// Utility struct for handling expressions in a Maplibre GL context.
struct NaxaLibreExpressionsUtils {
    
    /// Converts a given value into an `NSExpression`. If the value represents a color, it attempts to parse it as a `UIColor`.
    ///
    /// - Parameters:
    ///   - value: The value to be converted into an expression. Can be a string, number, or other valid type.
    ///   - isColor: A boolean flag indicating whether the value should be treated as a color. Defaults to `false`.
    /// - Returns: An `NSExpression` representing the given value, or a default color expression if `isColor` is `true`.
    static func expressionFromValue(_ value: Any?, isColor: Bool = false) -> NSExpression? {
        // Attempt to parse the value as a JSON-based MapLibre expression
        if let expression = parseExpression(value) {
            return expression
        } else {
            // If parsing fails and value is not nil, return an appropriate constant expression
            if value != nil {
                if !isColor {
                    return NSExpression(forConstantValue: value)
                } else {
                    return NSExpression(
                        forConstantValue: UIColor(
                            colorNameOrHex: value is String ? value as! String : String(describing: value),
                            defaultColor: .black
                        )
                    )
                }
            }
        }
        return nil
    }
    
    /// Parses a JSON-based Maplibre expression from a string.
    ///
    /// - Parameter value: The value to be parsed, expected to be a string in JSON format enclosed in brackets (`[...]`).
    /// - Returns: An `NSExpression` if parsing succeeds, otherwise `nil`.
    static func parseExpression(_ value: Any?) -> NSExpression? {
        // Ensure the value is a string formatted as a JSON array (e.g., "[...]", as required by MapLibre expressions)
        if let stringValue = value as? String, stringValue.hasPrefix("["), stringValue.hasSuffix("]") {
            do {
                // Convert the string to UTF-8 encoded data
                let data = stringValue.data(using: .utf8)!
                // Deserialize JSON into an object
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                // Convert JSON object into an NSExpression compatible with Maplibre GL
                return NSExpression(mglJSONObject: json)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    /// Recursively replaces color names or hex strings in a raw MapLibre expression with their corresponding `UIColor` values.
    ///
    /// - Parameter expression: A raw MapLibre expression represented as a nested `[Any]` array.
    /// - Returns: A new expression array where color strings are replaced with `UIColor` objects.
    static func replaceColorsInRawExpression(_ expression: [Any]) -> [Any] {
        return expression.map { item in
            if let subArray = item as? [Any] {
                // Recursively process nested arrays to replace colors at all levels.
                return replaceColorsInRawExpression(subArray)
            } else if let colorString = item as? String {
                // Attempt to convert the string into a UIColor.
                // If conversion fails, return the original string.
                return UIColor(colorNameOrHex: colorString) ?? item
            } else {
                // Return the item unchanged (e.g., numbers, booleans, other non-string values).
                return item
            }
        }
    }

}
