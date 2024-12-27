import Foundation

struct SafetyBehavior: Identifiable {
    let id: String
    let type: BehaviorType
    let timestamp: Date
    let data: [String: Any]
    
    enum BehaviorType {
        case locationUpdate
        case zoneEntry
        case zoneExit
        case rideCompletion
        case verification
        case contactUpdate
    }
} 