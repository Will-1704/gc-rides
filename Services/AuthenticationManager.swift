import Foundation

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private init() {}
    
    func signIn(email: String, password: String) async throws {
        // Implement sign in logic
        isAuthenticated = true
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
} 