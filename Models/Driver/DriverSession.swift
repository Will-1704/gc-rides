import Foundation
import CoreLocation

struct DriverSession: Identifiable, Codable {
    let id: String
    let driverId: String
    let startTime: Date
    let endTime: Date?
    let vehicle: VehicleDetails
    let pricing: PricingModel
    let status: SessionStatus
    let currentLocation: CLLocationCoordinate2D?
    let currentCapacity: Int
    let totalRides: Int
    let totalEarnings: Double
    
    enum SessionStatus: String, Codable {
        case active
        case onRide
        case paused
        case ended
    }
    
    struct PricingModel: Codable {
        let baseRate: Double
        let customRates: [TimeBasedRate]?
        
        struct TimeBasedRate: Codable {
            let startTime: Date
            let endTime: Date
            let rate: Double
        }
        
        func calculateRate(at time: Date = Date()) -> Double {
            if let customRate = customRates?.first(where: { rate in
                time >= rate.startTime && time <= rate.endTime
            }) {
                return customRate.rate
            }
            return baseRate
        }
    }
} 