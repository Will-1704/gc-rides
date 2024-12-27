import Foundation
import CoreLocation
import Combine

class RideSafetyMonitoringService {
    static let shared = RideSafetyMonitoringService()
    private var activeMonitors: Set<SafetyMonitor> = []
    private var cancellables = Set<AnyCancellable>()
    
    func startMonitoring(ride: Ride) {
        let monitor = SafetyMonitor(ride: ride)
        activeMonitors.insert(monitor)
        
        // Route deviation monitoring
        monitor.routePublisher
            .filter { deviation in
                deviation.distance > 500 // meters
            }
            .sink { [weak self] deviation in
                self?.handleRouteDeviation(deviation, for: ride)
            }
            .store(in: &cancellables)
        
        // Speed monitoring
        monitor.speedPublisher
            .filter { speed in
                speed > 80 // mph
            }
            .sink { [weak self] speed in
                self?.handleSpeedAlert(speed, for: ride)
            }
            .store(in: &cancellables)
        
        // Stop duration monitoring
        monitor.stopDurationPublisher
            .filter { duration in
                duration > 300 // 5 minutes
            }
            .sink { [weak self] duration in
                self?.handleExtendedStop(duration, for: ride)
            }
            .store(in: &cancellables)
        
        // Battery monitoring
        monitor.batteryPublisher
            .filter { level in
                level < 0.20
            }
            .sink { [weak self] level in
                self?.handleLowBattery(level, for: ride)
            }
            .store(in: &cancellables)
    }
    
    private func handleRouteDeviation(_ deviation: RouteDeviation, for ride: Ride) {
        Task {
            // Alert rider and driver
            await NotificationService.shared.sendSafetyAlert(
                title: "Route Deviation Detected",
                body: "Your ride has deviated significantly from the expected route."
            )
            
            // Share updated location with emergency contacts
            if deviation.distance > 1000 { // 1km
                await LocationSharingService.shared.shareLocationWithContacts(
                    ride: ride,
                    reason: .routeDeviation
                )
            }
            
            // Log incident
            await SafetyAnalyticsService.shared.logSafetyIncident(
                type: .routeDeviation,
                severity: .medium,
                rideId: ride.id
            )
        }
    }
} 