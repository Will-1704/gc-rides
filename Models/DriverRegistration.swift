struct VehicleDetails: Codable {
    let make: String
    let model: String
    let year: Int
    let color: String
    let licensePlate: String
    let seatCapacity: Int
    var type: VehicleIcon.VehicleType {
        .determineType(make: make, model: model)
    }
}

struct DriverRegistration: Codable {
    let vehicle: VehicleDetails
    let paymentPreference: PaymentMethod
    let paymentUsername: String
    let driversLicenseNumber: String
    let insuranceProvider: String
    let insurancePolicyNumber: String
} 