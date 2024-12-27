import Foundation

struct Driver: Identifiable {
    let id: String
    let user: User
    let isActive: Bool
    let vehicle: VehicleDetails
    
    struct VehicleDetails {
        let make: String
        let model: String
        let capacity: Int
    }
} 