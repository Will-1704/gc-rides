import SwiftUI

struct DriverRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DriverRegistrationViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Information")) {
                    TextField("Vehicle Make", text: $viewModel.vehicleMake)
                    TextField("Vehicle Model", text: $viewModel.vehicleModel)
                    Stepper("Seat Capacity: \(viewModel.seatCapacity)", value: $viewModel.seatCapacity, in: 1...8)
                }
                
                Section(header: Text("Driver Information")) {
                    Picker("Graduation Year", selection: $viewModel.graduationYear) {
                        ForEach(Calendar.current.year...Calendar.current.year + 4, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                }
                
                Section(header: Text("Payment Preferences")) {
                    Picker("Preferred Payment Method", selection: $viewModel.paymentPreference) {
                        ForEach(PaymentMethod.allCases) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    
                    if viewModel.paymentPreference != .cash {
                        TextField("\(viewModel.paymentPreference.rawValue) Username", text: $viewModel.paymentUsername)
                    }
                }
                
                Section(header: Text("Terms & Conditions")) {
                    Toggle("I agree to the Terms of Service", isOn: $viewModel.agreedToTerms)
                    Toggle("I understand the safety guidelines", isOn: $viewModel.agreedToSafety)
                }
                
                if let error = viewModel.error {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Become a Driver")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Register") {
                    Task {
                        if await viewModel.registerAsDriver() {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isValid)
            )
        }
    }
} 