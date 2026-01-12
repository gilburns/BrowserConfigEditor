//
//  PolicyModel.swift
//  BrowserConfigEditor
//
//  Models representing browser policy configuration items
//

import Foundation

enum PolicyType: String {
    case boolean
    case integer
    case string
    case array
    case dictionary
    case data
    case date
    case real
}

enum PolicyTarget: String {
    case userManaged = "user-managed"
    case user = "user"
    case system = "system"
}

// MARK: - Policy Model
struct PolicyModel: Identifiable {
    let id = UUID()
    let name: String
    let type: PolicyType
    let targets: [PolicyTarget]
    let rangeList: [Any]?
    let subkeys: [PolicySubkey]?

    // Localized strings (loaded separately)
    var title: String?
    var description: String?

    init(name: String, type: PolicyType, targets: [PolicyTarget], rangeList: [Any]? = nil, subkeys: [PolicySubkey]? = nil) {
        self.name = name
        self.type = type
        self.targets = targets
        self.rangeList = rangeList
        self.subkeys = subkeys
    }
}

// MARK: - Policy Subkey
struct PolicySubkey {
    let type: PolicyType
    let name: String?
    let subkeys: [PolicySubkey]?

    init(type: PolicyType, name: String? = nil, subkeys: [PolicySubkey]? = nil) {
        self.type = type
        self.name = name
        self.subkeys = subkeys
    }
}

// MARK: - Policy Model Extension
extension PolicyModel {
    // Parse from plist dictionary
    static func from(dict: [String: Any]) -> PolicyModel? {
        guard let name = dict["pfm_name"] as? String,
              let typeString = dict["pfm_type"] as? String,
              let type = PolicyType(rawValue: typeString) else {
            return nil
        }

        var targets: [PolicyTarget] = []
        if let targetStrings = dict["pfm_targets"] as? [String] {
            targets = targetStrings.compactMap { PolicyTarget(rawValue: $0) }
        }

        let rangeList = dict["pfm_range_list"] as? [Any]

        var subkeys: [PolicySubkey]?
        if let subkeysArray = dict["pfm_subkeys"] as? [[String: Any]] {
            subkeys = subkeysArray.compactMap { PolicySubkey.from(dict: $0) }
        }

        var policy = PolicyModel(name: name, type: type, targets: targets, rangeList: rangeList, subkeys: subkeys)

        // Read title and description from manifest (can be overridden by localizations)
        policy.title = dict["pfm_title"] as? String
        policy.description = dict["pfm_description"] as? String

        return policy
    }
}

// MARK: - Policy Subkey Extension
extension PolicySubkey {
    static func from(dict: [String: Any]) -> PolicySubkey? {
        guard let typeString = dict["pfm_type"] as? String,
              let type = PolicyType(rawValue: typeString) else {
            return nil
        }

        let name = dict["pfm_name"] as? String

        var subkeys: [PolicySubkey]?
        if let subkeysArray = dict["pfm_subkeys"] as? [[String: Any]] {
            subkeys = subkeysArray.compactMap { PolicySubkey.from(dict: $0) }
        }

        return PolicySubkey(type: type, name: name, subkeys: subkeys)
    }
}
