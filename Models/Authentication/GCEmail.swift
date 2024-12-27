import Foundation

struct GCEmail {
    let email: String
    
    var isValid: Bool {
        email.lowercased().hasSuffix("@bobcats.gcsu.edu")
    }
    
    static func validate(_ email: String) -> ValidationResult {
        let email = GCEmail(email: email)
        return email.isValid 
            ? .success
            : .failure("This app is only available for GC Students at this moment. Please use your @bobcats.gcsu.edu email.")
    }
    
    enum ValidationResult {
        case success
        case failure(String)
    }
} 