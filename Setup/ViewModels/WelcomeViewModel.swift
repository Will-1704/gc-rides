import Foundation

class WelcomeViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showError = false
    @Published var errorMessage: String?
} 