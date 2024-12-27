import Foundation
import Combine

class BadgeService {
    static let shared = BadgeService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func issueBadge(
        to userId: String,
        type: DriverBadge.BadgeType,
        reason: String? = nil
    ) -> AnyPublisher<DriverBadge, Error> {
        guard let currentUser = AuthenticationManager.shared.currentUser,
              currentUser.hasPrivilege(.manageBadges) else {
            return Fail(error: ModerationError.unauthorized).eraseToAnyPublisher()
        }
        
        let request = BadgeRequest(
            type: type,
            reason: reason,
            issuedBy: currentUser.id
        )
        
        let body = try? JSONEncoder().encode(request)
        return networkService.request(
            "/users/\(userId)/badges",
            method: "POST",
            body: body
        )
    }
    
    func revokeBadge(
        _ badgeId: String,
        from userId: String,
        reason: String
    ) -> AnyPublisher<Void, Error> {
        guard let currentUser = AuthenticationManager.shared.currentUser,
              currentUser.hasPrivilege(.manageBadges) else {
            return Fail(error: ModerationError.unauthorized).eraseToAnyPublisher()
        }
        
        let body = try? JSONEncoder().encode(["reason": reason])
        return networkService.request(
            "/users/\(userId)/badges/\(badgeId)",
            method: "DELETE",
            body: body
        )
    }
}

private struct BadgeRequest: Codable {
    let type: DriverBadge.BadgeType
    let reason: String?
    let issuedBy: String
} 