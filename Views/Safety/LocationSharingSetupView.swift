import SwiftUI
import ContactsUI

struct LocationSharingSetupView: View {
    @StateObject private var viewModel = LocationSharingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Safety Contacts")) {
                    ForEach(viewModel.safetyContacts) { contact in
                        ContactRow(contact: contact) {
                            viewModel.removeContact(contact)
                        }
                    }
                    
                    Button {
                        viewModel.showContactPicker = true
                    } label: {
                        Label("Add Contact", systemImage: "person.badge.plus")
                    }
                }
                
                Section(header: Text("Automatic Sharing")) {
                    Toggle("Share All Rides", isOn: $viewModel.shareAllRides)
                    
                    if viewModel.shareAllRides {
                        Text("Location will be automatically shared with your safety contacts when you start a ride")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Emergency Settings")) {
                    Toggle("Quick SOS", isOn: $viewModel.enableQuickSOS)
                    
                    if viewModel.enableQuickSOS {
                        Text("Triple-tap the power button to trigger SOS")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Location Sharing")
            .sheet(isPresented: $viewModel.showContactPicker) {
                ContactPickerView(selection: viewModel.addContact)
            }
        }
    }
} 