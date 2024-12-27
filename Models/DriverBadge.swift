import Foundation

struct DriverBadge: Identifiable, Codable {
    let id: String
    let type: BadgeType
    let issuedAt: Date
    let issuedBy: String
    let reason: String?
    
    enum BadgeType: String, Codable, CaseIterable {
        case certified = "CERTIFIED"
        case veteran = "VETERAN"
        case excellence = "EXCELLENCE"
        case preferred = "PREFERRED"
        case specialist = "SPECIALIST"
        
        var displayName: String {
            switch self {
            case .certified: return "Certified Driver"
            case .veteran: return "Veteran Driver"
            case .excellence: return "Excellence in Service"
            case .preferred: return "Preferred Partner"
            case .specialist: return "Specialist"
            }
        }
        
        var icon: String {
            switch self {
            case .certified: return "checkmark.shield.fill"
            case .veteran: return "star.circle.fill"
            case .excellence: return "medal.fill"
            case .preferred: return "crown.fill"
            case .specialist: return "certificate.fill"
            }
        }
        
        var color: String {
            switch self {
            case .certified: return "blue"
            case .veteran: return "purple"
            case .excellence: return "gold"
            case .preferred: return "green"
            case .specialist: return "red"
            }
        }
    }
} 