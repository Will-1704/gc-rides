import Foundation
import CoreLocation
import Combine

class SafetyService {
    static let shared = SafetyService()
    private let networkService: NetworkService
    private let locationManager: CLLocationManager
    private var locationUpdateTimer: Timer?
    private var activeShares: Set<String> = []
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
        self.locationManager = CLLocationManager()
        setupLocationManager()
    }
    
    func startLocationSharing(
        rideId: String,
        contacts: [SafetyContact]
    ) async throws -> [LocationShare] {
        let shares = try await contacts.asyncMap { contact in
            try await createLocationShare(rideId: rideId, contact: contact)
        }
        
        // Start location updates
        activeShares = Set(shares.map { $0.id })
        startLocationUpdates()
        
        // Send initial messages
        await sendLocationMessages(for: shares)
        
        return shares
    }
    
    func stopLocationSharing(shareIds: [String]) async {
        activeShares.subtract(shareIds)
        if activeShares.isEmpty {
            stopLocationUpdates()
        }
        
        // Update server
        try? await networkService.request(
            "/safety/location-sharing/stop",
            method: "POST",
            body: try? JSONEncoder().encode(shareIds)
        ).value
    }
    
    func triggerSOS() {
        guard let location = locationManager.location else { return }
        
        // Call emergency services
        if let url = URL(string: "tel://911") {
            UIApplication.shared.open(url)
        }
        
        // Alert emergency contacts
        Task {
            try? await sendSOSAlerts(location: location)
        }
    }
    
    private func sendLocationMessages(for shares: [LocationShare]) async {
        guard let location = locationManager.location else { return }
        
        for share in shares {
            let message = """
                \(AuthenticationManager.shared.currentUser?.fullName ?? "Your friend") is sharing their ride location with you.
                Track their journey here: https://gcrides.app/track/\(share.trackingCode)
                
                Current location: https://maps.google.com/?q=\(location.coordinate.latitude),\(location.coordinate.longitude)
                """
            
            SMSService.shared.sendMessage(
                to: share.recipientPhone,
                body: message
            )
        }
    }
    
    private func updateLocation(_ location: CLLocation) {
        guard !activeShares.isEmpty else { return }
        
        Task {
            let update = LocationUpdate(
                shareIds: Array(activeShares),
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                timestamp: Date()
            )
            
            try? await networkService.request(
                "/safety/location-update",
                method: "POST",
                body: try? JSONEncoder().encode(update)
            ).value
        }
    }
} 