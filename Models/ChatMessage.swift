import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: String
    let senderId: String
    let content: String
    let timestamp: Date
    let isRideRequest: Bool
    let rideRequest: RideRequest?
    
    var sender: User?
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct ActiveRide: Identifiable, Codable {
    let id: String
    let status: RideStatus
    let pickup: Location
    let destination: Location
    let driver: User?
    let rider: User
    let estimatedTime: String
    let partySize: Int
    let notes: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: driver?.currentLocation?.latitude ?? pickup.latitude,
            longitude: driver?.currentLocation?.longitude ?? pickup.longitude
        )
    }
} 