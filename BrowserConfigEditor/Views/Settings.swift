//
//  Settings.swift
//  BrowserConfigEditor
//
//  Created by Gil Burns on 1/17/26.
//

import SwiftUI
import Sparkle

// This is the view for our updater settings
// It manages local state for checking for updates and automatically downloading updates
// Upon user changes to these, the updater's properties are set. These are backed by NSUserDefaults.
// Note the updater properties should *only* be set when the user changes the state.

struct UpdaterSettingsView: View {
    private let updater: SPUUpdater

    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool
    @State private var scheduledCheckInterval: Int = 86_400

    init(updater: SPUUpdater) {
        self.updater = updater
        _automaticallyChecksForUpdates = State(initialValue: updater.automaticallyChecksForUpdates)
        _automaticallyDownloadsUpdates = State(initialValue: updater.automaticallyDownloadsUpdates)
        _scheduledCheckInterval = State(initialValue: UserDefaults.standard.integer(forKey: "SUScheduledCheckInterval"))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Update Checks:", systemImage: "arrow.2.circlepath.circle")
                .font(.headline)
            Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                .onChange(of: automaticallyChecksForUpdates) {
                    updater.automaticallyChecksForUpdates = automaticallyChecksForUpdates
                }

            Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) {
                    updater.automaticallyDownloadsUpdates = automaticallyDownloadsUpdates
                }

            Picker("Check Interval", selection: $scheduledCheckInterval) {
                Text("Once a day").tag(86_400)
                Text("Once a week").tag(86_400 * 7)
                Text("Once a fortnight").tag(86_400 * 14)
                Text("Once a month").tag(86_400 * 30)
            }
            .disabled(!automaticallyChecksForUpdates)
            // Observe the value, not the binding, so it meets Equatable
            .onChange(of: scheduledCheckInterval) { oldInterval, newInterval in
                UserDefaults.standard.set(newInterval, forKey: "SUScheduledCheckInterval")
            }

            HStack {
                Spacer()
                Button("Check now…") {
                    checkForUpdates()
                }
            }
        }
        .padding()
    }

    private func checkForUpdates() {
        updater.checkForUpdates()
    }
}

