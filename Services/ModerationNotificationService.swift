import Foundation
import UserNotifications

class ModerationNotificationService {
    static let shared = ModerationNotificationService()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                self.registerNotificationCategories()
            }
        }
    }
    
    private func registerNotificationCategories() {
        let reviewAction = UNNotificationAction(
            identifier: "REVIEW_ACTION",
            title: "Review",
            options: .foreground
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: .destructive
        )
        
        let reportCategory = UNNotificationCategory(
            identifier: "REPORT_CATEGORY",
            actions: [reviewAction, dismissAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        notificationCenter.setNotificationCategories([reportCategory])
    }
    
    func notifyModerators(about report: ContentReport) {
        let content = UNMutableNotificationContent()
        content.title = "New Report: \(report.contentType.rawValue)"
        content.body = "Reason: \(report.reason.rawValue)\n\(report.description)"
        content.sound = .default
        content.categoryIdentifier = "REPORT_CATEGORY"
        content.userInfo = [
            "reportId": report.id,
            "contentType": report.contentType.rawValue,
            "contentId": report.contentId
        ]
        
        // Determine priority and trigger time based on severity
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: report.reason.severity.notificationDelay,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "report-\(report.id)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
}

extension ContentReport.ReportReason {
    var severity: ReportSeverity {
        switch self {
        case .harassment: return .high
        case .inappropriate: return .medium
        case .spam: return .low
        case .falseInformation: return .medium
        case .other: return .low
        }
    }
}

enum ReportSeverity {
    case high, medium, low
    
    var notificationDelay: TimeInterval {
        switch self {
        case .high: return 1 // Almost immediate
        case .medium: return 300 // 5 minutes
        case .low: return 3600 // 1 hour
        }
    }
} 