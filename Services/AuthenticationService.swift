import Foundation
import Combine

class AuthenticationService {
    static let shared = AuthenticationService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func login(email: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        let body = try? JSONEncoder().encode(LoginRequest(email: email, password: password))
        return networkService.request("/login", method: "POST", body: body)
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) -> AnyPublisher<AuthResponse, Error> {
        let body = try? JSONEncoder().encode(RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        ))
        return networkService.request("/register", method: "POST", body: body)
    }
    
    func verifyEmail(token: String) -> AnyPublisher<VerificationResponse, Error> {
        networkService.request("/verify-email/\(token)")
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct VerificationResponse: Codable {
    let message: String
} 