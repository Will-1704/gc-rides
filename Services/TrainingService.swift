import Foundation
import Combine

class TrainingService {
    static let shared = TrainingService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func getRequiredModules() -> AnyPublisher<[TrainingModule], Error> {
        guard let user = AuthenticationManager.shared.currentUser else {
            return Fail(error: AuthenticationError.notAuthenticated).eraseToAnyPublisher()
        }
        
        return networkService.request(
            "/training/required",
            queryItems: [URLQueryItem(name: "userId", value: user.id)]
        )
    }
    
    func getModuleProgress(_ moduleId: String) -> AnyPublisher<TrainingProgress, Error> {
        networkService.request("/training/modules/\(moduleId)/progress")
    }
    
    func startModule(_ moduleId: String) -> AnyPublisher<TrainingProgress, Error> {
        networkService.request(
            "/training/modules/\(moduleId)/start",
            method: "POST"
        )
    }
    
    func submitModuleQuiz(
        moduleId: String,
        answers: [String: String]
    ) -> AnyPublisher<QuizResult, Error> {
        let body = try? JSONEncoder().encode(answers)
        return networkService.request(
            "/training/modules/\(moduleId)/quiz",
            method: "POST",
            body: body
        )
    }
    
    func getCertificates() -> AnyPublisher<[Certificate], Error> {
        networkService.request("/training/certificates")
    }
}

struct QuizResult: Codable {
    let passed: Bool
    let score: Int
    let feedback: [String]
    let certificateId: String?
} 