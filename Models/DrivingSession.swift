import Foundation

struct DrivingSession: Codable, Identifiable {
    let id: String
    let driverId: String
    let startTime: Date
    let endTime: Date
    let ridesCompleted: Int
    let earnings: Double
    let totalDistance: Double
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return "\(hours)h \(minutes)m"
    }
}

extension User {
    struct DriverInfo: Codable {
        let vehicleMake: String
        let vehicleModel: String
        let seatCapacity: Int
        let graduationYear: Int
        let paymentMethods: [PaymentMethod]
        let isActive: Bool
        let lastDrivingSession: DrivingSession?
        let totalEarnings: Double
        let totalRides: Int
        let averageRating: Float
    }
} 