import Foundation

struct Message: Identifiable {
    let id: String
    let userId: String
    let text: String
    let timestamp: Date
    let type: MessageType
    
    enum MessageType {
        case text
        case rideRequest
        case system
    }
} 