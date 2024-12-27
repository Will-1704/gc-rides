import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://localhost:8000"  // Change this to your server URL
    
    private var defaultHeaders: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if let token = AuthenticationManager.shared.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    func request<T: Codable>(_ endpoint: String,
                            method: String = "GET",
                            body: Data? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = defaultHeaders
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw NetworkError.unauthorized
                default:
                    throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
} 