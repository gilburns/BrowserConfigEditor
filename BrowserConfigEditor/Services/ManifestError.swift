//
//  ManifestError.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Foundation

enum ManifestError: Error, LocalizedError {
    case invalidBrowserPath
    case manifestNotFound
    case invalidManifestFormat
    case parsingFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidBrowserPath:
            return "The selected path is not a valid browser application"
        case .manifestNotFound:
            return "No manifest file found in the browser bundle"
        case .invalidManifestFormat:
            return "The manifest file format is invalid"
        case .parsingFailed(let message):
            return "Failed to parse manifest: \(message)"
        }
    }
}
