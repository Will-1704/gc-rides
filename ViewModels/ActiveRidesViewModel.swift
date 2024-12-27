import SwiftUI
import MapKit
import Combine

class ActiveRidesViewModel: ObservableObject {
    @Published var activeRides: [ActiveRide] = []
    @Published var selectedRide: ActiveRide?
    @Published var showRideRequest = false
    @Published var isDriver = false
    @Published var isDriverMode = false
    
    private var cancellables = Set<AnyCancellable>()
    private let rideService: RideService
    
    init(rideService: RideService = .shared) {
        self.rideService = rideService
        setupSubscriptions()
        checkDriverStatus()
    }
    
    private func setupSubscriptions() {
        rideService.activeRidesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rides in
                self?.activeRides = rides
            }
            .store(in: &cancellables)
    }
    
    private func checkDriverStatus() {
        UserService.shared.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] user in
                self?.isDriver = user.isDriver
            }
            .store(in: &cancellables)
    }
    
    func toggleDriverMode() {
        isDriverMode.toggle()
        rideService.updateDriverStatus(isActive: isDriverMode)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error updating driver status: \(error)")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
} 