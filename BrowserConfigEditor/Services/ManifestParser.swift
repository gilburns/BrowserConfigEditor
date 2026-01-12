//
//  ManifestParser.swift
//  BrowserConfigEditor
//
//  Service for parsing browser manifest files
//

import Foundation

class ManifestParser {

    // Discover manifest path from browser app bundle
    static func discoverManifest(in browserURL: URL) throws -> URL {
        // Check if it's an app bundle
        guard browserURL.pathExtension == "app" else {
            throw ManifestError.invalidBrowserPath
        }

        let resourcesPath = browserURL.appendingPathComponent("Contents/Resources")
        let fileManager = FileManager.default

        // Look for .manifest folders/bundles
        guard let contents = try? fileManager.contentsOfDirectory(at: resourcesPath, includingPropertiesForKeys: nil) else {
            throw ManifestError.manifestNotFound
        }

        // Find .manifest bundle
        guard let manifestBundle = contents.first(where: { $0.lastPathComponent.hasSuffix(".manifest") }) else {
            throw ManifestError.manifestNotFound
        }

        // The actual plist file is inside the manifest bundle
        // Pattern: Contents/Resources/<bundle-id>.manifest
        let manifestFileName = manifestBundle.lastPathComponent
        let manifestPlistPath = manifestBundle
            .appendingPathComponent("Contents/Resources")
            .appendingPathComponent(manifestFileName)

        guard fileManager.fileExists(atPath: manifestPlistPath.path) else {
            throw ManifestError.manifestNotFound
        }

        return manifestPlistPath
    }

    // Parse manifest from plist file
    static func parseManifest(at url: URL, browserPath: URL) throws -> ManifestModel {
        guard let data = try? Data(contentsOf: url) else {
            throw ManifestError.parsingFailed("Could not read manifest file")
        }

        guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            throw ManifestError.invalidManifestFormat
        }

        // Extract root properties
        guard let name = plist["pfm_name"] as? String else {
            throw ManifestError.invalidManifestFormat
        }

        // pfm_domain may be missing (e.g., Safari) - fallback to browser bundle ID
        let domain: String
        if let manifestDomain = plist["pfm_domain"] as? String {
            domain = manifestDomain
        } else {
            // Extract bundle ID from browser's Info.plist
            let infoPlistURL = browserPath.appendingPathComponent("Contents/Info.plist")
            guard let infoPlistData = try? Data(contentsOf: infoPlistURL),
                  let infoPlist = try? PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any],
                  let bundleID = infoPlist["CFBundleIdentifier"] as? String else {
                throw ManifestError.parsingFailed("Missing pfm_domain and could not read browser bundle ID")
            }
            domain = bundleID
        }

        let description = plist["pfm_description"] as? String ?? ""

        // Parse subkeys (policies)
        guard let subkeysArray = plist["pfm_subkeys"] as? [[String: Any]] else {
            throw ManifestError.parsingFailed("No policies found in manifest")
        }

        var policies = subkeysArray.compactMap { PolicyModel.from(dict: $0) }

        // Load and apply localizations
        LocalizationLoader.loadAndApply(for: url, to: &policies)

        return ManifestModel(
            domain: domain,
            name: name,
            description: description,
            policies: policies,
            browserPath: browserPath,
            manifestPath: url
        )
    }

    // Convenience method: discover and parse in one step
    static func loadManifest(from browserURL: URL) throws -> ManifestModel {
        let manifestURL = try discoverManifest(in: browserURL)
        return try parseManifest(at: manifestURL, browserPath: browserURL)
    }
}
