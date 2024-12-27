import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        // Implement networking logic
        // For now, return mock data
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
} 