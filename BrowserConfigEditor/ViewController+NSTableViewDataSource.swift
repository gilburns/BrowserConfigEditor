//
//  ViewController+NSTableViewDataSource.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == policiesTableView {
            return filteredPolicies.count
        } else {
            return configurationModel.configuredPolicies.count
        }
    }
}
