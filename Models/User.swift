import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let isVerified: Bool
    let isDriver: Bool
    let profilePicture: String?
    let rating: Float
    let ridesCompleted: Int
    let badges: [DriverBadge]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var primaryBadge: DriverBadge? {
        // Prioritize badges in a specific order
        let priorityOrder: [DriverBadge.BadgeType] = [
            .excellence,
            .preferred,
            .specialist,
            .veteran,
            .certified
        ]
        
        return priorityOrder
            .compactMap { type in
                badges.first { $0.type == type }
            }
            .first
    }
}

struct DriverRegistration: Codable {
    let vehicleMake: String
    let vehicleModel: String
    let seatCapacity: Int
    let graduationYear: Int
    let paymentPreference: PaymentMethod
    let paymentUsername: String
}

struct DriverStatus: Codable {
    let isActive: Bool
    let currentLocation: Location?
    let lastUpdated: Date
} 