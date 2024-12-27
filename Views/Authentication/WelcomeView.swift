import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignup = false
    
    var body: some View {
        ZStack {
            // Background
            Color("BrandBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo and Title
                Image("GCRidesLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("GC Rides")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Safe rides for GC students")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button {
                        showSignup = true
                    } label: {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        showLogin = true
                    } label: {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .fullScreenCover(isPresented: $showSignup) {
            SignupView()
        }
    }
} 