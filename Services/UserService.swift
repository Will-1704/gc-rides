import Foundation
import Combine

class UserService {
    static let shared = UserService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func getCurrentUser() -> AnyPublisher<User, Error> {
        networkService.request("/users/me")
    }
    
    func updateProfile(update: ProfileUpdate) -> AnyPublisher<User, Error> {
        let body = try? JSONEncoder().encode(update)
        return networkService.request("/users/me", method: "PATCH", body: body)
    }
    
    func uploadProfileImage(imageData: Data) -> AnyPublisher<ImageUploadResponse, Error> {
        // Implement multipart form data upload
        fatalError("Not implemented")
    }
}

struct ProfileUpdate: Codable {
    var firstName: String?
    var lastName: String?
    var profilePicture: String?
}

struct ImageUploadResponse: Codable {
    let url: String
} 