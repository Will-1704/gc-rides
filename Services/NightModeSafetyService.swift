import Foundation
import CoreLocation

class NightModeSafetyService {
    static let shared = NightModeSafetyService()
    private let locationManager = CLLocationManager()
    
    func activateNightMode(settings: EmergencySettings.SafetyPreferences.NightModeSettings) {
        guard settings.enabled else { return }
        
        // Enhanced location tracking
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Auto-contact settings
        if settings.autoShareWithContacts {
            setupAutoContactSharing()
        }
        
        // Additional verification requirements
        if settings.additionalVerification {
            setupEnhancedVerification()
        }
        
        // Monitor unsafe areas
        startGeofencing()
    }
    
    private func setupAutoContactSharing() {
        // Setup automatic location sharing with emergency contacts
        guard let contacts = UserDefaults.standard.emergencyContacts else { return }
        
        contacts.forEach { contact in
            if contact.notificationPreferences.locationUpdates {
                scheduleLocationUpdates(for: contact)
            }
        }
    }
    
    private func setupEnhancedVerification() {
        // Additional safety checks during night mode
        NotificationCenter.default.post(
            name: .requireAdditionalVerification,
            object: nil
        )
    }
    
    private func startGeofencing() {
        // Monitor known unsafe areas
        guard let unsafeAreas = loadUnsafeAreas() else { return }
        
        unsafeAreas.forEach { area in
            let region = CLCircularRegion(
                center: area.coordinate,
                radius: 100, // meters
                identifier: area.id
            )
            locationManager.startMonitoring(for: region)
        }
    }
} 