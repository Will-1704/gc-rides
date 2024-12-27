import Foundation

enum PaymentPlatform: String, Codable, CaseIterable {
    case venmo
    case cashApp
    case cash
    
    var displayName: String {
        switch self {
        case .venmo: return "Venmo"
        case .cashApp: return "Cash App"
        case .cash: return "Cash"
        }
    }
    
    var icon: String {
        switch self {
        case .venmo: return "venmo_icon"
        case .cashApp: return "cashapp_icon"
        case .cash: return "dollarsign.circle.fill"
        }
    }
    
    var deepLinkPrefix: String? {
        switch self {
        case .venmo: return "venmo://users/"
        case .cashApp: return "cash.app/$"
        case .cash: return nil
        }
    }
}

struct PaymentInfo: Codable {
    let platform: PaymentPlatform
    let username: String
    let preferredAmount: Double?
    let customRates: [TimeRange: Double]?
    
    struct TimeRange: Codable, Hashable {
        let start: Date
        let end: Date
        let amount: Double
    }
} 