//
//  ViewController.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 10/5/25.
//
//  Main view controller for the browser configuration editor
//

import Cocoa
import UniformTypeIdentifiers

class ViewController: NSViewController {

    // Simple hyperlink-style label that shows a pointing hand cursor on hover
    final class HyperlinkTextField: NSTextField {
        override func resetCursorRects() {
            super.resetCursorRects()
            addCursorRect(bounds, cursor: .pointingHand)
        }
    }

    // MARK: - Properties
    var configurationModel = ConfigurationModel()
    var currentManifest: ManifestModel?
    var filteredPolicies: [PolicyModel] = []
    private var currentDocumentationURL: URL?

    // Known Chromium browser bundle identifiers
    private let knownBrowserBundleIDs = [
        "com.google.Chrome",
        "com.microsoft.edgemac",
        "org.mozilla.firefox",
        "com.apple.Safari",
        "com.avast.browser",
        "com.brave.Browser",
        "ai.perplexity.comet",
        "org.ecosia.browser",
        "com.hiddenreflex.Epic",
        "com.naver.Whale",
        "com.operasoftware.Opera",
        "com.tencent.qqbrowserappmac",
        "org.uc.UC",
        "com.vivaldi.Vivaldi"
    ]

    // Browser information for selector dialog
    private struct BrowserInfo {
        let bundleID: String
        let name: String
        let url: URL
        let icon: NSImage
    }

    // MARK: - UI Components
    private let splitView = NSSplitView()
    private let toolbar = NSView()
    private let browserButton = NSButton()
    private let browserIconView = NSButton()
    private let browserLabel = NSTextField()
    private let searchField = NSSearchField()
    private let policyCountLabel = NSTextField()

    // Left panel - Available policies
    let policiesScrollView = NSScrollView()
    let policiesTableView = NSTableView()

    // Right panel - Configured policies and editor
    private let configuredScrollView = NSScrollView()
    let configuredTableView = NSTableView()  // Internal for delegate access
    private let addButton = NSButton()
    private let removeButton = NSButton()
    private let exportButton = NSButton()
    private let importButton = NSButton()

    // MARK: - Lifecycle
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 1200, height: 800))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Toolbar
        toolbar.wantsLayer = true
        toolbar.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        view.addSubview(toolbar)

        // Browser selection button
        browserButton.title = "Select Browser..."
        browserButton.bezelStyle = .rounded
        browserButton.target = self
        browserButton.action = #selector(selectBrowser)
        toolbar.addSubview(browserButton)

        // Browser icon
        browserIconView.imageScaling = .scaleProportionallyUpOrDown
        browserIconView.isHidden = true
        browserIconView.bezelStyle = .automatic
        browserIconView.isBordered = false
        toolbar.addSubview(browserIconView)

        // Browser label
        browserLabel.isEditable = false
        browserLabel.isBordered = false
        browserLabel.backgroundColor = .clear
        browserLabel.stringValue = "No browser selected"
        browserLabel.font = NSFont.systemFont(ofSize: 13)
        toolbar.addSubview(browserLabel)

        // Search field
        searchField.placeholderString = "Search available policies..."
        searchField.target = self
        searchField.action = #selector(searchPolicies)
        toolbar.addSubview(searchField)

        // Policy count label
        policyCountLabel.isEditable = false
        policyCountLabel.isBordered = false
        policyCountLabel.backgroundColor = .clear
        policyCountLabel.stringValue = ""
        policyCountLabel.font = NSFont.systemFont(ofSize: 11)
        policyCountLabel.textColor = .secondaryLabelColor
        policyCountLabel.alignment = .right
        toolbar.addSubview(policyCountLabel)

        // Split view
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self
        view.addSubview(splitView)

        // Setup left panel (available policies)
        setupPoliciesPanel()

        // Setup right panel (configured policies)
        setupConfiguredPanel()
        
        // Set Window name
        if let window = view.window {
            window.title = "BrowserConfigEditor"
            window.isMovableByWindowBackground = true
        }
    }

    private func setupPoliciesPanel() {
        let containerView = NSView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = .clear
        label.stringValue = "Available Policies"
        label.font = NSFont.boldSystemFont(ofSize: 14)
        containerView.addSubview(label)

        // Setup table view
        let nameColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        nameColumn.title = "Policy Name"
        nameColumn.width = 300

        let typeColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("type"))
        typeColumn.title = "Type"
        typeColumn.width = 80

        let titleColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("title"))
        titleColumn.title = "Description"
        titleColumn.width = 300

        policiesTableView.addTableColumn(nameColumn)
        policiesTableView.addTableColumn(typeColumn)
        policiesTableView.addTableColumn(titleColumn)
        policiesTableView.dataSource = self
        policiesTableView.delegate = self
        policiesTableView.target = self
        policiesTableView.doubleAction = #selector(addPolicyToConfiguration)
        policiesTableView.usesAutomaticRowHeights = true
        policiesTableView.rowHeight = 40  // Default minimum height
        policiesTableView.intercellSpacing = NSSize(width: 3, height: 8)

        policiesScrollView.documentView = policiesTableView
        policiesScrollView.hasVerticalScroller = true
        containerView.addSubview(policiesScrollView)

        // Add button to add policy
        addButton.title = "Add >"
        addButton.bezelStyle = .rounded
        addButton.target = self
        addButton.action = #selector(addPolicyToConfiguration)
        addButton.isEnabled = false  // Initially disabled until a policy is selected
        containerView.addSubview(addButton)

        // Layout
        label.translatesAutoresizingMaskIntoConstraints = false
        policiesScrollView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),

            policiesScrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            policiesScrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            policiesScrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            policiesScrollView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),

            addButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 80)
        ])

        splitView.addArrangedSubview(containerView)
    }

    private func setupConfiguredPanel() {
        let containerView = NSView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = .clear
        label.stringValue = "Configured Policies"
        label.font = NSFont.boldSystemFont(ofSize: 14)
        containerView.addSubview(label)

        // Setup table view
        let nameColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("configName"))
        nameColumn.title = "Policy Name"
        nameColumn.width = 250

        let valueColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("value"))
        valueColumn.title = "Value"
        valueColumn.width = 125

        configuredTableView.addTableColumn(nameColumn)
        configuredTableView.addTableColumn(valueColumn)
        configuredTableView.dataSource = self
        configuredTableView.delegate = self
        configuredTableView.target = self
        configuredTableView.doubleAction = #selector(editConfiguredPolicy)
        configuredTableView.usesAutomaticRowHeights = true
        configuredTableView.rowHeight = 40  // Default minimum height
        configuredTableView.intercellSpacing = NSSize(width: 3, height: 8)

        configuredScrollView.documentView = configuredTableView
        configuredScrollView.hasVerticalScroller = true
        containerView.addSubview(configuredScrollView)

        // Buttons
        removeButton.title = "Remove"
        removeButton.bezelStyle = .rounded
        removeButton.target = self
        removeButton.action = #selector(removePolicy)
        containerView.addSubview(removeButton)

        importButton.title = "Import..."
        importButton.bezelStyle = .rounded
        importButton.target = self
        importButton.action = #selector(importConfiguration)
        containerView.addSubview(importButton)

        exportButton.title = "Export..."
        exportButton.bezelStyle = .rounded
        exportButton.target = self
        exportButton.action = #selector(exportConfiguration)
        containerView.addSubview(exportButton)

        // Initially disable buttons until appropriate
        removeButton.isEnabled = false
        importButton.isEnabled = false
        exportButton.isEnabled = false

        // Layout
        label.translatesAutoresizingMaskIntoConstraints = false
        configuredScrollView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.translatesAutoresizingMaskIntoConstraints = false
        exportButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),

            configuredScrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            configuredScrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            configuredScrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            configuredScrollView.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -10),

            removeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            removeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 100),

            importButton.leadingAnchor.constraint(equalTo: removeButton.trailingAnchor, constant: 10),
            importButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            importButton.widthAnchor.constraint(equalToConstant: 100),

            exportButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            exportButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            exportButton.widthAnchor.constraint(equalToConstant: 100)
        ])

        splitView.addArrangedSubview(containerView)
    }

    private func setupConstraints() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        browserButton.translatesAutoresizingMaskIntoConstraints = false
        browserIconView.translatesAutoresizingMaskIntoConstraints = false
        browserLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        policyCountLabel.translatesAutoresizingMaskIntoConstraints = false
        splitView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 60),

            browserButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 20),
            browserButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            browserIconView.leadingAnchor.constraint(equalTo: browserButton.trailingAnchor, constant: 10),
            browserIconView.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            browserIconView.widthAnchor.constraint(equalToConstant: 32),
            browserIconView.heightAnchor.constraint(equalToConstant: 32),

            browserLabel.leadingAnchor.constraint(equalTo: browserIconView.trailingAnchor, constant: 8),
            browserLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            browserLabel.widthAnchor.constraint(equalToConstant: 350),

            searchField.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -20),
            searchField.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            searchField.widthAnchor.constraint(equalToConstant: 250),

            policyCountLabel.trailingAnchor.constraint(equalTo: searchField.leadingAnchor, constant: -10),
            policyCountLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            policyCountLabel.widthAnchor.constraint(equalToConstant: 80),

            splitView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            splitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splitView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

    override func viewDidAppear() {
        super.viewDidAppear()
        // Set initial divider position after view has been laid out
        splitView.setPosition(800, ofDividerAt: 0)

        // Set self as window delegate for close confirmation
        view.window?.delegate = self
    }

    // MARK: - Actions

    // Public methods to trigger actions from menu
    func triggerSelectBrowser() {
        selectBrowser()
    }

    func triggerImport() {
        importConfiguration()
    }

    func triggerExport() {
        exportConfiguration()
    }

    // Public methods for menu validation
    func canImport() -> Bool {
        return currentManifest != nil
    }

    func canExport() -> Bool {
        return !configurationModel.configuredPolicies.isEmpty
    }

    @objc private func selectBrowser() {
        let browsers = findInstalledBrowsers()

        if browsers.isEmpty {
            // No known browsers found, go straight to file picker
            showBrowserFilePicker()
            return
        }

        // Create alert with popup of browsers
        let alert = NSAlert()
        alert.messageText = "Select Browser"
        alert.informativeText = "Choose one of the detected web browsers below, or browse for another application."
        alert.alertStyle = .informational

        // Create popup button with browsers
        let popup = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 350, height: 25))
        for browser in browsers {
            popup.addItem(withTitle: browser.name)
            if let item = popup.lastItem {
                item.image = browser.icon
                item.image?.size = NSSize(width: 16, height: 16)
                // browser.url is already a URL; use its absoluteString for the tooltip
                item.toolTip = browser.url
                    .standardizedFileURL
                    .path
            }
        }
        
        popup.selectItem(at: 0)
        alert.accessoryView = popup

        alert.addButton(withTitle: "Select")
        alert.addButton(withTitle: "Other...")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()

        switch response {
        case .alertFirstButtonReturn:  // Select
            let selectedIndex = popup.indexOfSelectedItem
            if selectedIndex >= 0 && selectedIndex < browsers.count {
                loadBrowser(at: browsers[selectedIndex].url)
            }
        case .alertSecondButtonReturn:  // Other...
            showBrowserFilePicker()
        default:  // Cancel
            break
        }
    }

    private func findInstalledBrowsers() -> [BrowserInfo] {
        var browsers: [BrowserInfo] = []

        for bundleID in knownBrowserBundleIDs {
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
                let name = FileManager.default.displayName(atPath: url.path)
                let icon = NSWorkspace.shared.icon(forFile: url.path)
                browsers.append(BrowserInfo(bundleID: bundleID, name: name, url: url, icon: icon))
            }
        }
        
        return browsers
    }

    private func showBrowserFilePicker() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [.applicationBundle]
        openPanel.message = "Select a Chromium-based browser (Chrome, Edge, etc.)"

        openPanel.begin { [weak self] response in
            guard response == .OK, let url = openPanel.url else { return }
            self?.loadBrowser(at: url)
        }
    }

    private func loadBrowser(at url: URL) {
        // Check if there are existing configured policies and we're switching browsers
        if !configurationModel.configuredPolicies.isEmpty && currentManifest != nil {
            let alert = NSAlert()
            alert.messageText = "Clear Configured Policies?"
            alert.informativeText = "You have configured policies for the current browser. The new browser may not support the same policies.\n\nWould you like to clear the existing configuration?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Clear")
            alert.addButton(withTitle: "Keep")
            alert.addButton(withTitle: "Cancel")

            let response = alert.runModal()

            switch response {
            case .alertFirstButtonReturn:  // Clear
                configurationModel.clearAll()
                configuredTableView.reloadData()
            case .alertSecondButtonReturn:  // Keep
                break  // Do nothing, keep existing policies
            default:  // Cancel
                return  // Don't load new browser
            }
        }

        do {
            let manifest: ManifestModel
            // Check if this is Firefox - if so, use bundled manifest
            if let bundle = Bundle(url: url),
               let bundleID = bundle.bundleIdentifier,
               bundleID == "org.mozilla.firefox" {
                // Load Firefox manifest from our app bundle
                manifest = try loadFirefoxManifest(browserURL: url)
            } else {
                // Load manifest from browser bundle (standard Chromium behavior)
                manifest = try ManifestParser.loadManifest(from: url)
            }

            currentManifest = manifest
            configurationModel.manifest = manifest
            // Sort policies alphabetically by name
            filteredPolicies = manifest.policies.sorted { policy1, policy2 in
                return policy1.name.localizedCaseInsensitiveCompare(policy2.name) == .orderedAscending
            }

            // Get the app name from the URL
            let appName = url.lastPathComponent.replacingOccurrences(of: ".app", with: "")

            // Get the app icon
            let standardizedURL = url.standardizedFileURL
            browserIconView.image = NSWorkspace.shared.icon(forFile: standardizedURL.path)
            browserIconView.isHidden = false
            
            // UI hint
            browserIconView.toolTip = standardizedURL.path
            browserIconView.target = self
            browserIconView.action = #selector(revealBrowserInFinder)
            
            // Update label with app name and domain
            browserLabel.stringValue = "\(appName) - \(manifest.domain)"
            browserLabel.toolTip = standardizedURL.path

            // Update policy count
            updatePolicyCount()

            // Update button states now that browser is loaded
            updateButtonStates()

            policiesTableView.reloadData()
            
            // Set Window name and url
            if let window = view.window {
                window.representedURL = url
                window.title = "\(appName)  –  BrowserConfigEditor"
                window.isMovableByWindowBackground = true
            }
            
        } catch {
            showError("Failed to load browser manifest", message: error.localizedDescription)
        }
    }

    private func loadFirefoxManifest(browserURL: URL) throws -> ManifestModel {
        // Firefox manifest is bundled in our app's Resources folder
        guard let resourceURL = Bundle.main.resourceURL else {
            throw ManifestError.manifestNotFound
        }

        // Navigate into the .manifest bundle structure (same as Chromium browsers)
        let manifestPath = resourceURL
            .appendingPathComponent("org.mozilla.firefox.manifest")
            .appendingPathComponent("Contents/Resources")
            .appendingPathComponent("org.mozilla.firefox.manifest")

        guard FileManager.default.fileExists(atPath: manifestPath.path) else {
            throw ManifestError.manifestNotFound
        }

        return try ManifestParser.parseManifest(at: manifestPath, browserPath: browserURL)
    }

    @objc private func searchPolicies() {
        guard let manifest = currentManifest else { return }
        let searchTerm = searchField.stringValue
        filteredPolicies = manifest.filterPolicies(searchTerm: searchTerm)
        updatePolicyCount()
        policiesTableView.reloadData()
    }

    private func updatePolicyCount() {
        guard let manifest = currentManifest else {
            policyCountLabel.stringValue = ""
            return
        }

        let totalCount = manifest.policies.count
        let filteredCount = filteredPolicies.count

        if filteredCount == totalCount {
            // No search active, just show total
            policyCountLabel.stringValue = "\(totalCount) policies"
        } else {
            // Search active, show filtered of total
            policyCountLabel.stringValue = "\(filteredCount) of \(totalCount)"
        }
    }

    func updateButtonStates() {
        // Add button: enabled only when a row is selected in available policies table
        let selectedPolicyRow = policiesTableView.selectedRow
        addButton.isEnabled = selectedPolicyRow >= 0 && selectedPolicyRow < filteredPolicies.count

        // Import button: enabled only when a browser is loaded
        importButton.isEnabled = currentManifest != nil

        // Export button: enabled only when there are configured policies
        exportButton.isEnabled = !configurationModel.configuredPolicies.isEmpty

        // Remove button: enabled only when a row is selected in configured table
        let selectedConfiguredRow = configuredTableView.selectedRow
        removeButton.isEnabled = selectedConfiguredRow >= 0 && selectedConfiguredRow < configurationModel.configuredPolicies.count
    }

    @objc private func addPolicyToConfiguration() {
        let selectedRow = policiesTableView.selectedRow
        guard selectedRow >= 0, selectedRow < filteredPolicies.count else { return }

        let policy = filteredPolicies[selectedRow]
        showValueEditor(for: policy)
    }

    @objc private func editConfiguredPolicy() {
        let selectedRow = configuredTableView.selectedRow
        guard selectedRow >= 0 else { return }

        let policyNames = Array(configurationModel.configuredPolicies.keys).sorted()
        guard selectedRow < policyNames.count else { return }

        let policyName = policyNames[selectedRow]

        // Look up the full policy definition from the manifest
        guard let manifest = currentManifest,
              let policy = manifest.policy(named: policyName) else {
            return
        }

        // Show the value editor with the existing policy
        showValueEditor(for: policy)
    }

    @objc private func removePolicy() {
        let selectedRow = configuredTableView.selectedRow
        guard selectedRow >= 0 else { return }

        let policyNames = Array(configurationModel.configuredPolicies.keys).sorted()
        guard selectedRow < policyNames.count else { return }

        let policyName = policyNames[selectedRow]

        // Show confirmation dialog
        let alert = NSAlert()
        alert.messageText = "Remove Policy?"
        alert.informativeText = "Are you sure you want to remove the policy '\(policyName)'? This action cannot be undone."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Remove")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            configurationModel.removePolicy(name: policyName)
            configuredTableView.reloadData()
            updateButtonStates()
        }
    }

    @MainActor
    @objc private func exportConfiguration() {
        precondition(Thread.isMainThread)

        // Ensure we're frontmost before showing a panel.
        NSApp.activate(ignoringOtherApps: true)

        // Defer panel creation/presentation to the next runloop iteration.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let savePanel = NSSavePanel()

            // Create format selector accessory view
            let accessoryView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 30))

            let label = NSTextField(labelWithString: "Format:")
            label.frame = NSRect(x: 0, y: 5, width: 60, height: 20)
            accessoryView.addSubview(label)

            let formatPopup = NSPopUpButton(frame: NSRect(x: 65, y: 0, width: 135, height: 26), pullsDown: false)
            formatPopup.addItem(withTitle: "Property List (.plist)")
            formatPopup.lastItem?.toolTip = ExportFormat.plist.displayDescription
            formatPopup.addItem(withTitle: "JSON (.json)")
            formatPopup.lastItem?.toolTip = ExportFormat.json.displayDescription
            formatPopup.addItem(withTitle: "Intune XML (.xml)")
            formatPopup.lastItem?.toolTip = ExportFormat.intune.displayDescription
            formatPopup.addItem(withTitle: "Shell Script (.sh)")
            formatPopup.lastItem?.toolTip = ExportFormat.shellScript.displayDescription
            accessoryView.addSubview(formatPopup)

            savePanel.accessoryView = accessoryView

            // Allow plist, json, xml, and shell script content types
            var allowedTypes: [UTType] = [.json, .xml]
            if let plistType = UTType(filenameExtension: "plist") {
                allowedTypes.append(plistType)
            }
            if let shellType = UTType(filenameExtension: "sh") {
                allowedTypes.append(shellType)
            }
            savePanel.allowedContentTypes = allowedTypes
            savePanel.nameFieldStringValue = "\(self.currentManifest?.domain ?? "browser").plist"

            // Set up format change handler using a custom class to maintain reference to save panel
            let handler = FormatPopupHandler(savePanel: savePanel, popup: formatPopup, defaultName: self.currentManifest?.domain ?? "browser")
            formatPopup.target = handler
            formatPopup.action = #selector(FormatPopupHandler.formatChanged(_:))

            // Keep the handler alive by storing it as an associated object
            objc_setAssociatedObject(formatPopup, "handler", handler, .OBJC_ASSOCIATION_RETAIN)

            if let window = self.view.window {
                savePanel.beginSheetModal(for: window) { [weak self] response in
                    guard response == .OK, let url = savePanel.url else { return }
                    let format: ExportFormat
                    switch formatPopup.indexOfSelectedItem {
                    case 0: format = .plist
                    case 1: format = .json
                    case 2: format = .intune
                    case 3: format = .shellScript
                    default: format = .plist
                    }
                    self?.exportToFile(url: url, format: format)
                }
            } else {
                savePanel.begin { [weak self] response in
                    guard response == .OK, let url = savePanel.url else { return }
                    let format: ExportFormat
                    switch formatPopup.indexOfSelectedItem {
                    case 0: format = .plist
                    case 1: format = .json
                    case 2: format = .intune
                    case 3: format = .shellScript
                    default: format = .plist
                    }
                    self?.exportToFile(url: url, format: format)
                }
            }
        }
    }

    @MainActor
    private func exportToFile(url: URL, format: ExportFormat) {
        do {
            switch format {
            case .plist:
                try configurationModel.exportToPlist(url: url)
            case .json:
                try configurationModel.exportToJSON(url: url)
            case .intune:
                try configurationModel.exportToIntune(url: url)
            case .shellScript:
                try configurationModel.exportToShellScript(url: url)
            }
            showExportSuccess(for: url)
        } catch {
            showError("Export Failed", message: error.localizedDescription)
        }
    }

    private func showExportSuccess(for url: URL) {
        let alert = NSAlert()
        alert.messageText = "Success"
        alert.informativeText = "Configuration exported successfully to \(url.lastPathComponent)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Show in Finder")

        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }

    @objc private func importConfiguration() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true

        // Allow both plist and json file types
        var allowedTypes: [UTType] = [.json]
        if let plistType = UTType(filenameExtension: "plist") {
            allowedTypes.append(plistType)
        }
        openPanel.allowedContentTypes = allowedTypes
        openPanel.message = "Select a configuration file to import (plist or json)"

        openPanel.begin { [weak self] response in
            guard response == .OK, let url = openPanel.url else { return }
            self?.importFromFile(url: url)
        }
    }

    private func importFromFile(url: URL) {
        // Check if there are existing configured policies
        let hasExistingPolicies = !configurationModel.configuredPolicies.isEmpty

        if hasExistingPolicies {
            // Show dialog asking whether to clear or merge
            let alert = NSAlert()
            alert.messageText = "Import Options"
            alert.informativeText = "You have \(configurationModel.configuredPolicies.count) configured policy(ies). How would you like to import the new configuration?"
            alert.alertStyle = .informational

            alert.addButton(withTitle: "Replace All")
            alert.buttons.last?.toolTip = "Remove all existing policies and import new ones"

            alert.addButton(withTitle: "Merge")
            alert.buttons.last?.toolTip = "Keep existing policies and add/update with imported ones"

            alert.addButton(withTitle: "Cancel")

            let response = alert.runModal()

            switch response {
            case .alertFirstButtonReturn: // Replace All
                performImport(url: url, clearExisting: true)
            case .alertSecondButtonReturn: // Merge
                performImport(url: url, clearExisting: false)
            default: // Cancel
                return
            }
        } else {
            // No existing policies, just import
            performImport(url: url, clearExisting: true)
        }
    }

    private func performImport(url: URL, clearExisting: Bool) {
        do {
            // Detect file type by extension
            let fileExtension = url.pathExtension.lowercased()

            switch fileExtension {
            case "json":
                try configurationModel.importFromJSON(url: url, clearExisting: clearExisting)
            case "plist":
                try configurationModel.importFromPlist(url: url, clearExisting: clearExisting)
            default:
                throw NSError(domain: "ViewController", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported file type. Please select a .plist or .json file."])
            }

            configuredTableView.reloadData()
            updateButtonStates()

            let action = clearExisting ? "imported" : "merged"
            showSuccess("Configuration \(action) successfully")
        } catch {
            showError("Import Failed", message: error.localizedDescription)
        }
    }

    private func showValueEditor(for policy: PolicyModel) {
        let alert = NSAlert()
        alert.messageText = "Policy Key:"
        alert.informativeText = "\(policy.name)"
        alert.alertStyle = .informational

        // Create container for accessory view with description and input
        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 440, height: 0))
        var components: [(view: NSView, height: CGFloat)] = []

        // Policy documentation hyperlink
        if let docURL = createDocumentationURL(for: policy.name) {
            currentDocumentationURL = docURL

            let docLinkField = HyperlinkTextField(labelWithString: docURL.absoluteString)
            docLinkField.font = NSFont.systemFont(ofSize: 13)
            docLinkField.textColor = NSColor.linkColor
            docLinkField.isSelectable = true
            docLinkField.allowsEditingTextAttributes = true
            docLinkField.maximumNumberOfLines = 1
            docLinkField.lineBreakMode = .byTruncatingTail
            docLinkField.usesSingleLineMode = true

            // Make it look like a hyperlink
            let attributed = NSMutableAttributedString(string: docURL.absoluteString)
            attributed.addAttributes([
                .foregroundColor: NSColor.linkColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: NSRange(location: 0, length: attributed.length))
            docLinkField.attributedStringValue = attributed

            // Full URL on hover
            docLinkField.toolTip = docURL.absoluteString

            // Click to open
            let click = NSClickGestureRecognizer(target: self, action: #selector(openDocumentationURLText(_:)))
            docLinkField.addGestureRecognizer(click)
            docLinkField.isEnabled = true
            components.append((docLinkField, 18))

            let docLabel = NSTextField(labelWithString: "Policy Documentation:")
            docLabel.font = NSFont.boldSystemFont(ofSize: 11)
            components.append((docLabel, 16))
        } else {
            let urlText = NSTextField(labelWithString: "The vendor does not provide additional documentation for this policy.")
            components.append((urlText, 18))


            let docLabel = NSTextField(labelWithString: "Policy Documentation:")
            docLabel.font = NSFont.boldSystemFont(ofSize: 11)
            components.append((docLabel, 16))

        }

        // Add spacing between sections if there's a description
        if let description = policy.description, !description.isEmpty {
            let spacer = NSView()
            components.append((spacer, 10))

            // Unescape the description string
            let unescapedDescription = unescapeString(description)

            let descriptionText = NSTextView(frame: NSRect(x: 0, y: 0, width: 440, height: 100))
            descriptionText.isEditable = false
            descriptionText.isSelectable = true
            descriptionText.drawsBackground = false
            descriptionText.font = NSFont.systemFont(ofSize: 11)
            descriptionText.textColor = NSColor.controlTextColor
            descriptionText.string = unescapedDescription
            descriptionText.textContainer?.lineFragmentPadding = 5

            // Add line spacing for better readability
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2  // Extra space between lines
            paragraphStyle.paragraphSpacing = 3  // Extra space between paragraphs

            descriptionText.textStorage?.addAttribute(.paragraphStyle,
                                                       value: paragraphStyle,
                                                       range: NSRange(location: 0, length: descriptionText.string.count))

            let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 440, height: 100))
            scrollView.documentView = descriptionText
            scrollView.hasVerticalScroller = true
            scrollView.borderType = .bezelBorder
            components.append((scrollView, 100))

            let descriptionLabel = NSTextField(labelWithString: "Policy Details:")
            descriptionLabel.font = NSFont.boldSystemFont(ofSize: 11)
            components.append((descriptionLabel, 18))
        }

        let spacer = NSView()
        components.append((spacer, 20))

        // Add value input field first (will be at bottom)
        let inputField = createInputField(for: policy)
        components.append((inputField, inputField.frame.height))

        let inputLabel = NSTextField(labelWithString: "Policy Value:")
        inputLabel.font = NSFont.boldSystemFont(ofSize: 11)
        components.append((inputLabel, 16))
        
        components.append((spacer, 10))

        let inputTitleString = NSTextField(labelWithString: unescapeString(policy.title ?? ""))
        inputTitleString.font = NSFont.systemFont(ofSize: 13)

        // Enable multi-line wrapping for long descriptions
        inputTitleString.maximumNumberOfLines = 0
        inputTitleString.lineBreakMode = .byWordWrapping
        inputTitleString.usesSingleLineMode = false
        inputTitleString.cell?.wraps = true
        inputTitleString.cell?.isScrollable = false
        inputTitleString.textColor = NSColor.controlTextColor

        // Calculate the height needed for the wrapped text (width will be set to 440 during layout)
        let titleText = inputTitleString.stringValue as NSString
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: inputTitleString.font as Any]
        let titleRect = titleText.boundingRect(
            with: NSSize(width: 440, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: titleAttributes
        )
        let titleHeight = ceil(titleRect.height)

        // Add a little padding so the last line isn't clipped
        components.append((inputTitleString, max(20, titleHeight + 4)))
        
        let inputTitle = NSTextField(labelWithString: "Policy Description:")
        inputTitle.font = NSFont.boldSystemFont(ofSize: 11)
        components.append((inputTitle, 16))


        // Layout components from bottom to top
        var yOffset: CGFloat = 0
        for (view, height) in components {
            var frame = view.frame
            frame.origin.x = 0
            frame.origin.y = yOffset
            frame.size.width = 440
            frame.size.height = height
            view.frame = frame
            containerView.addSubview(view)
            yOffset += height + 2
        }

        // Update container height
        containerView.frame.size.height = yOffset + 10

        alert.accessoryView = containerView
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        // For dictionary types, validate JSON before accepting
        var shouldContinue = true
        while shouldContinue {
            let response = alert.runModal()

            if response == .alertFirstButtonReturn {
                // Validate dictionary JSON before proceeding
                if policy.type == .dictionary {
                    if let validationError = validateDictionaryInput(from: inputField) {
                        // Show error and loop again
                        showError("Invalid JSON", message: validationError)
                        continue
                    }
                }

                // Validation passed or not a dictionary, extract and save
                if let value = extractValue(from: inputField, for: policy) {
                    configurationModel.setPolicy(name: policy.name, value: value)
                    configuredTableView.reloadData()
                    updateButtonStates()
                }
                shouldContinue = false
            } else {
                // User cancelled
                shouldContinue = false
            }
        }
    }

    private func validateDictionaryInput(from view: NSView) -> String? {
        // Extract the scroll view containing the text view
        let scrollView = view.subviews.first(where: { $0 is NSScrollView }) as? NSScrollView

        guard let scrollView = scrollView,
              let textView = scrollView.documentView as? NSTextView else {
            return "Unable to access input field"
        }

        let jsonString = textView.string.trimmingCharacters(in: .whitespacesAndNewlines)

        // Empty is allowed (will result in no value being set)
        if jsonString.isEmpty {
            return nil
        }

        // Try to parse as JSON
        guard let jsonData = jsonString.data(using: .utf8) else {
            return "Unable to convert text to data"
        }

        do {
            _ = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return nil  // Valid JSON
        } catch {
            return "Invalid JSON format: \(error.localizedDescription)\n\nPlease check for:\n• Missing or extra commas\n• Unmatched brackets or braces\n• Unquoted property names\n• Trailing commas"
        }
    }

    func unescapeString(_ string: String) -> String {
        // Unescape common escape sequences
        var result = string
        result = result.replacingOccurrences(of: "\\\"", with: "\"")
        result = result.replacingOccurrences(of: "\\'", with: "'")
        result = result.replacingOccurrences(of: "\\\\", with: "\\")
        // Note: \n, \t, etc. are already handled by Swift string literals
        return result
    }

    private func createDocumentationURL(for policyName: String) -> URL? {
        guard let domain = currentManifest?.domain else { return nil }

        if domain == "com.microsoft.edgemac" {
            // Microsoft Edge documentation
            let lowercaseName = policyName.lowercased()
            return URL(string: "https://learn.microsoft.com/en-us/deployedge/microsoft-edge-browser-policies/\(lowercaseName)")
        } else if domain == "org.mozilla.firefox" {
            // Mozilla Firefox documentation
            let lowercaseName = policyName.lowercased()
            return URL(string: "https://mozilla.github.io/policy-templates/#\(lowercaseName)")
        } else if domain == "com.apple.Safari" {
            // Apple Safari documentation
            return URL(string: "")
        } else {
            if policyName.hasPrefix("Brave") || policyName == ("TorDisabled") {
                // Brave specific documentation
                return URL(string: "https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy")
            } else {
                // Google Chrome documentation (used for Chrome and other Chromium browsers)
                return URL(string: "https://chromeenterprise.google/policies/#\(policyName)")
            }
        }
    }

    @objc private func openDocumentationURL(_ sender: NSButton) {
        if let url = currentDocumentationURL {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openDocumentationURLText(_ sender: NSClickGestureRecognizer) {
        guard sender.state == .ended else { return }
        if let url = currentDocumentationURL {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc private func revealBrowserInFinder(_ sender: NSButton) {
        guard
            let path = sender.toolTip,
            !path.isEmpty
        else { return }

        NSWorkspace.shared.activateFileViewerSelecting([
            URL(fileURLWithPath: path)
        ])
    }

    private func createInputField(for policy: PolicyModel) -> NSView {
        switch policy.type {
        case .boolean:
            let checkbox = NSButton(checkboxWithTitle: "Enabled", target: nil, action: nil)
            if let currentValue = configurationModel.value(for: policy.name) as? Bool {
                checkbox.state = currentValue ? .on : .off
            }
            return checkbox

        case .integer:
            if let rangeList = policy.rangeList, !rangeList.isEmpty {
                let popup = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 440, height: 26))
                for value in rangeList {
                    popup.addItem(withTitle: "\(value)")
                }
                // Select current value if it exists
                if let currentValue = configurationModel.value(for: policy.name) as? Int {
                    popup.selectItem(withTitle: "\(currentValue)")
                }
                return popup
            } else {
                let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 440, height: 24))
                textField.isEditable = true
                textField.isSelectable = true
                textField.isBordered = true
                textField.bezelStyle = .roundedBezel
                textField.placeholderString = "Enter integer value"
                if let currentValue = configurationModel.value(for: policy.name) as? Int {
                    textField.stringValue = "\(currentValue)"
                } else {
                    textField.stringValue = ""
                }
                return textField
            }

        case .string:
            if let rangeList = policy.rangeList, !rangeList.isEmpty {
                let popup = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 440, height: 26))
                for value in rangeList {
                    popup.addItem(withTitle: "\(value)")
                }
                // Select current value if it exists
                if let currentValue = configurationModel.value(for: policy.name) as? String {
                    popup.selectItem(withTitle: "\(currentValue)")
                }
                return popup
            } else {
                let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 440, height: 24))
                textField.isEditable = true
                textField.isSelectable = true
                textField.isBordered = true
                textField.bezelStyle = .roundedBezel
                textField.placeholderString = "Enter string value"
                if let currentValue = configurationModel.value(for: policy.name) as? String {
                    textField.stringValue = currentValue
                } else {
                    textField.stringValue = ""
                }
                return textField
            }
        case .array:
            // Determine item type from subkeys schema
            var itemType: PolicyType = .string  // Default to string
            var itemRangeList: [Any]? = nil

            if let subkeys = policy.subkeys, let firstSubkey = subkeys.first {
                itemType = firstSubkey.type
                // Check if the subkey has a range_list (for integer arrays with constrained values)
                // Note: range_list is on the parent policy, not the subkey
                if itemType == .integer {
                    itemRangeList = policy.rangeList
                }
            }

            let currentValue = configurationModel.value(for: policy.name) as? [Any]
            let arrayEditor = ArrayEditorView(
                frame: NSRect(x: 0, y: 0, width: 440, height: 155),
                itemType: itemType,
                rangeList: itemRangeList,
                initialValue: currentValue
            )
            return arrayEditor

        case .dictionary:
            // Lookup structure type for this policy
            let structureType = DictionaryPolicyInfo.structureType(for: policy.name)

            // Create container view with label and editor
            let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 440, height: 140))

            // Add hint label
            let hintLabel = NSTextField(labelWithString: structureType.hint)
            hintLabel.font = NSFont.systemFont(ofSize: 10)
            hintLabel.textColor = .secondaryLabelColor
            hintLabel.frame = NSRect(x: 0, y: 120, width: 440, height: 16)
            containerView.addSubview(hintLabel)

            // Create text editor
            let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 440, height: 100))
            textView.isRichText = false
            textView.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            textView.isEditable = true
            textView.isSelectable = true
            textView.isAutomaticQuoteSubstitutionEnabled = false

            // Try to display current value as JSON
            var didSetValue = false
            if let currentValue = configurationModel.value(for: policy.name) {
                // Handle both dictionaries and arrays (some policies marked as dictionary are actually arrays)
                if let jsonData = try? JSONSerialization.data(withJSONObject: currentValue, options: [.prettyPrinted, .sortedKeys]),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    textView.string = jsonString
                    didSetValue = true
                }
            }

            // If no current value, use template
            if !didSetValue {
                textView.string = structureType.template
            }

            let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 440, height: 100))
            scrollView.documentView = textView
            scrollView.hasVerticalScroller = true
            scrollView.borderType = .bezelBorder
            containerView.addSubview(scrollView)

            return containerView

        default:
            let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 440, height: 24))
            textField.isEditable = true
            textField.isSelectable = true
            textField.isBordered = true
            textField.bezelStyle = .roundedBezel
            textField.placeholderString = "Enter value..."
            return textField
        }
    }

    private func extractValue(from view: NSView, for policy: PolicyModel) -> Any? {
        switch policy.type {
        case .boolean:
            if let checkbox = view as? NSButton {
                return checkbox.state == .on
            }

        case .integer:
            if let popup = view as? NSPopUpButton {
                return Int(popup.titleOfSelectedItem ?? "0") ?? 0
            } else if let textField = view as? NSTextField {
                let trimmedValue = textField.stringValue.trimmingCharacters(in: .whitespaces)
                if trimmedValue.isEmpty {
                    return 0
                }
                return Int(trimmedValue) ?? 0
            }

        case .string:
            if let popup = view as? NSPopUpButton {
                return String(popup.titleOfSelectedItem ?? "")
            } else if let textField = view as? NSTextField {
                return textField.stringValue
            }

        case .array:
            if let arrayEditor = view as? ArrayEditorView {
                return arrayEditor.getItems()
            }

        case .dictionary:
            // The view is now a container with a scroll view inside
            let scrollView = view.subviews.first(where: { $0 is NSScrollView }) as? NSScrollView

            if let scrollView = scrollView,
               let textView = scrollView.documentView as? NSTextView {
                let jsonString = textView.string.trimmingCharacters(in: .whitespacesAndNewlines)

                // If empty, return nil (validation allows this)
                if jsonString.isEmpty {
                    return nil
                }

                // Try to parse as JSON - could be dictionary or array
                // Validation should have caught any errors, but handle gracefully
                if let jsonData = jsonString.data(using: .utf8),
                   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    return jsonObject  // Return as-is, could be dictionary or array
                }

                // Shouldn't reach here due to validation, but return nil as fallback
                return nil
            }

        default:
            break
        }

        return nil
    }

    private func showError(_ title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.runModal()
    }

    private func showSuccess(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Success"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.runModal()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
}
