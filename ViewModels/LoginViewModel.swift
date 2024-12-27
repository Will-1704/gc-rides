import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var error: String?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthenticationService
    
    var isValid: Bool {
        email.contains("@bobcats.gcsu.edu") && password.count >= 6
    }
    
    init(authService: AuthenticationService = .shared) {
        self.authService = authService
    }
    
    func login() {
        isLoading = true
        error = nil
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { _ in
                // Login successful, AuthManager will handle the state change
            }
            .store(in: &cancellables)
    }
} 