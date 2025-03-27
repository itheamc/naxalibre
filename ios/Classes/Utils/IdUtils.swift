//
//  IdUtils.swift
//  naxalibre
//
//  Created by Amit on 27/03/2025.
//

import Foundation


/// Utility struct for generating random numbers of different digit lengths.
struct IdUtils {
    
    /// Generates a random 4-digit number between 1000 and 9999.
    /// - Returns: A randomly generated 4-digit integer.
    static func rand4() -> Int64 {
        return Int64.random(in: 1000...9999)
    }
    
    /// Generates a random 5-digit number between 10000 and 99999.
    /// - Returns: A randomly generated 5-digit integer.
    static func rand5() -> Int64 {
        return Int64.random(in: 10000...99999)
    }
    
    /// Generates a random 6-digit number between 100000 and 999999.
    /// - Returns: A randomly generated 6-digit integer.
    static func rand6() -> Int64 {
        return Int64.random(in: 100000...999999)
    }
    
    /// Generates a random 7-digit number between 1000000 and 9999999.
    /// - Returns: A randomly generated 7-digit integer.
    static func rand7() -> Int64 {
        return Int64.random(in: 1000000...9999999)
    }
    
    /// Generates a random 8-digit number between 10000000 and 99999999.
    /// - Returns: A randomly generated 8-digit integer.
    static func rand8() -> Int64 {
        return Int64.random(in: 10000000...99999999)
    }
}
