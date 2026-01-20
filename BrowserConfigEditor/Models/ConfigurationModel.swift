//
//  ConfigurationModel.swift
//  BrowserConfigEditor
//
//  Model representing a user's MDM configuration
//

import Foundation
import Combine

struct ConfiguredPolicy {
    let policy: PolicyModel
    var value: Any

    init(policy: PolicyModel, value: Any) {
        self.policy = policy
        self.value = value
    }
}

// MARK: - Configuration Model
class ConfigurationModel: ObservableObject {
    @Published var manifest: ManifestModel?
    @Published var configuredPolicies: [String: ConfiguredPolicy] = [:]

    var domain: String? {
        return manifest?.domain
    }

    // Add or update a policy configuration
    func setPolicy(name: String, value: Any) {
        guard let manifest = manifest,
              let policy = manifest.policy(named: name) else {
            return
        }

        configuredPolicies[name] = ConfiguredPolicy(policy: policy, value: value)
    }

    // Remove a policy configuration
    func removePolicy(name: String) {
        configuredPolicies.removeValue(forKey: name)
    }

    // Check if a policy is configured
    func isConfigured(name: String) -> Bool {
        return configuredPolicies[name] != nil
    }

    // Get configured value for a policy
    func value(for name: String) -> Any? {
        return configuredPolicies[name]?.value
    }

    // MARK: - Export functions
    // Generate plist dictionary for export
    func generatePlistDictionary() -> [String: Any] {
        var result: [String: Any] = [:]

        for (name, configuredPolicy) in configuredPolicies {
            result[name] = configuredPolicy.value
        }

        return result
    }

    // Export to plist file
    func exportToPlist(url: URL) throws {
        let plistDict = generatePlistDictionary()

        let plistData = try PropertyListSerialization.data(
            fromPropertyList: plistDict,
            format: .xml,
            options: 0
        )

        try plistData.write(to: url)
    }

    // Export to JSON file
    func exportToJSON(url: URL) throws {
        let plistDict = generatePlistDictionary()

        let jsonData = try JSONSerialization.data(
            withJSONObject: plistDict,
            options: [.prettyPrinted, .sortedKeys]
        )

        try jsonData.write(to: url)
    }

    // Export to Intune-ready XML (plist without headers/wrapper)
    func exportToIntune(url: URL) throws {
        let plistDict = generatePlistDictionary()

        // Generate full plist XML
        let plistData = try PropertyListSerialization.data(
            fromPropertyList: plistDict,
            format: .xml,
            options: 0
        )

        // Convert to string
        guard var plistString = String(data: plistData, encoding: .utf8) else {
            throw NSError(domain: "ConfigurationModel", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to convert plist to string"])
        }

        // Remove XML header, DOCTYPE, and plist wrapper
        // Remove: <?xml version="1.0" encoding="UTF-8"?>
        if let xmlHeaderRange = plistString.range(of: #"<\?xml[^>]*\?>\n?"#, options: .regularExpression) {
            plistString.removeSubrange(xmlHeaderRange)
        }

        // Remove: <!DOCTYPE plist...>
        if let doctypeRange = plistString.range(of: #"<!DOCTYPE[^>]*>\n?"#, options: .regularExpression) {
            plistString.removeSubrange(doctypeRange)
        }

        // Remove: <plist version="1.0">
        if let plistOpenRange = plistString.range(of: #"<plist[^>]*>\n?"#, options: .regularExpression) {
            plistString.removeSubrange(plistOpenRange)
        }

        // Remove: </plist>
        if let plistCloseRange = plistString.range(of: #"</plist>\n?"#, options: .regularExpression) {
            plistString.removeSubrange(plistCloseRange)
        }

        // Extract just the dict contents (remove outer <dict> and </dict>)
        // Find the first <dict> and last </dict>
        if let dictOpenRange = plistString.range(of: "<dict>\n"),
           let dictCloseRange = plistString.range(of: "\n</dict>", options: .backwards) {
            // Extract content between the dict tags
            let startIndex = dictOpenRange.upperBound
            let endIndex = dictCloseRange.lowerBound
            plistString = String(plistString[startIndex..<endIndex])
        }

        // Clean up indentation - remove leading tabs from each line
        let lines = plistString.components(separatedBy: .newlines)
        let cleanedLines = lines.map { line in
            // Remove leading tabs (usually one tab from the plist formatting)
            var cleaned = line
            if cleaned.hasPrefix("\t") {
                cleaned = String(cleaned.dropFirst())
            }
            return cleaned
        }
        plistString = cleanedLines.joined(separator: "\n")

        // Trim whitespace
        plistString = plistString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Write to file
        try plistString.write(to: url, atomically: true, encoding: .utf8)
    }

    // Export to shell script that writes plist to /Library/Preferences/
    func exportToShellScript(url: URL) throws {
        guard let domain = manifest?.domain else {
            throw NSError(domain: "ConfigurationModel", code: 4, userInfo: [NSLocalizedDescriptionKey: "No domain available for export"])
        }

        let plistDict = generatePlistDictionary()

        // Generate full plist XML
        let plistData = try PropertyListSerialization.data(
            fromPropertyList: plistDict,
            format: .xml,
            options: 0
        )

        // Convert to string
        guard let plistString = String(data: plistData, encoding: .utf8) else {
            throw NSError(domain: "ConfigurationModel", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to convert plist to string"])
        }

        // Generate shell script
        let script = """
        #!/bin/zsh
        #
        # Browser Policy Configuration Script
        # Domain: \(domain)
        # Generated: \(Date().formatted(date: .abbreviated, time: .shortened))
        #
        # This script writes browser policy configuration to:
        #     /Library/Preferences/\(domain).plist
        #
        # Usage: sudo ./\(url.lastPathComponent)
        #

        # Check if running as root
        if [ "$EUID" -ne 0 ]; then
            echo "Error: This script must be run with sudo (root privileges)"
            echo "Usage: sudo $0"
            exit 1
        fi

        # Define target path
        PLIST_PATH="/Library/Preferences/\(domain).plist"

        # Create plist content
        cat > "$PLIST_PATH" <<'PLIST_EOF'
        \(plistString)PLIST_EOF

        # Set proper permissions (readable by all, writable by root)
        chmod 644 "$PLIST_PATH"
        chown root:wheel "$PLIST_PATH"

        echo "Successfully wrote configuration to $PLIST_PATH"
        echo "Configuration contains \(plistDict.count) policy setting(s)"
        """

        // Write script to file
        try script.write(to: url, atomically: true, encoding: .utf8)

        // Make the script executable
        let fileManager = FileManager.default
        let attributes = try fileManager.attributesOfItem(atPath: url.path)
        var permissions = attributes[.posixPermissions] as? NSNumber ?? 0o644
        permissions = NSNumber(value: permissions.uint16Value | 0o111) // Add execute bit
        try fileManager.setAttributes([.posixPermissions: permissions], ofItemAtPath: url.path)
    }

    // MARK: - Import functions
    // Import from existing plist
    func importFromPlist(url: URL, clearExisting: Bool = true) throws {
        let data = try Data(contentsOf: url)
        guard let plistDict = try PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? [String: Any] else {
            throw NSError(domain: "ConfigurationModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid plist format"])
        }

        // Optionally clear existing configuration
        if clearExisting {
            configuredPolicies.removeAll()
        }

        // Import values (will overwrite existing keys with same name)
        for (key, value) in plistDict {
            setPolicy(name: key, value: value)
        }
    }

    // Import from JSON file
    func importFromJSON(url: URL, clearExisting: Bool = true) throws {
        let data = try Data(contentsOf: url)
        guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "ConfigurationModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
        }

        // Optionally clear existing configuration
        if clearExisting {
            configuredPolicies.removeAll()
        }

        // Import values (will overwrite existing keys with same name)
        for (key, value) in jsonDict {
            setPolicy(name: key, value: value)
        }
    }

    // Clear all configured policies
    func clearAll() {
        configuredPolicies.removeAll()
    }
}
