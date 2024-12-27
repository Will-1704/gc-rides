import Foundation
import Combine

class ModerationService {
    static let shared = ModerationService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func deleteMessage(_ messageId: String, reason: String) -> AnyPublisher<Void, Error> {
        guard let currentUser = AuthenticationManager.shared.currentUser,
              currentUser.hasPrivilege(.deleteMessages) else {
            return Fail(error: ModerationError.unauthorized).eraseToAnyPublisher()
        }
        
        let body = try? JSONEncoder().encode(DeleteMessageRequest(
            messageId: messageId,
            reason: reason,
            moderatorId: currentUser.id
        ))
        
        return networkService.request("/moderation/messages/\(messageId)",
                                   method: "DELETE",
                                   body: body)
    }
    
    func deleteReview(_ reviewId: String, reason: String) -> AnyPublisher<Void, Error> {
        guard let currentUser = AuthenticationManager.shared.currentUser,
              currentUser.hasPrivilege(.deleteReviews) else {
            return Fail(error: ModerationError.unauthorized).eraseToAnyPublisher()
        }
        
        let body = try? JSONEncoder().encode(DeleteReviewRequest(
            reviewId: reviewId,
            reason: reason,
            moderatorId: currentUser.id
        ))
        
        return networkService.request("/moderation/reviews/\(reviewId)",
                                   method: "DELETE",
                                   body: body)
    }
    
    func reportContent(_ report: ContentReport) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(report)
        return networkService.request("/moderation/reports", method: "POST", body: body)
    }
}

enum ModerationError: LocalizedError {
    case unauthorized
    case contentNotFound
    case alreadyModerated
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "You don't have permission to perform this action"
        case .contentNotFound:
            return "The content you're trying to moderate no longer exists"
        case .alreadyModerated:
            return "This content has already been moderated"
        }
    }
}

struct ContentReport: Codable {
    let contentType: ContentType
    let contentId: String
    let reporterId: String
    let reason: ReportReason
    let description: String
    let timestamp: Date
    
    enum ContentType: String, Codable {
        case message
        case review
        case user
    }
    
    enum ReportReason: String, Codable {
        case inappropriate
        case spam
        case harassment
        case falseInformation
        case other
    }
} 