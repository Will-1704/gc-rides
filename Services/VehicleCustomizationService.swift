import Foundation
import Combine

class VehicleCustomizationService {
    static let shared = VehicleCustomizationService()
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func updateCustomization(
        _ customization: VehicleIcon.Customization
    ) -> AnyPublisher<VehicleIcon, Error> {
        guard let user = AuthenticationManager.shared.currentUser else {
            return Fail(error: AuthenticationError.notAuthenticated).eraseToAnyPublisher()
        }
        
        let body = try? JSONEncoder().encode(customization)
        return networkService.request(
            "/drivers/\(user.id)/vehicle/customization",
            method: "PUT",
            body: body
        )
    }
    
    func unlockAccessory(_ accessory: VehicleIcon.Customization.Accessory) -> AnyPublisher<Void, Error> {
        guard let user = AuthenticationManager.shared.currentUser else {
            return Fail(error: AuthenticationError.notAuthenticated).eraseToAnyPublisher()
        }
        
        return networkService.request(
            "/drivers/\(user.id)/vehicle/accessories/\(accessory.rawValue)",
            method: "POST"
        )
    }
} 