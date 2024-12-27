import Foundation

struct ModerationAnalytics: Codable {
    let totalReports: Int
    let resolvedReports: Int
    let averageResponseTime: TimeInterval
    let reportsByType: [ContentReport.ContentType: Int]
    let reportsByReason: [ContentReport.ReportReason: Int]
    let moderatorActions: [ModeratorAction]
    let bannedUsers: [BannedUser]
    
    struct ModeratorAction: Codable, Identifiable {
        let id: String
        let moderatorId: String
        let actionType: ActionType
        let contentType: ContentReport.ContentType
        let timestamp: Date
        let reason: String
        
        enum ActionType: String, Codable {
            case delete
            case dismiss
            case ban
            case warn
            case restore
        }
    }
    
    struct BannedUser: Codable, Identifiable {
        let id: String
        let userId: String
        let reason: String
        let bannedBy: String
        let bannedAt: Date
        let expiresAt: Date?
        let isPermenant: Bool
    }
} 