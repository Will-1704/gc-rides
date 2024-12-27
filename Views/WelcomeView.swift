import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignup = false
    
    var body: some View {
        ZStack {
            // Background
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Image("GCRidesLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Text("Welcome to GC Rides")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Safe rides for GCSU students")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 16) {
                    Button(action: { showLogin.toggle() }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { showSignup.toggle() }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .sheet(isPresented: $showSignup) {
            SignupView()
        }
    }
} 