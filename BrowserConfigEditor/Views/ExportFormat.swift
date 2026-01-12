//
//  ExportFormat.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa
import UniformTypeIdentifiers

enum ExportFormat: String {
    case plist = "plist"
    case json = "json"
    case intune = "xml"
    case shellScript = "sh"

    var fileExtension: String {
        return rawValue
    }

    var utType: UTType? {
        switch self {
        case .plist:
            return UTType(filenameExtension: "plist")
        case .json:
            return .json
        case .intune:
            return .xml
        case .shellScript:
            return UTType(filenameExtension: "sh")
        }
    }

    var displayName: String {
        switch self {
        case .plist:
            return "Property List"
        case .json:
            return "JSON"
        case .intune:
            return "Intune XML"
        case .shellScript:
            return "Shell Script"
        }
    }

    var displayDescription: String {
        switch self {
        case .plist:
            return "File format used with Apple operating systems for storing configuration data and application settings in a structured, hierarchical format"
        case .json:
            return "Simple format used to store and transport data. It is a plain-text format, which allows for easy data interchange between different programming languages"
        case .intune:
            return "Intune XML files are special XML files used to configure Microsoft Intune Preference Templates for managing mobile devices. They are essentially a plist file that has the header and footer removed. These files should only have key value pairs only."
        case .shellScript:
            return "Shell script that writes the plist file to /Library/Preferences/. Requires root permissions to execute (run with sudo)."
        }
    }

}
