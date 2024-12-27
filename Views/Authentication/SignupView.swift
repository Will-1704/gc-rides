import SwiftUI
import PhotosUI

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email Verification")) {
                    TextField("GC Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    if viewModel.isEmailVerified {
                        Label("Email Verified", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Button {
                            viewModel.verifyEmail()
                        } label: {
                            Text("Verify Email")
                        }
                        .disabled(!viewModel.canVerifyEmail)
                    }
                }
                
                if viewModel.isEmailVerified {
                    Section(header: Text("Profile Information")) {
                        TextField("First Name", text: $viewModel.firstName)
                            .textContentType(.givenName)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .textContentType(.familyName)
                        
                        PhotosPicker(selection: $viewModel.selectedPhoto) {
                            if let profileImage = viewModel.profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Label("Add Profile Picture", systemImage: "person.crop.circle.badge.plus")
                            }
                        }
                    }
                    
                    Section {
                        Button {
                            Task {
                                if await viewModel.createAccount() {
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!viewModel.canCreateAccount)
                    }
                }
            }
            .navigationTitle("Sign Up")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }
} 