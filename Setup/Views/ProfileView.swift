import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    UserInfoRow(user: viewModel.user)
                }
                
                Section {
                    Button("Sign Out") {
                        AuthenticationManager.shared.signOut()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
} 