//
//  ViewController+NSWindowDelegate.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 1/19/26.
//

import Cocoa

extension ViewController: NSWindowDelegate {

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // If no configured policies, close immediately
        if configurationModel.configuredPolicies.isEmpty {
            return true
        }

        // Show warning dialog
        let alert = NSAlert()
        alert.messageText = "Quit BrowserConfigEditor?"
        alert.informativeText = "You have \(configurationModel.configuredPolicies.count) configured policy(ies) that may not have been exported.\n\nAre you sure you want to quit?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Quit")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        return response == .alertFirstButtonReturn
    }
}
