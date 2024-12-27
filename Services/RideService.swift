import Foundation
import Combine

class RideService {
    static let shared = RideService()
    private let networkService: NetworkService
    private let activeRidesSubject = CurrentValueSubject<[ActiveRide], Never>([])
    
    var activeRidesPublisher: AnyPublisher<[ActiveRide], Never> {
        activeRidesSubject.eraseToAnyPublisher()
    }
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
        setupRideUpdates()
    }
    
    private func setupRideUpdates() {
        // Setup WebSocket connection for real-time updates
        // Update activeRidesSubject when new data arrives
    }
    
    func createRideRequest(_ request: RideRequest) -> AnyPublisher<RideResponse, Error> {
        let body = try? JSONEncoder().encode(request)
        return networkService.request("/rides", method: "POST", body: body)
    }
    
    func updateDriverStatus(isActive: Bool) -> AnyPublisher<DriverStatus, Error> {
        let body = try? JSONEncoder().encode(["isActive": isActive])
        return networkService.request("/drivers/status", method: "POST", body: body)
    }
    
    func acceptRide(rideId: String) -> AnyPublisher<RideResponse, Error> {
        networkService.request("/rides/\(rideId)/accept", method: "POST")
    }
    
    func completeRide(rideId: String) -> AnyPublisher<RideResponse, Error> {
        networkService.request("/rides/\(rideId)/complete", method: "POST")
    }
}

struct RideRequest: Codable {
    let pickupLocation: String
    let destination: String
    let partySize: Int
    let notes: String?
}

struct RideResponse: Codable {
    let id: String
    let status: RideStatus
    let driver: User?
    let rider: User
    let pickup: String
    let destination: String
    let partySize: Int
    let createdAt: Date
}

enum RideStatus: String, Codable {
    case pending
    case accepted
    case inProgress
    case completed
    case cancelled
} 