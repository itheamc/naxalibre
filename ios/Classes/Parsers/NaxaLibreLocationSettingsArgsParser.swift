//
//  NaxaLibreLocationSettingsParser.swift
//  naxalibre
//
//  Created by Amit on 28/02/2025.
//

import Foundation
import MapLibre

/// Object responsible for parsing arguments provided to configure a MapLibre map.
///
/// This struct provides a utility function `parseArgs` that takes a dictionary of arguments
/// and constructs a `NaxaLibreLocationSettings` object based on these arguments. It handles parsing various
/// location settings related values, including user location annotation styling.
struct NaxaLibreLocationSettingsArgsParser {
    
    /// Parses a dictionary of arguments to create a `NaxaLibreLocationSettings` object.
    ///
    /// - Parameters:
    ///   - args: An optional dictionary containing key-value pairs representing the map's configuration.
    ///           If nil, default options are created.
    ///           The supported keys and their types are:
    ///
    /// - Returns: A `MapLibreMapOptions` object configured with the provided arguments or default values.
    static func parseArgs(_ args: [String: Any?]?) -> NaxaLibreLocationSettings {
        return NaxaLibreLocationSettings.fromArgs(args ?? [:])
    }
}


extension MLNUserLocationAnnotationViewStyle {
    func applyStyle(_ options: NaxaLibreLocationSettings) {
        
        let locationStyle = options.locationComponentOptions
    }
}
