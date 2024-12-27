import Foundation
import CoreLocation

struct RideRequest: Identifiable {
    let id: String
    let userId: String
    let pickup: Location
    let dropoff: Location
    let passengers: Int
    let timestamp: Date
    
    struct Location {
        let name: String
        let coordinates: CLLocationCoordinate2D
    }
} 