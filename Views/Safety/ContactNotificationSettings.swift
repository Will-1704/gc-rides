import SwiftUI

struct ContactNotificationSettings: View {
    let contact: EmergencyContact
    @StateObject private var viewModel = ContactNotificationViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Ride Updates")) {
                Toggle("Ride Start", isOn: $viewModel.preferences.rideStart)
                Toggle("Ride End", isOn: $viewModel.preferences.rideEnd)
                Toggle("Location Updates", isOn: $viewModel.preferences.locationUpdates)
            }
            
            Section(header: Text("Safety Alerts")) {
                Toggle("Emergency Alerts", isOn: $viewModel.preferences.emergencyAlerts)
                Toggle("Delay Notifications", isOn: $viewModel.preferences.delayNotifications)
            }
            
            Section(footer: Text("This contact will receive text messages for enabled notifications")) {
                Button("Test Notifications") {
                    viewModel.sendTestNotification()
                }
            }
        }
        .navigationTitle("\(contact.name) Notifications")
        .onDisappear {
            viewModel.savePreferences()
        }
    }
} 