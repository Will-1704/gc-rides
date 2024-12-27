import Foundation
import Combine

enum PaymentMethod: String, CaseIterable, Identifiable {
    case venmo = "Venmo"
    case cashApp = "Cash App"
    case cash = "Cash"
    
    var id: String { rawValue }
}

class DriverRegistrationViewModel: ObservableObject {
    @Published var vehicleMake = ""
    @Published var vehicleModel = ""
    @Published var seatCapacity = 4
    @Published var graduationYear = Calendar.current.year
    @Published var paymentPreference: PaymentMethod = .venmo
    @Published var paymentUsername = ""
    @Published var agreedToTerms = false
    @Published var agreedToSafety = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let driverService: DriverService
    
    var isValid: Bool {
        !vehicleMake.isEmpty &&
        !vehicleModel.isEmpty &&
        (paymentPreference == .cash || !paymentUsername.isEmpty) &&
        agreedToTerms &&
        agreedToSafety
    }
    
    init(driverService: DriverService = .shared) {
        self.driverService = driverService
    }
    
    @MainActor
    func registerAsDriver() async -> Bool {
        let registration = DriverRegistration(
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            seatCapacity: seatCapacity,
            graduationYear: graduationYear,
            paymentPreference: paymentPreference,
            paymentUsername: paymentUsername
        )
        
        do {
            try await driverService.registerDriver(registration)
            return true
        } catch {
            self.error = error.localizedDescription
            return false
        }
    }
} 