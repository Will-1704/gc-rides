import Foundation
import Combine

class AuditLogService {
    static let shared = AuditLogService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func logAction(_ action: ModerationAnalytics.ModeratorAction) {
        Task {
            do {
                let body = try JSONEncoder().encode(action)
                try await networkService.request(
                    "/moderation/audit",
                    method: "POST",
                    body: body
                ).value
                
                NotificationCenter.default.post(
                    name: .moderationActionLogged,
                    object: action
                )
            } catch {
                print("Failed to log moderation action: \(error)")
            }
        }
    }
    
    func getAuditLogs(
        startDate: Date,
        endDate: Date
    ) -> AnyPublisher<[ModerationAnalytics.ModeratorAction], Error> {
        let queryItems = [
            URLQueryItem(name: "start", value: ISO8601DateFormatter().string(from: startDate)),
            URLQueryItem(name: "end", value: ISO8601DateFormatter().string(from: endDate))
        ]
        
        return networkService.request(
            "/moderation/audit",
            queryItems: queryItems
        )
    }
} 