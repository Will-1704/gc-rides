import Foundation

struct AutomationRule: Identifiable, Codable {
    let id: String
    let name: String
    let trigger: Trigger
    let conditions: [Condition]
    let actions: [Action]
    let priority: Int
    var isEnabled: Bool
    
    enum Trigger: String, Codable {
        case enterZone
        case exitZone
        case timeOfDay
        case startRide
        case endRide
        case lowBattery
        case speedThreshold
        case noMovement
    }
    
    struct Condition: Codable {
        let type: ConditionType
        let parameters: [String: String]
        
        enum ConditionType: String, Codable {
            case timeRange
            case zoneType
            case safetyLevel
            case batteryLevel
            case speed
            case weather
        }
    }
    
    struct Action: Codable {
        let type: ActionType
        let parameters: [String: String]
        
        enum ActionType: String, Codable {
            case notifyContact
            case notifyGroup
            case shareLocation
            case requestCheck
            case suggestRoute
            case activateNightMode
        }
    }
} 