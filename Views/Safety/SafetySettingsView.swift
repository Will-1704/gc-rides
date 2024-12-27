import SwiftUI
import ContactsUI

struct SafetySettingsView: View {
    @StateObject private var viewModel = SafetySettingsViewModel()
    @State private var showContactPicker = false
    
    var body: some View {
        Form {
            // Quick Access Safety Features
            Section(header: Text("Quick Access")) {
                Toggle("Enable Quick SOS", isOn: $viewModel.settings.quickSOSEnabled)
                
                NavigationLink {
                    LocationSharingSetupView()
                } label: {
                    Label("Location Sharing", systemImage: "location.fill")
                }
                
                Link(destination: URL(string: "https://www.gcsu.edu/safety")!) {
                    Label("GCSU Safety Resources", systemImage: "shield.fill")
                }
            }
            
            // Emergency Contacts
            Section(header: Text("Emergency Contacts")) {
                ForEach(viewModel.settings.emergencyContacts) { contact in
                    EmergencyContactRow(contact: contact) {
                        viewModel.removeContact(contact)
                    }
                }
                
                Button {
                    showContactPicker = true
                } label: {
                    Label("Add Emergency Contact", systemImage: "person.badge.plus")
                }
            }
            
            // Ride Safety
            Section(header: Text("Ride Safety")) {
                Toggle("Require Verification Code", isOn: $viewModel.settings.safetyPreferences.requireVerificationCode)
                
                Toggle("Share Ride Details", isOn: $viewModel.settings.safetyPreferences.shareRideDetails)
                
                Toggle("Send ETA Updates", isOn: $viewModel.settings.safetyPreferences.sendETAUpdates)
                
                Stepper(
                    "Minimum Driver Rating: \(viewModel.settings.safetyPreferences.minimumDriverRating, specifier: "%.1f")",
                    value: $viewModel.settings.safetyPreferences.minimumDriverRating,
                    in: 3.0...5.0,
                    step: 0.5
                )
            }
            
            // Night Mode Settings
            Section(header: Text("Night Mode Settings")) {
                Toggle("Enable Night Mode", isOn: $viewModel.settings.safetyPreferences.nightModeSettings.enabled)
                
                if viewModel.settings.safetyPreferences.nightModeSettings.enabled {
                    DatePicker(
                        "Start Time",
                        selection: $viewModel.settings.safetyPreferences.nightModeSettings.startTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    DatePicker(
                        "End Time",
                        selection: $viewModel.settings.safetyPreferences.nightModeSettings.endTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    Toggle("Additional Verification", isOn: $viewModel.settings.safetyPreferences.nightModeSettings.additionalVerification)
                    
                    Toggle("Auto-Share with Contacts", isOn: $viewModel.settings.safetyPreferences.nightModeSettings.autoShareWithContacts)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppColor.background)
        .preferredColorScheme(.automatic)
        .navigationTitle("Safety Settings")
        .sheet(isPresented: $showContactPicker) {
            ContactPickerView { contact in
                viewModel.addEmergencyContact(from: contact)
            }
        }
        .onChange(of: viewModel.settings) { _ in
            viewModel.saveSettings()
        }
    }
}

struct EmergencyContactRow: View {
    let contact: EmergencyContact
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(contact.name)
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button {
                        onDelete()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    .tint(.red)
                    
                    NavigationLink {
                        ContactNotificationSettings(contact: contact)
                    } label: {
                        Label("Notification Settings", systemImage: "bell")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            Text(contact.phoneNumber)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let relationship = contact.relationship {
                Text(relationship)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
} 