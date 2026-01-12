//
//  FormatPopupHandler.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// Helper class to handle format popup changes in save panel
class FormatPopupHandler: NSObject {
    weak var savePanel: NSSavePanel?
    weak var popup: NSPopUpButton?
    let defaultName: String

    init(savePanel: NSSavePanel, popup: NSPopUpButton, defaultName: String) {
        self.savePanel = savePanel
        self.popup = popup
        self.defaultName = defaultName
    }

    @objc func formatChanged(_ sender: NSPopUpButton) {
        guard let savePanel = savePanel else { return }

        let format: ExportFormat
        switch sender.indexOfSelectedItem {
        case 0: format = .plist
        case 1: format = .json
        case 2: format = .intune
        case 3: format = .shellScript
        default: format = .plist
        }

        // Get the current filename and strip any extension
        var filename = savePanel.nameFieldStringValue
        // Remove all extensions (.plist, .json, .xml, .sh, etc.)
        while let dotIndex = filename.lastIndex(of: ".") {
            let possibleExt = String(filename[filename.index(after: dotIndex)...])
            if possibleExt == "plist" || possibleExt == "json" || possibleExt == "xml" || possibleExt == "sh" {
                filename = String(filename[..<dotIndex])
            } else {
                break
            }
        }

        // If filename is empty, use the default
        if filename.isEmpty {
            filename = defaultName
        }

        // Set the filename with the new extension
        savePanel.nameFieldStringValue = "\(filename).\(format.fileExtension)"
    }
}

