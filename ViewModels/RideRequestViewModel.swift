import Foundation
import Combine

class RideRequestViewModel: ObservableObject {
    @Published var pickupLocation = ""
    @Published var destination = ""
    @Published var partySize = 1
    @Published var notes = ""
    
    private let rideService: RideService
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        !pickupLocation.isEmpty && !destination.isEmpty
    }
    
    init(rideService: RideService = .shared) {
        self.rideService = rideService
    }
    
    func submitRequest() {
        let request = RideRequest(
            pickupLocation: pickupLocation,
            destination: destination,
            partySize: partySize,
            notes: notes
        )
        
        rideService.createRideRequest(request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error submitting ride request: \(error)")
                }
            } receiveValue: { _ in
                // Request submitted successfully
            }
            .store(in: &cancellables)
    }
} 