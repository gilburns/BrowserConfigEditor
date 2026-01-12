//
//  LocalizationLoader.swift
//  BrowserConfigEditor
//
//  Service for loading localized strings from manifest bundles
//

import Foundation

class LocalizationLoader {

    // Load localizable strings from manifest bundle
    static func loadLocalizations(for manifestURL: URL, locale: String = "en") throws -> [String: (title: String, description: String)] {
        // Navigate to the localization file
        // Pattern: <manifest-bundle>/Contents/Resources/<locale>.lproj/Localizable.strings
        let manifestBundle = manifestURL.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let localizationPath = manifestBundle
            .appendingPathComponent("Contents/Resources")
            .appendingPathComponent("\(locale).lproj")
            .appendingPathComponent("Localizable.strings")

        guard FileManager.default.fileExists(atPath: localizationPath.path) else {
            throw ManifestError.parsingFailed("Localization file not found at: \(localizationPath.path)")
        }

        return try parseStringsFile(at: localizationPath)
    }

    // Parse .strings file format (plist)
    private static func parseStringsFile(at url: URL) throws -> [String: (title: String, description: String)] {
        guard let data = try? Data(contentsOf: url) else {
            throw ManifestError.parsingFailed("Could not read strings file at \(url.path)")
        }

        // Parse as plist (handles both binary and text formats)
        guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] else {
            throw ManifestError.parsingFailed("Could not parse strings file as plist at \(url.path)")
        }

        var localizations: [String: (title: String, description: String)] = [:]

        // Parse plist dictionary
        // Format: "KeyName.pfm_title" = "Title text"
        //         "KeyName.pfm_description" = "Description text"
        for (key, value) in plist {
            // Split key into policy name and property
            let components = key.components(separatedBy: ".pfm_")
            if components.count == 2 {
                let policyName = components[0]
                let property = components[1]

                // Initialize entry if needed
                if localizations[policyName] == nil {
                    localizations[policyName] = (title: "", description: "")
                }

                // Set appropriate property
                if property == "title" {
                    localizations[policyName] = (title: value, description: localizations[policyName]?.description ?? "")
                } else if property == "description" {
                    localizations[policyName] = (title: localizations[policyName]?.title ?? "", description: value)
                }
            }
        }

        return localizations
    }

    // Apply localizations to policies (only override if localized value is non-empty)
    static func applyLocalizations(_ localizations: [String: (title: String, description: String)], to policies: inout [PolicyModel]) {
        for i in 0..<policies.count {
            if let localization = localizations[policies[i].name] {
                // Only override title if localized value exists
                if !localization.title.isEmpty {
                    policies[i].title = localization.title
                }
                // Only override description if localized value exists
                if !localization.description.isEmpty {
                    policies[i].description = localization.description
                }
            }
        }
    }

    // Convenience method: load and apply localizations
    static func loadAndApply(for manifestURL: URL, to policies: inout [PolicyModel], locale: String = "en") {
        do {
            let localizations = try loadLocalizations(for: manifestURL, locale: locale)
            applyLocalizations(localizations, to: &policies)
        } catch {
            print("Warning: Could not load localizations: \(error.localizedDescription)")
        }
    }
}
