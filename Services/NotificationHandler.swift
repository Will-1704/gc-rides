import UserNotifications
import Combine

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHandler()
    private let rideService: RideService
    
    private override init() {
        self.rideService = .shared
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        
        if identifier.starts(with: "arrival-check-") {
            let rideId = String(identifier.dropFirst("arrival-check-".count))
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // User tapped the notification
                handleArrivalCheck(rideId: rideId)
            case UNNotificationDismissActionIdentifier:
                // User dismissed the notification
                break
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    private func handleArrivalCheck(rideId: String) {
        // Show arrival confirmation dialog
        NotificationCenter.default.post(
            name: .showArrivalConfirmation,
            object: nil,
            userInfo: ["rideId": rideId]
        )
    }
}

extension Notification.Name {
    static let showArrivalConfirmation = Notification.Name("showArrivalConfirmation")
} 