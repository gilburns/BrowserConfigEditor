//
//  DictionaryPolicyInfo.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// Dictionary policy structure types
enum DictionaryStructureType {
    case arrayOfObjects           // Array of dictionaries
    case complexNested            // Complex nested structure requiring documentation reference
    case keyValueDictionary       // Simple dictionary with string keys and various values
    case singleObject             // Single dictionary with defined properties
    case dictAutoLaunchProtocols
    case dictBrowsingDataLifetime
    case dictCACertificatesConstraints
    case dictEnterpriseSearchAggregator
    case dictExemptDomainFileType
    case dictExtensionSettings
    case dictFirstPartySetsOverrides
    case dictManagedBookmarks
    case dictManagedConfigurationPerOrigin
    case dictNTPShortcuts
    case dictPrintingPaperSizeDefault
    case dictProxySettings
    case dictRegisteredProtocolHandlers
    case dictRelaunchWindow
    case dictSerialAllowUsbDevicesForUrls
    case dictSiteSearchObjects
    case dictWebAppInstallForceList
    case dictWebAppSettings
    case dictWebHidAllowDevicesForUrls
    case dictWebHidAllowDevicesWithHidUsagesForUrls
    case dictWebRtcIPHandlingUrl
    case dictWebUsbAllowDevicesForUrls
    // Edge
    case dictAutomaticProfileSwitchingSiteList
    case dictDoNotSilentlyBlockProtocolsFromOrigins
    case dictExemptFileTypeDownloadWarnings
    case dictManagedSearchEngines
    case dictNewTabPageManagedQuickLinks
    case dictPrintPreviewStickySettings
    case dictRelatedWebsiteSetsOverrides
    case dictWorkspacesNavigationSettings
    // Firefox
    case dict3rdparty
    case dictAuthentication
    case dictBrowserDataBackup
    case dictCertificates
    case dictContainers
    case dictContentAnalysis
    case dictCookies
    case dictDisabledCiphers
    case dictDisableSecurityBypass
    case dictDNSOverHTTPS
    case dictEnableTrackingProtection
    case dictEncryptedMediaExtensions
    case dictExtensions
    case dictFirefoxHome
    case dictFirefoxSuggest
    case dictGenerativeAI
    case dictHandlers
    case dictHomepage
    case dictInstallAddonsPermission
    case dictPDFjs
    case dictPermissions
    case dictPictureInPicture
    case dictPopupBlocking
    case dictPreferences
    case dictProxy
    case dictSanitizeOnShutdown
    case dictSearchEngines
    case dictSecurityDevices
    case dictSupportMenu
    case dictUserMessaging
    case dictWebsiteFilter


    var hint: String {
        switch self {
        case .arrayOfObjects:
            return "JSON Array of Objects"
        case .complexNested:
            return "Complex JSON Structure"
        case .keyValueDictionary:
            return "JSON Object (Key-Value Dictionary)"
        case .singleObject:
            return "JSON Object (Dictionary)"
        case .dictAutoLaunchProtocols:
            return "JSON Object (Key-Value Dictionary of AutoLaunchProtocols)"
        case .dictBrowsingDataLifetime:
            return "JSON Object (Key-Value Dictionary of BrowsingDataLifetime)"
        case .dictCACertificatesConstraints:
            return "JSON Object (Key-Value Dictionary of CACertificatesWithConstraints)"
        case .dictEnterpriseSearchAggregator:
            return "JSON Object (Key-Value Dictionary of EnterpriseSearchAggregatorSettings)"
        case .dictExemptDomainFileType:
            return "JSON Object (Key-Value Dictionary of ExemptDomainFileTypePairsFromFileTypeDownloadWarnings)"
        case .dictExtensionSettings:
            return "JSON Object (Key-Value Dictionary of ExtensionSettings)"
        case .dictFirstPartySetsOverrides:
            return "JSON Object (Key-Value Dictionary of FirstPartySetsOverrides)"
        case .dictManagedBookmarks:
            return "JSON Array of Bookmark Objects"
        case .dictManagedConfigurationPerOrigin:
            return "JSON Object (Key-Value Dictionary of ManagedConfigurationPerOrigin)"
        case .dictNTPShortcuts:
            return "JSON Array of NTPShortcut Objects"
        case .dictPrintingPaperSizeDefault:
            return "JSON Object (Key-Value Dictionary of PrintingPaperSizeDefault)"
        case .dictProxySettings:
            return "JSON Object (Key-Value Dictionary of ProxySettings)"
        case .dictRegisteredProtocolHandlers:
            return "JSON Object (Key-Value Dictionary of RegisteredProtocolHandlers)"
        case .dictRelaunchWindow:
            return "JSON Object (Key-Value Dictionary of RelaunchWindow)"
        case .dictSerialAllowUsbDevicesForUrls:
            return "JSON Object (Key-Value Dictionary of SerialAllowUsbDevicesForUrls)"
        case .dictSiteSearchObjects:
            return "JSON Array of SiteSearch Objects"
        case .dictWebAppInstallForceList:
            return "JSON Array of WebAppInstallForceList Objects"
        case .dictWebAppSettings:
            return "JSON Object (Key-Value Dictionary of WebAppSettings)"
        case .dictWebHidAllowDevicesForUrls:
            return "JSON Object (Key-Value Dictionary of WebHidAllowDevicesForUrls)"
        case .dictWebHidAllowDevicesWithHidUsagesForUrls:
            return "JSON Object (Key-Value Dictionary of WebHidAllowDevicesWithHidUsagesForUrls)"
        case .dictWebRtcIPHandlingUrl:
            return "JSON Object (Key-Value Dictionary of WebRtcIPHandlingUrl)"
        case .dictWebUsbAllowDevicesForUrls:
            return "JSON Object (Key-Value Dictionary of WebUsbAllowDevicesForUrls)"
        // Edge
        case .dictAutomaticProfileSwitchingSiteList:
            return "JSON Array of AutomaticProfileSwitchingSiteList Objects"
        case .dictDoNotSilentlyBlockProtocolsFromOrigins:
            return "JSON Object (Key-Value Dictionary of DoNotSilentlyBlockProtocolsFromOrigins)"
        case .dictExemptFileTypeDownloadWarnings:
            return "JSON Object (Key-Value Dictionary of ExemptFileTypeDownloadWarnings)"
        case .dictManagedSearchEngines:
            return "JSON Array of ManagedSearchEngine Objects"
        case .dictNewTabPageManagedQuickLinks:
            return "JSON Array of NewTabPageManagedQuickLinks Objects"
        case .dictPrintPreviewStickySettings:
            return "JSON Object (Key-Value Dictionary of PrintPreviewStickySettings)"
        case .dictRelatedWebsiteSetsOverrides:
            return "JSON Object (Key-Value Dictionary of RelatedWebsiteSetsOverrides)"
        case .dictWorkspacesNavigationSettings:
            return "JSON Object (Key-Value Dictionary of WorkspacesNavigationSettings)"
        // Firefox
        case .dict3rdparty:
            return "JSON Object (Key-Value Dictionary of 3rdparty)"
        case .dictAuthentication:
            return "JSON Object (Key-Value Dictionary of Authentication)"
        case .dictBrowserDataBackup:
            return "JSON Object (Key-Value Dictionary of BrowserDataBackup)"
        case .dictCertificates:
            return "JSON Object (Key-Value Dictionary of Certificates)"
        case .dictContainers:
            return "JSON Object (Key-Value Dictionary of Containers)"
        case .dictContentAnalysis:
            return "JSON Object (Key-Value Dictionary of ContentAnalysis)"
        case .dictCookies:
            return "JSON Object (Key-Value Dictionary of Cookies)"
        case .dictDisabledCiphers:
            return "JSON Array of DisabledCipher Objects"
        case .dictDisableSecurityBypass:
            return "JSON Object (Key-Value Dictionary of DisableSecurityBypass)"
        case .dictDNSOverHTTPS:
            return "JSON Object (Key-Value Dictionary of DNSOverHTTPS)"
        case .dictEnableTrackingProtection:
            return "JSON Object (Key-Value Dictionary of EnableTrackingProtection)"
        case .dictEncryptedMediaExtensions:
            return "JSON Array of EncryptedMediaExtension Objects"
        case .dictExtensions:
            return "JSON Array of Extension Objects"
        case .dictFirefoxHome:
            return "JSON Object (Key-Value Dictionary of FirefoxHome)"
        case .dictFirefoxSuggest:
            return "JSON Object (Key-Value Dictionary of FirefoxSuggest)"
        case .dictGenerativeAI:
            return "JSON Object (Key-Value Dictionary of GenerativeAI)"
        case .dictHandlers:
            return "JSON Array of Handler Objects"
        case .dictHomepage:
            return "JSON Object (Key-Value Dictionary of Homepage)"
        case .dictInstallAddonsPermission:
            return "JSON Object (Key-Value Dictionary of InstallAddonsPermission)"
        case .dictPDFjs:
            return "JSON Object (Key-Value Dictionary of PDFjs)"
        case .dictPermissions:
            return "JSON Array of Permission Objects"
        case .dictPictureInPicture:
            return "JSON Object (Key-Value Dictionary of PictureInPicture)"
        case .dictPopupBlocking:
            return "JSON Object (Key-Value Dictionary of PopupBlocking)"
        case .dictPreferences:
            return "JSON Object (Key-Value Dictionary of Preferences)"
        case .dictProxy:
            return "JSON Object (Key-Value Dictionary of Proxy)"
        case .dictSanitizeOnShutdown:
            return "JSON Object (Key-Value Dictionary of SanitizeOnShutdown)"
        case .dictSearchEngines:
            return "JSON Array of SearchEngine Objects"
        case .dictSecurityDevices:
            return "JSON Array of SecurityDevice Objects"
        case .dictSupportMenu:
            return "JSON Object (Key-Value Dictionary of SupportMenu)"
        case .dictUserMessaging:
            return "JSON Object (Key-Value Dictionary of UserMessaging)"
        case .dictWebsiteFilter:
            return "JSON Object (Key-Value Dictionary of WebsiteFilter)"
        }
    }

    var template: String {
        switch self {
        case .arrayOfObjects:
            return "[\n  {\n    \n  }\n]"
        case .complexNested:
            return "{\n  \n}"
        case .keyValueDictionary:
            return "{\n  \"key1\": \"value1\",\n  \"key2\": \"value2\"\n}"
        case .singleObject:
            return "{\n  \n}"
        case .dictAutoLaunchProtocols:
            return "[\n {\n  \"allowed_origins\": [\n   \"example.com\",\n   \"http://www.example.com:8080\"\n  ],\n  \"protocol\": \"spotify\"\n },\n {\n  \"allowed_origins\": [\n   \"https://example.com\",\n   \"https://.mail.example.com\"\n  ],\n  \"protocol\": \"teams\"\n },\n {\n  \"allowed_origins\": [\n   \"*\"\n  ],\n  \"protocol\": \"outlook\"\n }\n]"
        case .dictBrowsingDataLifetime:
            return "[\n {\n  \"data_types\": [\n   \"browsing_history\"\n  ],\n  \"time_to_live_in_hours\": 24\n },\n {\n  \"data_types\": [\n   \"password_signin\",\n   \"autofill\"\n  ],\n  \"time_to_live_in_hours\": 12\n }\n]"
        case .dictCACertificatesConstraints:
            return "[\n {\n  \"certificate\": \"MIICCTCCAY6gAwIBAgINAgPluILrIPglJ209ZjAKBggqhkjOPQQDAzBHMQswCQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExMQzEUMBIGA1UEAxMLR1RTIFJvb3QgUjMwHhcNMTYwNjIyMDAwMDAwWhcNMzYwNjIyMDAwMDAwWjBHMQswCQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExMQzEUMBIGA1UEAxMLR1RTIFJvb3QgUjMwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAAQfTzOHMymKoYTey8chWEGJ6ladK0uFxh1MJ7x/JlFyb+Kf1qPKzEUURout736GjOyxfi//qXGdGIRFBEFVbivqJn+7kAHjSxm65FSWRQmx1WyRRK2EE46ajA2ADDL24CejQjBAMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTB8Sa6oC2uhYHP0/EqEr24Cmf9vDAKBggqhkjOPQQDAwNpADBmAjEA9uEglRR7VKOQFhG/hMjqb2sXnh5GmCCbn9MN2azTL818+FsuVbu/3ZL3pAzcMeGiAjEA/JdmZuVDFhOD3cffL74UOO0BzrEXGhF16b0DjyZ+hOXJYKaV11RZt+cRLInUue4X\",\n  \"constraints\": {\n   \"permitted_dns_names\": [\n    \"example.org\"\n   ],\n   \"permitted_cidrs\": [\n    \"10.1.1.0/24\"\n   ]\n  }\n }\n]"
        case .dictEnterpriseSearchAggregator:
            return "{\n \"name\": \"My Search Aggregator\",\n \"shortcut\": \"work\",\n \"search_url\": \"https://www.aggregator.com/search?q={searchTerms}\",\n \"suggest_url\": \"https://www.aggregator.com/suggest\",\n \"icon_url\": \"https://www.google.com/favicon.ico\",\n \"require_shortcut\": true\n}"
        case .dictExemptDomainFileType:
            return "[\n {\n  \"domains\": [\n   \"https://example.com\",\n   \"example2.com\"\n  ],\n  \"file_extension\": \"jnlp\"\n },\n {\n  \"domains\": [\n   \"*\"\n  ],\n  \"file_extension\": \"swf\"\n }\n]"
        case .dictExtensionSettings:
            return "{\n \"*\": {\n  \"allowed_types\": [\n   \"hosted_app\"\n  ],\n  \"blocked_install_message\": \"Custom error message.\",\n  \"blocked_permissions\": [\n   \"downloads\",\n   \"bookmarks\"\n  ],\n  \"install_sources\": [\n   \"https://company-intranet/chromeapps\"\n  ],\n  \"installation_mode\": \"blocked\",\n  \"runtime_allowed_hosts\": [\n   \"*://good.example.com\"\n  ],\n  \"runtime_blocked_hosts\": [\n   \"*://*.example.com\"\n  ]\n },\n \"abcdefghijklmnopabcdefghijklmnop\": {\n  \"blocked_permissions\": [\n   \"history\"\n  ],\n  \"installation_mode\": \"allowed\",\n  \"minimum_version_required\": \"1.0.1\",\n  \"toolbar_pin\": \"force_pinned\",\n  \"file_url_navigation_allowed\": true\n },\n \"bcdefghijklmnopabcdefghijklmnopa\": {\n  \"allowed_permissions\": [\n   \"downloads\"\n  ],\n  \"installation_mode\": \"force_installed\",\n  \"runtime_allowed_hosts\": [\n   \"*://good.example.com\"\n  ],\n  \"runtime_blocked_hosts\": [\n   \"*://*.example.com\"\n  ],\n  \"update_url\": \"https://example.com/update_url\"\n },\n \"cdefghijklmnopabcdefghijklmnopab\": {\n  \"blocked_install_message\": \"Custom error message.\",\n  \"installation_mode\": \"blocked\"\n },\n \"defghijklmnopabcdefghijklmnopabc,efghijklmnopabcdefghijklmnopabcd\": {\n  \"blocked_install_message\": \"Custom error message.\",\n  \"installation_mode\": \"blocked\"\n },\n \"fghijklmnopabcdefghijklmnopabcde\": {\n  \"blocked_install_message\": \"Custom removal message.\",\n  \"installation_mode\": \"removed\"\n },\n \"ghijklmnopabcdefghijklmnopabcdef\": {\n  \"installation_mode\": \"force_installed\",\n  \"override_update_url\": true,\n  \"update_url\": \"https://example.com/update_url\"\n },\n \"update_url:https://www.example.com/update.xml\": {\n  \"allowed_permissions\": [\n   \"downloads\"\n  ],\n  \"blocked_permissions\": [\n   \"wallpaper\"\n  ],\n  \"installation_mode\": \"allowed\"\n }\n}"
        case .dictFirstPartySetsOverrides:
            return "{\n \"additions\": [\n  {\n   \"associatedSites\": [\n    \"https://associate2.test\"\n   ],\n   \"ccTLDs\": {\n    \"https://associate2.test\": [\n     \"https://associate2.com\"\n    ]\n   },\n   \"primary\": \"https://primary2.test\",\n   \"serviceSites\": [\n    \"https://associate2-content.test\"\n   ]\n  }\n ],\n \"replacements\": [\n  {\n   \"associatedSites\": [\n    \"https://associate1.test\"\n   ],\n   \"ccTLDs\": {\n    \"https://associate1.test\": [\n     \"https://associate1.co.uk\"\n    ]\n   },\n   \"primary\": \"https://primary1.test\",\n   \"serviceSites\": [\n    \"https://associate1-content.test\"\n   ]\n  }\n ]\n}"
        case .dictManagedBookmarks:
            return "[\n {\n  \"toplevel_name\": \"My managed bookmarks folder\"\n },\n {\n  \"name\": \"Google\",\n  \"url\": \"google.com\"\n },\n {\n  \"name\": \"Apple\",\n  \"url\": \"apple.com\"\n },\n {\n  \"children\": [\n   {\n    \"name\": \"Chromium\",\n    \"url\": \"chromium.org\"\n   },\n   {\n    \"name\": \"Chromium Developers\",\n    \"url\": \"dev.chromium.org\"\n   }\n  ],\n  \"name\": \"Chrome links\"\n }\n]"
        case .dictManagedConfigurationPerOrigin:
            return "[\n {\n  \"managed_configuration_hash\": \"asd891jedasd12ue9h\",\n  \"managed_configuration_url\": \"https://gstatic.google.com/configuration.json\",\n  \"origin\": \"https://www.google.com\"\n },\n {\n  \"managed_configuration_hash\": \"djio12easd89u12aws\",\n  \"managed_configuration_url\": \"https://gstatic.google.com/configuration2.json\",\n  \"origin\": \"https://www.example.com\"\n }\n]"
        case .dictNTPShortcuts:
            return "[\n {\n  \"name\": \"Google\",\n  \"url\": \"https://www.google.com\"\n },\n {\n  \"name\": \"YouTube\",\n  \"url\": \"https://www.youtube.com\"\n },\n {\n  \"name\": \"Google Drive\",\n  \"url\": \"https://www.drive.google.com\",\n  \"allow_user_edit\": true,\n  \"allow_user_delete\": true\n }\n]"
        case .dictPrintingPaperSizeDefault:
            return "{\n \"custom_size\": {\n  \"height\": 297000,\n  \"width\": 210000\n },\n \"name\": \"custom\"\n}"
        case .dictProxySettings:
            return "{\n \"ProxyBypassList\": \"https://www.example1.com,https://www.example2.com,https://internalsite/\",\n \"ProxyMode\": \"fixed_servers\",\n \"ProxyServer\": \"123.123.123.123:8080\"\n}"
        case .dictRegisteredProtocolHandlers:
            return "[\n {\n  \"default\": true,\n  \"protocol\": \"mailto\",\n  \"url\": \"https://mail.google.com/mail/?extsrc=mailto&url=%s\"\n }\n]"
        case .dictRelaunchWindow:
            return "{\n \"entries\": [\n  {\n   \"duration_mins\": 240,\n   \"start\": {\n    \"hour\": 2,\n    \"minute\": 15\n   }\n  }\n ]\n}"
        case .dictSerialAllowUsbDevicesForUrls:
            return "[\n {\n  \"devices\": [\n   {\n    \"product_id\": 5678,\n    \"vendor_id\": 1234\n   }\n  ],\n  \"urls\": [\n   \"https://specific-device.example.com\"\n  ]\n },\n {\n  \"devices\": [\n   {\n    \"vendor_id\": 1234\n   }\n  ],\n  \"urls\": [\n   \"https://all-vendor-devices.example.com\"\n  ]\n }\n]"
        case .dictSiteSearchObjects:
            return "[\n {\n  \"featured\": true,\n  \"name\": \"Google Wikipedia\",\n  \"shortcut\": \"wikipedia\",\n  \"url\": \"https://www.google.com/search?q=site%3Awikipedia.com+%s\"\n },\n {\n  \"name\": \"YouTube\",\n  \"shortcut\": \"youtube\",\n  \"url\": \"https://www.youtube.com/results?search_query=%s\"\n },\n {\n  \"name\": \"Google Drive\",\n  \"shortcut\": \"drive\",\n  \"url\": \"https://drive.google.com/?q=%s\",\n  \"allow_user_override\": true\n }\n]"
        case .dictWebAppInstallForceList:
            return "[\n {\n  \"create_desktop_shortcut\": true,\n  \"default_launch_container\": \"window\",\n  \"url\": \"https://www.google.com/maps\"\n },\n {\n  \"default_launch_container\": \"tab\",\n  \"url\": \"https://docs.google.com\"\n },\n {\n  \"default_launch_container\": \"window\",\n  \"fallback_app_name\": \"Editor\",\n  \"url\": \"https://docs.google.com/editor\"\n },\n {\n  \"custom_name\": \"My important document\",\n  \"default_launch_container\": \"window\",\n  \"install_as_shortcut\": true,\n  \"url\": \"https://docs.google.com/document/d/ds187akjqih89\"\n },\n {\n  \"custom_icon\": {\n   \"hash\": \"c28f469c450e9ab2b86ea47038d2b324c6ad3b1e9a4bd8960da13214afd0ca38\",\n   \"url\": \"https://mydomain.example.com/sunny_icon.png\"\n  },\n  \"url\": \"https://weather.example.com\"\n }\n]"
        case .dictWebHidAllowDevicesWithHidUsagesForUrls:
            return "[\n {\n  \"urls\": [\n   \"https://google.com\",\n   \"https://chromium.org\"\n  ],\n  \"usages\": [\n   {\n    \"usage\": 5678,\n    \"usage_page\": 1234\n   }\n  ]\n }\n]"
        case .dictWebAppSettings:
            return "[\n {\n  \"manifest_id\": \"https://foo.example/index.html\",\n  \"run_on_os_login\": \"allowed\"\n },\n {\n  \"manifest_id\": \"https://bar.example/index.html\",\n  \"run_on_os_login\": \"allowed\"\n },\n {\n  \"manifest_id\": \"https://foobar.example/index.html\",\n  \"run_on_os_login\": \"run_windowed\",\n  \"prevent_close_after_run_on_os_login\": true\n },\n {\n  \"manifest_id\": \"*\",\n  \"run_on_os_login\": \"blocked\"\n },\n {\n  \"manifest_id\": \"https://foo.example/index.html\",\n  \"force_unregister_os_integration\": true\n }\n]"
        case .dictWebHidAllowDevicesForUrls:
            return "[\n {\n  \"devices\": [\n   {\n    \"product_id\": 5678,\n    \"vendor_id\": 1234\n   }\n  ],\n  \"urls\": [\n   \"https://google.com\",\n   \"https://chromium.org\"\n  ]\n }\n]"
        case .dictWebRtcIPHandlingUrl:
            return "[\n {\n  \"url\": \"https://www.example.com\",\n  \"handling\": \"default_public_and_private_interfaces\"\n },\n {\n  \"url\": \"https://[*.]example.edu\",\n  \"handling\": \"default_public_interface_only\"\n },\n {\n  \"url\": \"*\",\n  \"handling\": \"disable_non_proxied_udp\"\n }\n]"
        case .dictWebUsbAllowDevicesForUrls:
            return "[\n {\n  \"devices\": [\n   {\n    \"product_id\": 5678,\n    \"vendor_id\": 1234\n   }\n  ],\n  \"urls\": [\n   \"https://google.com\"\n  ]\n }\n]"
        // Edge
        case .dictAutomaticProfileSwitchingSiteList:
            return "[\n  {\n    \"profile\": \"Work\",\n    \"site\": \"work.com\"\n  },\n  {\n    \"profile\": \"Personal\",\n    \"site\": \"personal.com\"\n  },\n  {\n    \"profile\": \"No preference\",\n    \"site\": \"nopreference.com\"\n  },\n  {\n    \"profile\": \"*@contoso.com\",\n    \"site\": \"contoso.com\"\n  }\n]"
        case .dictDoNotSilentlyBlockProtocolsFromOrigins:
            return "[\n  {\n    \"allowed_origins\": [\n      \"example.com\",\n      \"http://www.example.com:8080\"\n    ],\n    \"protocol\": \"spotify\"\n  },\n  {\n    \"allowed_origins\": [\n      \"https://example.com\",\n      \"https://.mail.example.com\"\n    ],\n    \"protocol\": \"msteams\"\n  },\n  {\n    \"allowed_origins\": [\n      \"*\"\n    ],\n    \"protocol\": \"msoutlook\"\n  }\n]"
        case .dictExemptFileTypeDownloadWarnings:
            return "[\n  {\n    \"domains\": [\n      \"https://contoso.com\",\n      \"contoso2.com\"\n    ],\n    \"file_extension\": \"jnlp\"\n  },\n  {\n    \"domains\": [\n      \"*\"\n    ],\n    \"file_extension\": \"swf\"\n  }\n]"
        case .dictManagedSearchEngines:
            return "[\n  {\n    \"allow_search_engine_discovery\": true\n  },\n  {\n    \"is_default\": true,\n    \"keyword\": \"example1.com\",\n    \"name\": \"Example1\",\n    \"search_url\": \"https://www.example1.com/search?q={searchTerms}\",\n    \"suggest_url\": \"https://www.example1.com/qbox?query={searchTerms}\"\n  },\n  {\n    \"image_search_post_params\": \"content={imageThumbnail},url={imageURL},sbisrc={SearchSource}\",\n    \"image_search_url\": \"https://www.example2.com/images/detail/search?iss=sbiupload\",\n    \"keyword\": \"example2.com\",\n    \"name\": \"Example2\",\n    \"search_url\": \"https://www.example2.com/search?q={searchTerms}\",\n    \"suggest_url\": \"https://www.example2.com/qbox?query={searchTerms}\"\n  },\n  {\n    \"encoding\": \"UTF-8\",\n    \"image_search_url\": \"https://www.example3.com/images/detail/search?iss=sbiupload\",\n    \"keyword\": \"example3.com\",\n    \"name\": \"Example3\",\n    \"search_url\": \"https://www.example3.com/search?q={searchTerms}\",\n    \"suggest_url\": \"https://www.example3.com/qbox?query={searchTerms}\"\n  },\n  {\n    \"keyword\": \"example4.com\",\n    \"name\": \"Example4\",\n    \"search_url\": \"https://www.example4.com/search?q={searchTerms}\"\n  }\n]"
        case .dictNewTabPageManagedQuickLinks:
            return "[\n  {\n    \"pinned\": true,\n    \"title\": \"Contoso Portal\",\n    \"url\": \"https://contoso.com\"\n  },\n  {\n    \"title\": \"Fabrikam\",\n    \"url\": \"https://fabrikam.com\"\n  }\n]"
        case .dictPrintPreviewStickySettings:
            return "{\n  \"layout\": false,\n  \"margins\": true,\n  \"scaleType\": false,\n  \"size\": true\n}"
        case .dictRelatedWebsiteSetsOverrides:
            return "{\n  \"additions\": [\n    {\n      \"associatedSites\": [\n        \"https://associate2.test\"\n      ],\n      \"ccTLDs\": {\n        \"https://associate2.test\": [\n          \"https://associate2.com\"\n        ]\n      },\n      \"primary\": \"https://primary2.test\",\n      \"serviceSites\": [\n        \"https://associate2-content.test\"\n      ]\n    }\n  ],\n  \"replacements\": [\n    {\n      \"associatedSites\": [\n        \"https://associate1.test\"\n      ],\n      \"ccTLDs\": {\n        \"https://associate1.test\": [\n          \"https://associate1.co.uk\"\n        ]\n      },\n      \"primary\": \"https://primary1.test\",\n      \"serviceSites\": [\n        \"https://associate1-content.test\"\n      ]\n    }\n  ]\n}"
        case .dictWorkspacesNavigationSettings:
            return "[\n  {\n    \"navigation_options\": {\n      \"do_not_send_to\": true,\n      \"remove_all_query_parameters\": true\n    },\n    \"url_patterns\": [\n      \"https://contoso.com\",\n      \"https://www.fabrikam.com\",\n      \".exact.hostname.com\"\n    ]\n  },\n  {\n    \"navigation_options\": {\n      \"query_parameters_to_remove\": [\n        \"username\",\n        \"login_hint\"\n      ]\n    },\n    \"url_patterns\": [\n      \"https://adatum.com\"\n    ]\n  },\n  {\n    \"navigation_options\": {\n      \"do_not_send_from\": true,\n      \"prefer_initial_url\": true\n    },\n    \"url_regex_patterns\": [\n      \"\\Ahttps://.*?tafe\\..*?trs.*?\\.fabrikam.com/Sts\"\n    ]\n  }\n]"
        // Firefox
        case .dict3rdparty:
            return "{\n  \"Extensions\": {\n    \"uBlock0@raymondhill.net\": {\n      \"adminSettings\": {\n        \"selectedFilterLists\": [\n          \"ublock-privacy\",\n          \"ublock-badware\",\n          \"ublock-filters\",\n          \"user-filters\"\n        ]\n      }\n    }\n  }\n}"
        case .dictAuthentication:
            return "{\n  \"SPNEGO\": [\"mydomain.com\", \"https://myotherdomain.com\"],\n  \"Delegated\": [\"mydomain.com\", \"https://myotherdomain.com\"],\n  \"NTLM\": [\"mydomain.com\", \"https://myotherdomain.com\"],\n  \"AllowNonFQDN\": {\n    \"SPNEGO\": true,\n    \"NTLM\": true\n  },\n  \"AllowProxies\": {\n    \"SPNEGO\": true,\n    \"NTLM\": true\n  },\n  \"Locked\": true,\n  \"PrivateBrowsing\": true\n}"
        case .dictBrowserDataBackup:
            return "{\n   \"AllowBackup\": false,\n   \"AllowRestore\": false\n}"
        case .dictCertificates:
            return "{\n  \"ImportEnterpriseRoots\": true,\n  \"Install\": [\"cert1.der\", \"/home/username/cert2.pem\"]\n}"
        case .dictContainers:
            return "{\n  \"Default\": [\n   {\n    \"name\": \"My container\",\n    \"icon\": \"pet\",\n    \"color\": \"turquoise\"\n   }\n  ]\n}"
        case .dictContentAnalysis:
            return "{\n  \"AgentName\": \"My DLP Product\",\n  \"AgentTimeout\": 60,\n  \"AllowUrlRegexList\": \"https://example\\.com/.* https://subdomain\\.example\\.com/.*\",\n  \"BypassForSameTabOperations\": true,\n  \"ClientSignature\": \"My DLP Company\",\n  \"DefaultResult\": 2,\n  \"DenyUrlRegexList\": \"https://example\\.com/.* https://subdomain\\.example\\.com/.*\",\n  \"Enabled\": true,\n  \"InterceptionPoints\": {\n  \"Clipboard\": {\n  \"Enabled\": true,\n  \"PlainTextOnly\": true\n  },\n  \"Download\": {\n  \"Enabled\": false\n  },\n  \"DragAndDrop\": {\n  \"Enabled\": true,\n  \"PlainTextOnly\": true\n  },\n  \"FileUpload\": {\n  \"Enabled\": true\n  },\n  \"Print\": {\n  \"Enabled\": true\n  }\n  },\n  \"IsPerUser\": true,\n  \"PipePathName\": \"pipe_custom_name\",\n  \"ShowBlockedResult\": true,\n  \"TimeoutResult\": 2\n}"
        case .dictCookies:
            return "{\n  \"Allow\": [\"http://example.org/\"],\n  \"AllowSession\": [\"http://example.edu/\"],\n  \"Block\": [\"http://example.edu/\"],\n  \"Locked\": true,\n  \"Behavior\": \"reject-tracker\",\n  \"BehaviorPrivateBrowsing\": \"accept\"\n}"
        case .dictDisabledCiphers:
            return "{\n  \"CIPHER_NAME\": true\n}"
        case .dictDisableSecurityBypass:
            return "{\n  \"InvalidCertificate\": true,\n  \"SafeBrowsing\": true\n}"
        case .dictDNSOverHTTPS:
            return "{\n  \"Enabled\":  true,\n  \"ProviderURL\": \"URL_TO_ALTERNATE_PROVIDER\",\n  \"Locked\": true,\n  \"ExcludedDomains\": [\"example.com\"],\n  \"Fallback\": true\n}"
        case .dictEnableTrackingProtection:
            return "{\n  \"Value\": true,\n  \"Locked\": true,\n  \"Cryptomining\": true,\n  \"Fingerprinting\": true,\n  \"EmailTracking\": true,\n  \"SuspectedFingerprinting\": true,\n  \"Category\": \"strict\",\n  \"Exceptions\": [\"https://example.com\"],\n  \"BaselineExceptions\": true,\n  \"ConvenienceExceptions\": true\n}"
        case .dictEncryptedMediaExtensions:
            return "{\n  \"Enabled\": true,\n  \"Locked\": true\n}\n"
        case .dictExtensions:
            return "{\n  \"Install\": [\"https://addons.mozilla.org/firefox/downloads/somefile.xpi\", \"//path/to/xpi\"],\n  \"Uninstall\": [\"bad_addon_id@mozilla.org\"],\n  \"Locked\":  [\"addon_id@mozilla.org\"]\n}"
        case .dictFirefoxHome:
            return "{\n  \"Search\": true,\n  \"TopSites\": true,\n  \"SponsoredTopSites\": true,\n  \"Highlights\": true,\n  \"Pocket\": true,\n  \"Stories\": true,\n  \"SponsoredPocket\": true,\n  \"SponsoredStories\": true,\n  \"Snippets\": true,\n  \"Locked\": true\n}"
        case .dictFirefoxSuggest:
            return "{\n  \"WebSuggestions\": true,\n  \"SponsoredSuggestions\": true,\n  \"ImproveSuggest\": true,\n  \"Locked\": true\n}"
        case .dictGenerativeAI:
            return "{\n  \"Enabled\": true,\n  \"Chatbot\": true,\n  \"LinkPreviews\": true,\n  \"TabGroups\": true,\n  \"Locked\": true\n}"
        case .dictHandlers:
            return "{\n  \"mimeTypes\": {\n    \"application/msword\": {\n      \"action\": \"useSystemDefault\",\n      \"ask\": false\n    }\n  },\n  \"schemes\": {\n    \"mailto\": {\n      \"action\": \"useHelperApp\",\n      \"ask\": true,\n      \"handlers\": [{\n    \"name\": \"Gmail\",\n    \"uriTemplate\": \"https://mail.google.com/mail/?extsrc=mailto&url=%s\"\n      }]\n    }\n  },\n  \"extensions\": {\n    \"pdf\": {\n      \"action\": \"useHelperApp\",\n      \"ask\": true,\n      \"handlers\": [{\n    \"name\": \"Adobe Acrobat\",\n    \"path\": \"/usr/bin/acroread\"\n      }]\n    }\n  }\n}"
        case .dictHomepage:
            return "{\n  \"URL\": \"http://example.com/\",\n  \"Locked\": true,\n  \"Additional\": [\"http://example.org/\",\n         \"http://example.edu/\"],\n  \"StartPage\": \"homepage\"\n}"
        case .dictInstallAddonsPermission:
            return "{\n  \"Allow\": [\"http://example.org/\",\n        \"http://example.edu/\"],\n  \"Default\": true\n}"
        case .dictPDFjs:
            return "{\n  \"Enabled\": true,\n  \"EnablePermissions\": true\n}"
        case .dictPermissions:
            return "{\n  \"Camera\": {\n    \"Allow\": [\"https://example.org\",\"https://example.org:1234\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  },\n  \"Microphone\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  },\n  \"Location\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  },\n  \"Notifications\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  },\n  \"Autoplay\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"Default\": \"block-audio-video\",\n    \"Locked\": true\n  },\n  \"VirtualReality\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  },\n  \"ScreenShare\": {\n    \"Allow\": [\"https://example.org\"],\n    \"Block\": [\"https://example.edu\"],\n    \"BlockNewRequests\": true,\n    \"Locked\": true\n  }\n}"
        case .dictPictureInPicture:
            return "{\n  \"Enabled\": true,\n  \"Locked\": true\n}"
        case .dictPopupBlocking:
            return "{\n  \"Allow\": [\"http://example.org/\",\n        \"http://example.edu/\"],\n  \"Default\": true,\n  \"Locked\": true\n}"
        case .dictPreferences:
            return "{\n  \"accessibility.force_disabled\": {\n    \"Value\": 1,\n    \"Status\": \"default\",\n    \"Type\": \"number\"\n  },\n  \"browser.cache.disk.parent_directory\": {\n    \"Value\": \"SOME_NATIVE_PATH\",\n    \"Status\": \"user\"\n  },\n  \"browser.tabs.warnOnClose\": {\n    \"Value\": false,\n    \"Status\": \"locked\"\n  }\n}"
        case .dictProxy:
            return "{\n  \"Mode\": \"autoDetect\",\n  \"Locked\": true,\n  \"HTTPProxy\": \"hostname\",\n  \"UseHTTPProxyForAllProtocols\": true,\n  \"SSLProxy\": \"hostname\",\n  \"FTPProxy\": \"hostname\",\n  \"SOCKSProxy\": \"hostname\",\n  \"SOCKSVersion\": 4,\n  \"Passthrough\": \"<local>\",\n  \"AutoConfigURL\": \"URL_TO_AUTOCONFIG\",\n  \"AutoLogin\": true,\n  \"UseProxyForDNS\": true\n}"
        case .dictSanitizeOnShutdown:
            return "{\n  \"Cache\": false,\n  \"Cookies\": false,\n  \"FormData\": false,\n  \"History\": false,\n  \"Sessions\": false,\n  \"SiteSettings\": false,\n  \"Locked\": true\n}"
        case .dictSearchEngines:
            return "{\n  \"Add\": [\n    {\n      \"Name\": \"Example1\",\n      \"URLTemplate\": \"https://www.example.org/q={searchTerms}\",\n      \"Method\": \"GET\",\n      \"IconURL\": \"https://www.example.org/favicon.ico\",\n      \"Alias\": \"example\",\n      \"Description\": \"Description\",\n      \"PostData\": \"name=value&q={searchTerms}\",\n      \"SuggestURLTemplate\": \"https://www.example.org/suggestions/q={searchTerms}\"\n    }\n  ],\n  \"Default\": \"NAME_OF_SEARCH_ENGINE\",\n  \"PreventInstalls\": true,\n  \"Remove\": [\"NAME_OF_SEARCH_ENGINE\"]\n}"
        case .dictSecurityDevices:
            return "{\n  \"Add\": {\n    \"NAME_OF_DEVICE_TO_ADD\": \"PATH_TO_LIBRARY_FOR_DEVICE\"\n  },\n  \"Delete\": [\"NAME_OF_DEVICE_TO_DELETE\"]\n}"
        case .dictSupportMenu:
            return "{\n  \"Title\": \"Support Menu\",\n  \"URL\": \"http://example.com/support\",\n  \"AccessKey\": \"S\"\n}"
        case .dictUserMessaging:
            return "{\n  \"ExtensionRecommendations\": false,\n  \"FeatureRecommendations\": true,\n  \"UrlbarInterventions\": false,\n  \"SkipOnboarding\": true,\n  \"MoreFromMozilla\": true,\n  \"FirefoxLabs\": false,\n  \"Locked\": true\n}"
        case .dictWebsiteFilter:
            return "{\n  \"Block\": [\"<all_urls>\"],\n  \"Exceptions\": [\"http://example.org/*\"]\n}"
        }
    }
}

// Lookup table for dictionary-type policies
struct DictionaryPolicyInfo {
    static let structureTypes: [String: DictionaryStructureType] = [
        
        // Disctonaries (Chrome)
        "AutoLaunchProtocolsFromOrigins": .dictAutoLaunchProtocols,
        "BrowsingDataLifetime": .dictBrowsingDataLifetime,
        "CACertificatesWithConstraints": .dictCACertificatesConstraints,
        "EnterpriseSearchAggregatorSettings": .dictEnterpriseSearchAggregator,
        "ExemptDomainFileTypePairsFromFileTypeDownloadWarnings": .dictExemptDomainFileType,
        "ExtensionSettings": .dictExtensionSettings,
        "FirstPartySetsOverrides": .dictFirstPartySetsOverrides,
        "ManagedBookmarks": .dictManagedBookmarks,
        "ManagedConfigurationPerOrigin": .dictManagedConfigurationPerOrigin,
        "NTPShortcuts": .dictNTPShortcuts,
        "PrintingPaperSizeDefault": .dictPrintingPaperSizeDefault,
        "ProxySettings": .dictProxySettings,
        "RegisteredProtocolHandlers": .dictRegisteredProtocolHandlers,
        "RelaunchWindow": .dictRelaunchWindow,
        "SerialAllowUsbDevicesForUrls": .dictSerialAllowUsbDevicesForUrls,
        "SiteSearchSettings": .dictSiteSearchObjects,
        "WebAppInstallForceList": .dictWebAppInstallForceList,
        "WebAppSettings": .dictWebAppSettings,
        "WebHidAllowDevicesForUrls": .dictWebHidAllowDevicesForUrls,
        "WebHidAllowDevicesWithHidUsagesForUrls": .dictWebHidAllowDevicesWithHidUsagesForUrls,
        "WebRtcIPHandlingUrl": .dictWebRtcIPHandlingUrl,
        "WebUsbAllowDevicesForUrls": .dictWebUsbAllowDevicesForUrls,

        // Edge-specific mappings (same structure as Chrome equivalents)
        "AutomaticProfileSwitchingSiteList": .dictAutomaticProfileSwitchingSiteList,
        "DoNotSilentlyBlockProtocolsFromOrigins": .dictDoNotSilentlyBlockProtocolsFromOrigins,
        "ExemptFileTypeDownloadWarnings": .dictExemptFileTypeDownloadWarnings,
        "ManagedFavorites": .dictManagedBookmarks, // Edge version of ManagedBookmarks
        "ManagedSearchEngines": .dictManagedSearchEngines,
        "NewTabPageManagedQuickLinks": .dictNewTabPageManagedQuickLinks,
        "PrintPreviewStickySettings": .dictPrintPreviewStickySettings,
        "RelatedWebsiteSetsOverrides": .dictRelatedWebsiteSetsOverrides,
        "WorkspacesNavigationSettings": .dictWorkspacesNavigationSettings,
        
        // Firefox-specific mappings
        "3rdparty": .dict3rdparty,
        "Authentication": .dictAuthentication,
        "BrowserDataBackup": .dictBrowserDataBackup,
        "Certificates": .dictCertificates,
        "Containers": .dictContainers,
        "ContentAnalysis": .dictContentAnalysis,
        "Cookies": .dictCookies,
        "DisabledCiphers": .dictDisabledCiphers,
        "DisableSecurityBypass": .dictDisableSecurityBypass,
        "DNSOverHTTPS": .dictDNSOverHTTPS,
        "EnableTrackingProtection": .dictEnableTrackingProtection,
        "EncryptedMediaExtensions": .dictEncryptedMediaExtensions,
        "Extensions": .dictExtensions,
        "FirefoxHome": .dictFirefoxHome,
        "FirefoxSuggest": .dictFirefoxSuggest,
        "GenerativeAI": .dictGenerativeAI,
        "Handlers": .dictHandlers,
        "Homepage": .dictHomepage,
        "InstallAddonsPermission": .dictInstallAddonsPermission,
        "PDFjs": .dictPDFjs,
        "Permissions": .dictPermissions,
        "PictureInPicture": .dictPictureInPicture,
        "PopupBlocking": .dictPopupBlocking,
        "Preferences": .dictPreferences,
        "Proxy": .dictProxy,
        "SanitizeOnShutdown": .dictSanitizeOnShutdown,
        "SearchEngines": .dictSearchEngines,
        "SecurityDevices": .dictSecurityDevices,
        "SupportMenu": .dictSupportMenu,
        "UserMessaging": .dictUserMessaging,
        "WebsiteFilter": .dictWebsiteFilter,

    ]

    static func structureType(for policyName: String) -> DictionaryStructureType {
        return structureTypes[policyName] ?? .complexNested
    }
}
