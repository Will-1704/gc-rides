import Foundation
import CoreLocation

struct CampusZone: Identifiable, Codable {
    let id: String
    let name: String
    let type: ZoneType
    let coordinates: [CLLocationCoordinate2D]
    let safetyLevel: SafetyLevel
    let operatingHours: OperatingHours?
    
    enum ZoneType: String, Codable {
        case academic
        case residential
        case parking
        case blueLight // Emergency phone locations
        case restricted
        case shuttle
    }
    
    enum SafetyLevel: Int, Codable {
        case high = 3    // Well-lit, high traffic, monitored
        case medium = 2  // Moderate traffic, some monitoring
        case low = 1     // Low traffic, limited monitoring
        
        var color: String {
            switch self {
            case .high: return "green"
            case .medium: return "yellow"
            case .low: return "red"
            }
        }
    }
    
    struct OperatingHours: Codable {
        let openTime: Date
        let closeTime: Date
        let isAlwaysOpen: Bool
    }
} 