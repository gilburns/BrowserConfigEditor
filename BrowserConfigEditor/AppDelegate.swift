//
//  AppDelegate.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 10/5/25.
//

import Cocoa
import Sparkle
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuItemValidation {


    let updaterController: SPUStandardUpdaterController
    var checkForUpdatesMenuItem: NSMenuItem!
    var settingsMenuItem: NSMenuItem!
    var settingsWindowController: NSWindowController?

    override init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupMenu()

    }

    private func setupMenu() {
        let mainMenu = NSMenu()

        // App Menu (BrowserConfigEditor)
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        appMenu.addItem(NSMenuItem(title: "About BrowserConfigEditor", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
        appMenu.addItem(NSMenuItem.separator())

        // Settings window
        settingsMenuItem = NSMenuItem(title: "Settings…", action: #selector(openSettings), keyEquivalent: ",")
        appMenu.addItem(settingsMenuItem)

        checkForUpdatesMenuItem = NSMenuItem(title: "Check for Updates…", action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)), keyEquivalent: "")
        checkForUpdatesMenuItem.target = updaterController
        appMenu.addItem(checkForUpdatesMenuItem)

        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Hide BrowserConfigEditor", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"))
        let hideOthersItem = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthersItem.keyEquivalentModifierMask = [.command, .option]
        appMenu.addItem(hideOthersItem)
        appMenu.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""))
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Quit BrowserConfigEditor", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        // File Menu
        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu

        let selectBrowserItem = NSMenuItem(title: "Select Browser…", action: #selector(handleSelectBrowser(_:)), keyEquivalent: "o")
        fileMenu.addItem(selectBrowserItem)
        fileMenu.addItem(NSMenuItem.separator())

        let importItem = NSMenuItem(title: "Import Configuration…", action: #selector(handleImport(_:)), keyEquivalent: "i")
        fileMenu.addItem(importItem)

        let exportItem = NSMenuItem(title: "Export Configuration…", action: #selector(handleExport(_:)), keyEquivalent: "e")
        fileMenu.addItem(exportItem)

        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(NSMenuItem(title: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"))

        // Edit Menu
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu

        editMenu.addItem(NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"))
        editMenu.addItem(NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"))
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))

        // Window Menu
        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        NSApp.windowsMenu = windowMenu

        windowMenu.addItem(NSMenuItem(title: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m"))
        windowMenu.addItem(NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""))
        windowMenu.addItem(NSMenuItem.separator())
        windowMenu.addItem(NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: ""))

        // Help Menu
        let helpMenuItem = NSMenuItem()
        mainMenu.addItem(helpMenuItem)
        let helpMenu = NSMenu(title: "Help")
        helpMenuItem.submenu = helpMenu
        NSApp.helpMenu = helpMenu

        let helpWikiItem = NSMenuItem(title: "BrowserConfigEditor Wiki", action: #selector(openHelpWiki(_:)), keyEquivalent: "?")
        helpMenu.addItem(helpWikiItem)
        
        let helpIssueItem = NSMenuItem(title: "BrowserConfigEditor Issues", action: #selector(openHelpIssues(_:)), keyEquivalent: "")
        helpMenu.addItem(helpIssueItem)

        helpMenu.addItem(NSMenuItem.separator())

        let helpChromeDocs = NSMenuItem(title: "Chrome Enterprise policy list", action: #selector(openChromeDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(helpChromeDocs)
        
        let helpEdgeDocs = NSMenuItem(title: "Microsoft Edge - Policies", action: #selector(openEdgeDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(helpEdgeDocs)

        let helpFirefoxDocs = NSMenuItem(title: "Firefox policy templates", action: #selector(openFirefoxDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(helpFirefoxDocs)

        helpMenu.addItem(NSMenuItem.separator())

        let helpBraveDocs = NSMenuItem(title: "Brave Group Policy", action: #selector(openBraveDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(helpBraveDocs)

        let helpEcosiaDocs = NSMenuItem(title: "Ecosia Technical guides for IT", action: #selector(openEcosiaDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(helpEcosiaDocs)

        NSApp.mainMenu = mainMenu
    }

    @objc private func handleSelectBrowser(_ sender: Any) {
        // Get the main window's content view controller
        if let window = NSApp.mainWindow,
           let viewController = window.contentViewController as? ViewController {
            viewController.triggerSelectBrowser()
        }
    }

    @objc private func handleImport(_ sender: Any) {
        if let window = NSApp.mainWindow,
           let viewController = window.contentViewController as? ViewController {
            viewController.triggerImport()
        }
    }

    @objc private func handleExport(_ sender: Any) {
        if let window = NSApp.mainWindow,
           let viewController = window.contentViewController as? ViewController {
            viewController.triggerExport()
        }
    }

    @objc private func openHelpWiki(_ sender: Any) {
        if let url = URL(string: "https://github.com/gilburns/BrowserConfigEditor/wiki") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openHelpIssues(_ sender: Any) {
        if let url = URL(string: "https://github.com/gilburns/BrowserConfigEditor/issues") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openChromeDocs(_ sender: Any) {
        if let url = URL(string: "https://chromeenterprise.google/policies/") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openEdgeDocs(_ sender: Any) {
        if let url = URL(string: "https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openFirefoxDocs(_ sender: Any) {
        if let url = URL(string: "https://mozilla.github.io/policy-templates/") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openBraveDocs(_ sender: Any) {
        if let url = URL(string: "https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openEcosiaDocs(_ sender: Any) {
        if let url = URL(string: "https://support.ecosia.org/article/557-technical-guides-for-it") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc func openSettings() {
        // If settings window already exists, just bring it to front
        if let existingWindow = settingsWindowController?.window {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // Create the SwiftUI view with the updater
        let settingsView = UpdaterSettingsView(updater: updaterController.updater)

        // Wrap it in an NSHostingController
        let hostingController = NSHostingController(rootView: settingsView)

        // Create the window
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Settings"
        window.styleMask = [.titled, .closable]
        window.setContentSize(NSSize(width: 400, height: 150))
        window.center()

        // Create window controller
        let windowController = NSWindowController(window: window)
        settingsWindowController = windowController

        // Show the window
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        // Get the main window's content view controller
        guard let window = NSApp.mainWindow,
              let viewController = window.contentViewController as? ViewController else {
            return false
        }

        // Check which menu item is being validated
        if menuItem.action == #selector(handleImport(_:)) {
            return viewController.canImport()
        } else if menuItem.action == #selector(handleExport(_:)) {
            return viewController.canExport()
        }

        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Check if there are unsaved configured policies
        guard let window = NSApp.mainWindow,
              let viewController = window.contentViewController as? ViewController else {
            return .terminateNow
        }

        // If no configured policies, quit immediately
        if viewController.configurationModel.configuredPolicies.isEmpty {
            return .terminateNow
        }

        // Show warning dialog
        let alert = NSAlert()
        alert.messageText = "Quit BrowserConfigEditor?"
        alert.informativeText = "You have \(viewController.configurationModel.configuredPolicies.count) configured policy(ies) that may not have been exported.\n\nAre you sure you want to quit?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Quit")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        return response == .alertFirstButtonReturn ? .terminateNow : .terminateCancel
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

