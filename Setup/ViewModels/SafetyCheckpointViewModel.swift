import Foundation

class SafetyCheckpointViewModel: ObservableObject {
    @Published var verificationCode = ""
    @Published var responses: [String: Bool] = [:]
    @Published var showAlert = false
    @Published var alertMessage: String?
    @Published var alertAction: AlertAction?
    
    var requiresVerification = true
    var isCodeValid = false
    var canSubmit: Bool {
        !requiresVerification || isCodeValid
    }
    
    var safetyQuestions: [SafetyQuestion] {
        MockData.safetyQuestions
    }
    
    struct AlertAction {
        let title: String
        let handler: () -> Void
    }
    
    func shareLocation() {
        // Mock implementation
    }
    
    func contactSupport() {
        // Mock implementation
    }
    
    func triggerEmergency() {
        // Mock implementation
    }
    
    func submitCheckpoint() async -> Bool {
        // Mock implementation
        return true
    }
} 