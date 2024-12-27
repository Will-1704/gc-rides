import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showImagePicker = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        if let image = viewModel.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.fullName)
                                .font(.headline)
                            Text(viewModel.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading)
                    }
                    .padding(.vertical, 8)
                }
                
                if viewModel.isDriver {
                    Section(header: Text("Driver Status")) {
                        Toggle("Available for Rides", isOn: $viewModel.isAvailable)
                        NavigationLink("Driver Settings") {
                            DriverSettingsView()
                        }
                        NavigationLink("View Reviews") {
                            ReviewsListView()
                        }
                    }
                } else {
                    Section {
                        Button("Become a Driver") {
                            viewModel.showDriverRegistration = true
                        }
                    }
                }
                
                Section(header: Text("Account")) {
                    NavigationLink("Edit Profile") {
                        EditProfileView()
                    }
                    NavigationLink("Payment Methods") {
                        PaymentMethodsView()
                    }
                    NavigationLink("Ride History") {
                        RideHistoryView()
                    }
                }
                
                Section(header: Text("Safety")) {
                    NavigationLink("Emergency Contacts") {
                        EmergencyContactsView()
                    }
                    Toggle("Share Trip Status", isOn: $viewModel.shareTripStatus)
                    Toggle("Enable PIN Verification", isOn: $viewModel.enablePINVerification)
                }
                
                Section {
                    Button(action: viewModel.signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
            }
            .sheet(isPresented: $viewModel.showDriverRegistration) {
                DriverRegistrationView()
            }
        }
    }
} 