//
//  ManifestModel.swift
//  BrowserConfigEditor
//
//  Model representing a browser manifest file
//

import Foundation

struct ManifestModel {
    let domain: String
    let name: String
    let description: String
    let policies: [PolicyModel]

    // Source information
    let browserPath: URL?
    let manifestPath: URL?

    init(domain: String, name: String, description: String, policies: [PolicyModel], browserPath: URL? = nil, manifestPath: URL? = nil) {
        self.domain = domain
        self.name = name
        self.description = description
        self.policies = policies
        self.browserPath = browserPath
        self.manifestPath = manifestPath
    }

    // Get a policy by name
    func policy(named: String) -> PolicyModel? {
        return policies.first { $0.name == named }
    }

    // Filter policies by search term (returns sorted results)
    func filterPolicies(searchTerm: String) -> [PolicyModel] {
        let filteredPolicies: [PolicyModel]
        if searchTerm.isEmpty {
            filteredPolicies = policies
        } else {
            let lowercasedSearch = searchTerm.lowercased()
            filteredPolicies = policies.filter { policy in
                policy.name.lowercased().contains(lowercasedSearch) ||
                policy.title?.lowercased().contains(lowercasedSearch) == true ||
                policy.description?.lowercased().contains(lowercasedSearch) == true
            }
        }

        // Sort alphabetically by name
        return filteredPolicies.sorted { policy1, policy2 in
            return policy1.name.localizedCaseInsensitiveCompare(policy2.name) == .orderedAscending
        }
    }
}
