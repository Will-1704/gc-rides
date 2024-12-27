import Foundation
import CoreLocation

class GeofencingService: NSObject, CLLocationManagerDelegate {
    static let shared = GeofencingService()
    private let locationManager = CLLocationManager()
    private var activeZones: [CampusZone] = []
    private var monitoredRegions: [String: CLCircularRegion] = [:]
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func startMonitoring() {
        Task {
            do {
                activeZones = try await loadCampusZones()
                setupGeofences()
            } catch {
                print("Failed to load campus zones: \(error)")
            }
        }
    }
    
    private func setupGeofences() {
        // Clear existing geofences
        monitoredRegions.values.forEach(locationManager.stopMonitoring)
        monitoredRegions.removeAll()
        
        // Setup new geofences
        activeZones.forEach { zone in
            let center = calculateZoneCenter(coordinates: zone.coordinates)
            let radius = calculateZoneRadius(coordinates: zone.coordinates)
            
            let region = CLCircularRegion(
                center: center,
                radius: radius,
                identifier: zone.id
            )
            
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            locationManager.startMonitoring(for: region)
            monitoredRegions[zone.id] = region
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let zone = activeZones.first(where: { $0.id == region.identifier }) else { return }
        
        // Check safety level and time
        if zone.safetyLevel == .low || isOutsideOperatingHours(zone.operatingHours) {
            NotificationService.shared.sendSafetyAlert(
                title: "Safety Alert",
                body: "You've entered \(zone.name). Exercise caution in this area."
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Track zone transitions for safety analysis
        SafetyAnalyticsService.shared.logZoneTransition(zoneId: region.identifier, type: .exit)
    }
} 