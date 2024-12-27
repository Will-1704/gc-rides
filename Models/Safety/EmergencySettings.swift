import Foundation

struct EmergencySettings: Codable {
    var autoShareLocation: Bool = true
    var quickSOSEnabled: Bool = true
    var emergencyContacts: [EmergencyContact]
    var safetyPreferences: SafetyPreferences
    
    struct SafetyPreferences: Codable {
        var requireVerificationCode: Bool = true
        var shareRideDetails: Bool = true
        var sendETAUpdates: Bool = true
        var minimumDriverRating: Double = 4.0
        var nightModeSettings: NightModeSettings
        
        struct NightModeSettings: Codable {
            var enabled: Bool = true
            var startTime: Date // e.g., 9 PM
            var endTime: Date   // e.g., 5 AM
            var additionalVerification: Bool = true
            var autoShareWithContacts: Bool = true
        }
    }
}

struct EmergencyContact: Identifiable, Codable {
    let id: String
    let name: String
    let phoneNumber: String
    let relationship: String?
    let notificationPreferences: NotificationPreferences
    
    struct NotificationPreferences: Codable {
        var rideStart: Bool = true
        var rideEnd: Bool = true
        var locationUpdates: Bool = true
        var emergencyAlerts: Bool = true
        var delayNotifications: Bool = true
    }
} 