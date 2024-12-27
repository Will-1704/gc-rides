import Foundation

enum ModeratorPrivilege: String, Codable {
    case deleteMessages = "delete_messages"
    case deleteReviews = "delete_reviews"
    case banUsers = "ban_users"
    case manageDrivers = "manage_drivers"
    case viewAnalytics = "view_analytics"
    case manageReports = "manage_reports"
}

enum ModeratorRole: String, Codable {
    case admin
    case moderator
    case supportAgent
    
    var privileges: Set<ModeratorPrivilege> {
        switch self {
        case .admin:
            return Set(ModeratorPrivilege.allCases)
        case .moderator:
            return [.deleteMessages, .deleteReviews, .manageReports]
        case .supportAgent:
            return [.deleteMessages, .manageReports]
        }
    }
}

struct ModeratorStatus: Codable {
    let role: ModeratorRole
    let assignedDate: Date
    let assignedBy: String
    let isActive: Bool
}

// Extension to User model
extension User {
    var moderatorStatus: ModeratorStatus?
    
    func hasPrivilege(_ privilege: ModeratorPrivilege) -> Bool {
        guard let status = moderatorStatus, status.isActive else { return false }
        return status.role.privileges.contains(privilege)
    }
} 