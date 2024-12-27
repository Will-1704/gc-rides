import Foundation
import CoreLocation

struct EmergencyProtocol: Identifiable, Codable {
    let id: String
    let type: EmergencyType
    let severity: SeverityLevel
    let actions: [EmergencyAction]
    let autoActivate: Bool
    
    enum EmergencyType: String, Codable {
        case medical
        case security
        case vehicleIssue
        case harassment
        case suspiciousActivity
        case weatherAlert
        
        var icon: String {
            switch self {
            case .medical: return "cross.circle.fill"
            case .security: return "shield.fill"
            case .vehicleIssue: return "car.circle.fill"
            case .harassment: return "exclamationmark.triangle.fill"
            case .suspiciousActivity: return "eye.fill"
            case .weatherAlert: return "cloud.bolt.fill"
            }
        }
    }
    
    enum SeverityLevel: Int, Codable {
        case low = 1
        case medium = 2
        case high = 3
        case critical = 4
        
        var responseTime: TimeInterval {
            switch self {
            case .low: return 300 // 5 minutes
            case .medium: return 180 // 3 minutes
            case .high: return 60 // 1 minute
            case .critical: return 0 // Immediate
            }
        }
    }
} 