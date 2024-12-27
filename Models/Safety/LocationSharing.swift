import Foundation
import CoreLocation
import MessageUI

struct LocationShare: Codable, Identifiable {
    let id: String
    let rideId: String
    let userId: String
    let recipientPhone: String
    let startTime: Date
    let endTime: Date?
    let trackingCode: String
    
    var isActive: Bool {
        endTime == nil && startTime <= Date()
    }
}

struct SafetyContact: Codable, Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let isEmergencyContact: Bool
    let autoShare: Bool
} 