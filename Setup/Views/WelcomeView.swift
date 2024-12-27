import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to GC Rides")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            PrimaryButton(title: "Sign In") {
                Task {
                    try? await AuthenticationManager.shared.signIn(
                        email: "test@test.com",
                        password: "password"
                    )
                }
            }
        }
        .padding()
    }
} 