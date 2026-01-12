//
//  ViewController+NSTableViewDelegate.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier ?? NSUserInterfaceItemIdentifier("")
        var cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView

        if cellView == nil {
            cellView = NSTableCellView()
            cellView?.identifier = identifier

            // Make sure subviews are clipped to the cell bounds so long strings don't paint over adjacent columns.
            cellView?.wantsLayer = true
            cellView?.layer?.masksToBounds = true

            let textField = NSTextField()
            textField.isBordered = false
            textField.backgroundColor = .clear
            textField.isEditable = false
            textField.isSelectable = true

            // Default to single-line truncation; per-column settings below can override if needed.
            textField.usesSingleLineMode = true
            textField.maximumNumberOfLines = 1
            textField.lineBreakMode = .byTruncatingTail
            textField.cell?.wraps = false
            textField.cell?.truncatesLastVisibleLine = true

            // Allow the text field to shrink within the column width.
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

            cellView?.addSubview(textField)
            cellView?.textField = textField

            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cellView!.leadingAnchor, constant: 4),
                textField.trailingAnchor.constraint(equalTo: cellView!.trailingAnchor, constant: -4),
                textField.topAnchor.constraint(equalTo: cellView!.topAnchor, constant: 4),
                textField.bottomAnchor.constraint(equalTo: cellView!.bottomAnchor, constant: -4)
            ])
        }

        // Configure text field properties based on column
        if tableView == policiesTableView {
            let policy = filteredPolicies[row]
            switch identifier.rawValue {
            case "name":
                cellView?.textField?.stringValue = policy.name
                cellView?.textField?.lineBreakMode = .byTruncatingTail
                cellView?.textField?.cell?.wraps = false
                cellView?.textField?.cell?.truncatesLastVisibleLine = true
                cellView?.textField?.maximumNumberOfLines = 1
                cellView?.toolTip = policy.name
            case "type":
                cellView?.textField?.stringValue = policy.type.rawValue
                cellView?.textField?.lineBreakMode = .byClipping
                cellView?.textField?.cell?.wraps = false
                cellView?.textField?.maximumNumberOfLines = 1
            case "title":
                let description = policy.title ?? policy.description ?? ""
                let unescapedDescription = unescapeString(description)
                cellView?.textField?.stringValue = unescapedDescription
                cellView?.textField?.lineBreakMode = .byTruncatingTail
                cellView?.textField?.cell?.wraps = true
                cellView?.textField?.cell?.truncatesLastVisibleLine = true
                cellView?.textField?.maximumNumberOfLines = 2
                cellView?.textField?.usesSingleLineMode = false
                cellView?.toolTip = unescapedDescription
            default:
                break
            }
        } else {
            let policyNames = Array(configurationModel.configuredPolicies.keys).sorted()
            let policyName = policyNames[row]
            let configured = configurationModel.configuredPolicies[policyName]

            switch identifier.rawValue {
            case "configName":
                cellView?.textField?.stringValue = policyName
                cellView?.textField?.lineBreakMode = .byTruncatingTail
                cellView?.textField?.cell?.wraps = false
                cellView?.textField?.cell?.truncatesLastVisibleLine = true
                cellView?.textField?.maximumNumberOfLines = 1
                cellView?.toolTip = policyName
            case "value":
                let valueString = "\(configured?.value ?? "")"
                cellView?.textField?.stringValue = valueString
                cellView?.textField?.lineBreakMode = .byTruncatingTail
                cellView?.textField?.cell?.wraps = true
                cellView?.textField?.cell?.truncatesLastVisibleLine = true
                cellView?.textField?.maximumNumberOfLines = 2
                cellView?.toolTip = valueString
            default:
                break
            }
        }

        return cellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        // Update button states when selection changes in either table
        if let tableView = notification.object as? NSTableView {
            if tableView == policiesTableView || tableView == configuredTableView {
                updateButtonStates()
            }
        }
    }
}
