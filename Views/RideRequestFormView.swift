import SwiftUI
import MapKit

struct RideRequestFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RideRequestViewModel()
    @State private var showLocationPicker = false
    @State private var isPickupLocation = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ride Details")) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                        Button(action: {
                            isPickupLocation = true
                            showLocationPicker = true
                        }) {
                            Text(viewModel.pickupLocation.isEmpty ? "Pickup Location" : viewModel.pickupLocation)
                                .foregroundColor(viewModel.pickupLocation.isEmpty ? .gray : .primary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                        Button(action: {
                            isPickupLocation = false
                            showLocationPicker = true
                        }) {
                            Text(viewModel.destination.isEmpty ? "Destination" : viewModel.destination)
                                .foregroundColor(viewModel.destination.isEmpty ? .gray : .primary)
                        }
                    }
                    
                    Stepper("Party Size: \(viewModel.partySize)", value: $viewModel.partySize, in: 1...4)
                }
                
                Section(header: Text("Additional Info")) {
                    TextField("Notes (optional)", text: $viewModel.notes)
                }
            }
            .navigationTitle("Request Ride")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Request") {
                    viewModel.submitRequest()
                    dismiss()
                }
                .disabled(!viewModel.isValid)
            )
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(location: isPickupLocation ? $viewModel.pickupLocation : $viewModel.destination)
            }
        }
    }
} 