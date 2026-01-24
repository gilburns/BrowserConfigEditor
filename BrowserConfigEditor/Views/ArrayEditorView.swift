//
//  ArrayEditorView.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 12/27/25.
//

import Cocoa

// Array editor view with table-based interface
class ArrayEditorView: NSView, NSTableViewDataSource, NSTableViewDelegate {
    private let tableView = NSTableView()
    private let scrollView = NSScrollView()
    private let addButton = NSButton()
    private let removeButton = NSButton()
    private var items: [Any] = []
    private let itemType: PolicyType
    private let rangeList: [Any]?

    init(frame: CGRect, itemType: PolicyType, rangeList: [Any]?, initialValue: [Any]?) {
        self.itemType = itemType
        self.rangeList = rangeList
        super.init(frame: frame)

        if let initialValue = initialValue {
            self.items = initialValue
        }

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Table view setup
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("value"))
        column.title = "Array Values (\(itemType)s)"
        column.width = 350
        tableView.addTableColumn(column)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAutomaticRowHeights = false
        tableView.rowHeight = 24

        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .bezelBorder
        scrollView.frame = NSRect(x: 0, y: 30, width: 550, height: 120)
        addSubview(scrollView)

        // Add button
        addButton.title = "+"
        addButton.bezelStyle = .rounded
        addButton.frame = NSRect(x: 0, y: 0, width: 28, height: 25)
        addButton.target = self
        addButton.action = #selector(addItem)
        addSubview(addButton)

        // Remove button
        removeButton.title = "-"
        removeButton.bezelStyle = .rounded
        removeButton.frame = NSRect(x: 30, y: 0, width: 28, height: 25)
        removeButton.target = self
        removeButton.action = #selector(removeItem)
        addSubview(removeButton)
    }

    @objc private func addItem() {
        // Add a default value based on type
        let defaultValue: Any
        switch itemType {
        case .boolean:
            defaultValue = false
        case .integer:
            if let rangeList = rangeList, let first = rangeList.first {
                defaultValue = first
            } else {
                defaultValue = 0
            }
        case .string:
            defaultValue = ""
        default:
            defaultValue = ""
        }

        items.append(defaultValue)
        tableView.reloadData()

        // Select and begin editing the new row
        let newRow = items.count - 1
        tableView.selectRowIndexes(IndexSet(integer: newRow), byExtendingSelection: false)
        tableView.scrollRowToVisible(newRow)
    }

    @objc private func removeItem() {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0 && selectedRow < items.count else { return }

        items.remove(at: selectedRow)
        tableView.reloadData()
    }

    func getItems() -> [Any] {
        return items
    }

    // MARK: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    // MARK: - NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = NSTableCellView()

        let item = items[row]

        // Create appropriate editor based on type
        switch itemType {
        case .boolean:
            let checkbox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
            checkbox.state = (item as? Bool ?? false) ? .on : .off
            checkbox.tag = row
            checkbox.target = self
            checkbox.action = #selector(checkboxChanged(_:))
            cellView.addSubview(checkbox)
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                checkbox.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
                checkbox.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
            ])

        case .integer:
            if let rangeList = rangeList, !rangeList.isEmpty {
                let popup = NSPopUpButton(frame: .zero, pullsDown: false)
                for value in rangeList {
                    popup.addItem(withTitle: "\(value)")
                }
                popup.selectItem(withTitle: "\(item)")
                popup.tag = row
                popup.target = self
                popup.action = #selector(popupChanged(_:))
                cellView.addSubview(popup)
                popup.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    popup.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
                    popup.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -4),
                    popup.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
                ])
            } else {
                let textField = NSTextField()
                textField.stringValue = "\(item)"
                textField.tag = row
                textField.target = self
                textField.action = #selector(textFieldChanged(_:))
                cellView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
                    textField.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -4),
                    textField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
                ])
            }

        case .string:
            let textField = NSTextField()
            textField.stringValue = item as? String ?? ""
            textField.tag = row
            textField.target = self
            textField.action = #selector(textFieldChanged(_:))
            cellView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
                textField.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -4),
                textField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
            ])

        default:
            let textField = NSTextField()
            textField.stringValue = "\(item)"
            textField.tag = row
            textField.target = self
            textField.action = #selector(textFieldChanged(_:))
            cellView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
                textField.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -4),
                textField.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
            ])
        }

        return cellView
    }

    @objc private func checkboxChanged(_ sender: NSButton) {
        let row = sender.tag
        guard row >= 0 && row < items.count else { return }
        items[row] = sender.state == .on
    }

    @objc private func popupChanged(_ sender: NSPopUpButton) {
        let row = sender.tag
        guard row >= 0 && row < items.count else { return }
        if let value = Int(sender.titleOfSelectedItem ?? "0") {
            items[row] = value
        }
    }

    @objc private func textFieldChanged(_ sender: NSTextField) {
        let row = sender.tag
        guard row >= 0 && row < items.count else { return }

        switch itemType {
        case .integer:
            if let value = Int(sender.stringValue) {
                items[row] = value
            }
        case .string:
            items[row] = sender.stringValue
        default:
            items[row] = sender.stringValue
        }
    }
}
