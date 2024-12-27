import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var isAvailable = false
    @Published var shareTripStatus = false
    @Published var enablePINVerification = false
    @Published var showDriverRegistration = false
    
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserService
    
    var isDriver: Bool = false
    var fullName: String = ""
    var email: String = ""
    
    init(userService: UserService = .shared) {
        self.userService = userService
        loadUserProfile()
    }
    
    func loadUserProfile() {
        userService.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error loading profile: \(error)")
                }
            } receiveValue: { [weak self] user in
                self?.fullName = "\(user.firstName) \(user.lastName)"
                self?.email = user.email
                self?.isDriver = user.isDriver
                // Load other user properties
            }
            .store(in: &cancellables)
    }
    
    func signOut() {
        AuthenticationManager.shared.signOut()
    }
} 