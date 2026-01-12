//
//  DictionaryPolicyInfo.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// Dictionary policy structure types
enum DictionaryStructureType {
    case arrayOfObjects          // Array of dictionaries (e.g., ManagedBookmarks)
    case keyValueDictionary      // Simple dictionary with string keys and various values (e.g., ExtensionSettings)
    case singleObject            // Single dictionary with defined properties (e.g., ProxySettings)
    case complexNested           // Complex nested structure requiring documentation reference

    var hint: String {
        switch self {
        case .arrayOfObjects:
            return "JSON Array of Objects"
        case .keyValueDictionary:
            return "JSON Object (Key-Value Dictionary)"
        case .singleObject:
            return "JSON Object (Dictionary)"
        case .complexNested:
            return "Complex JSON Structure"
        }
    }

    var template: String {
        switch self {
        case .arrayOfObjects:
            return "[\n  {\n    \n  }\n]"
        case .keyValueDictionary:
            return "{\n  \"key1\": \"value1\",\n  \"key2\": \"value2\"\n}"
        case .singleObject:
            return "{\n  \n}"
        case .complexNested:
            return "{\n  \n}"
        }
    }
}

// Lookup table for dictionary-type policies
struct DictionaryPolicyInfo {
    static let structureTypes: [String: DictionaryStructureType] = [
        
        // Array of Objects (Chrome)
        "ManagedBookmarks": .arrayOfObjects,
        "AutoLaunchProtocolsFromOrigins": .arrayOfObjects,
        "RegisteredProtocolHandlers": .arrayOfObjects,
        "SerialAllowUsbDevicesForUrls": .arrayOfObjects,
        "WebHidAllowDevicesForUrls": .arrayOfObjects,
        "WebHidAllowDevicesWithHidUsagesForUrls": .arrayOfObjects,
        "WebUsbAllowDevicesForUrls": .arrayOfObjects,
        "WebAppInstallForceList": .arrayOfObjects,
        "BrowsingDataLifetime": .arrayOfObjects,
        "CACertificatesWithConstraints": .arrayOfObjects,
        "ExemptDomainFileTypePairsFromFileTypeDownloadWarnings": .arrayOfObjects,
        "NTPShortcuts": .arrayOfObjects,
        "SiteSearchSettings": .arrayOfObjects,
        "EnterpriseSearchAggregatorSettings": .arrayOfObjects,

        // Key-Value Dictionaries (Chrome)
        "ExtensionSettings": .keyValueDictionary,
        "WebAppSettings": .keyValueDictionary,
        "ManagedConfigurationPerOrigin": .keyValueDictionary,

        // Single Objects (Chrome)
        "ProxySettings": .singleObject,
        "PrintingPaperSizeDefault": .singleObject,
        "RelaunchWindow": .singleObject,
        "FirstPartySetsOverrides": .singleObject,
        "RelatedWebsiteSetsOverrides": .singleObject,
        "WebRtcIPHandlingUrl": .singleObject,

        // Edge-specific mappings (same structure as Chrome equivalents)
        "ManagedFavorites": .arrayOfObjects, // Edge version of ManagedBookmarks
        "NewTabPageManagedQuickLinks": .arrayOfObjects,
        "ManagedSearchEngines": .arrayOfObjects,
        "AutomaticProfileSwitchingSiteList": .arrayOfObjects,
        "WorkspacesNavigationSettings": .arrayOfObjects,
        "DoNotSilentlyBlockProtocolsFromOrigins": .arrayOfObjects,
        "ExemptFileTypeDownloadWarnings": .arrayOfObjects,
        "PrintPreviewStickySettings": .singleObject,
        
        // Firefox-specific mappings
        "3rdparty": .keyValueDictionary,
        "Authentication": .complexNested,
        "BrowserDataBackup": .keyValueDictionary,
        "Certificates": .complexNested,
        "Containers": .complexNested,
        "ContentAnalysis": .complexNested,
        "Cookies": .complexNested,
        "DisabledCiphers": .keyValueDictionary,
        "DisableSecurityBypass": .keyValueDictionary,
        "DNSOverHTTPS": .complexNested,
        "EnableTrackingProtection": .complexNested,
        "EncryptedMediaExtensions": .keyValueDictionary,
        "Extensions": .arrayOfObjects,
        "FirefoxHome": .keyValueDictionary,
        "FirefoxSuggest": .keyValueDictionary,
        "GenerativeAI": .keyValueDictionary,
        "Handlers": .complexNested,
        "Homepage": .complexNested,
        "InstallAddonsPermission": .complexNested,
        "PDFjs": .keyValueDictionary,
        "Permissions": .complexNested,
        "PictureInPicture": .keyValueDictionary,
        "PopupBlocking": .complexNested,
        "Preferences": .complexNested,
        "Proxy": .keyValueDictionary,
        "SanitizeOnShutdown": .keyValueDictionary,
        "SearchEngines": .complexNested,
        "SecurityDevices": .complexNested,
        "SupportMenu": .keyValueDictionary,
        "UserMessaging": .keyValueDictionary,
        "WebsiteFilter": .complexNested,

    ]

    static func structureType(for policyName: String) -> DictionaryStructureType {
        return structureTypes[policyName] ?? .complexNested
    }
}
