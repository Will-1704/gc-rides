import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let profileImageUrl: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
} 