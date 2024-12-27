import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        if authManager.isAuthenticated {
            MainTabView()
        } else {
            WelcomeView()
        }
    }
} 