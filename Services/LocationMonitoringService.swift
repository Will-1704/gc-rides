import CoreLocation
import UserNotifications
import Combine

class LocationMonitoringService: NSObject, ObservableObject {
    static let shared = LocationMonitoringService()
    private let locationManager = CLLocationManager()
    private var currentRide: ActiveRide?
    private var destinationRegion: CLCircularRegion?
    private var arrivalTimer: Timer?
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        setupLocationManager()
        requestNotificationPermissions()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    private func requestNotificationPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func startMonitoring(ride: ActiveRide) {
        currentRide = ride
        
        // Create region around destination
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(
                latitude: ride.destination.latitude,
                longitude: ride.destination.longitude
            ),
            radius: 160, // ~0.1 miles
            identifier: ride.id
        )
        region.notifyOnEntry = true
        
        destinationRegion = region
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring() {
        if let region = destinationRegion {
            locationManager.stopMonitoring(for: region)
        }
        arrivalTimer?.invalidate()
        arrivalTimer = nil
        currentRide = nil
        destinationRegion = nil
    }
    
    private func handleArrival() {
        arrivalTimer = Timer.scheduledTimer(withTimeInterval: 180, repeats: false) { [weak self] _ in
            self?.checkRideStatus()
        }
    }
    
    private func checkRideStatus() {
        guard let ride = currentRide, ride.status == .inProgress else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Ride Check"
        content.body = "Have you arrived safely at your destination?"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "arrival-check-\(ride.id)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
}

extension LocationMonitoringService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == currentRide?.id {
            handleArrival()
        }
    }
} 