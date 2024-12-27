import Foundation

enum AnalyticsEvent: String {
    case rideRequested = "ride_requested"
    case rideCompleted = "ride_completed"
    case rideCancelled = "ride_cancelled"
    case driverModeEnabled = "driver_mode_enabled"
    case driverModeDisabled = "driver_mode_disabled"
    case reviewSubmitted = "review_submitted"
    case paymentProcessed = "payment_processed"
    case appOpened = "app_opened"
    case errorOccurred = "error_occurred"
}

class AnalyticsService {
    static let shared = AnalyticsService()
    
    func trackEvent(_ event: AnalyticsEvent, properties: [String: Any] = [:]) {
        var eventProperties = properties
        eventProperties["timestamp"] = Date()
        eventProperties["platform"] = "iOS"
        
        // Add user properties if available
        if let user = AuthenticationManager.shared.currentUser {
            eventProperties["user_id"] = user.id
            eventProperties["user_type"] = user.isDriver ? "driver" : "rider"
        }
        
        // Send to analytics backend
        Task {
            do {
                try await sendAnalytics(event: event.rawValue, properties: eventProperties)
            } catch {
                print("Failed to track analytics: \(error)")
            }
        }
    }
    
    private func sendAnalytics(event: String, properties: [String: Any]) async throws {
        // Implement analytics backend integration
        // This could be Firebase, Mixpanel, or your custom analytics service
    }
}

// Usage example in ViewModels:
extension RideHistoryViewModel {
    func trackRideCompletion(_ ride: RideHistoryItem) {
        AnalyticsService.shared.trackEvent(.rideCompleted, properties: [
            "ride_id": ride.id,
            "driver_id": ride.driver?.id ?? "",
            "duration": ride.duration,
            "distance": ride.distance,
            "amount": ride.amount ?? 0
        ])
    }
} 