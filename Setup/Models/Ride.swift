import Foundation
import CoreLocation

struct Ride: Identifiable {
    let id: String
    let driverId: String
    let riderId: String
    let pickup: Location
    let dropoff: Location
    let status: RideStatus
    let timestamp: Date
    
    struct Location {
        let name: String
        let coordinates: CLLocationCoordinate2D
    }
    
    enum RideStatus: String {
        case requested
        case accepted
        case inProgress
        case completed
        case cancelled
    }
} 