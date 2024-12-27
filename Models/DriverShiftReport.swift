import Foundation

struct DriverShiftReport: Codable {
    let shiftId: String
    let driverId: String
    let startTime: Date
    let endTime: Date
    
    // Trip Statistics
    let totalTrips: Int
    let totalPassengers: Int
    let totalDistance: Double // in miles
    let totalDriveTime: TimeInterval
    let totalIdleTime: TimeInterval
    
    // Financial Data
    let grossEarnings: Double
    let tips: Double
    let bonuses: Double
    let estimatedGasCost: Double
    let estimatedNetEarnings: Double
    
    // Vehicle Data
    let vehicleMPG: Double
    let estimatedGasUsed: Double // in gallons
    let currentGasPrice: Double
    
    // Performance Metrics
    let averageRating: Double
    let acceptanceRate: Double
    let cancellationRate: Double
    
    // Popular Areas
    let topPickupLocations: [LocationSummary]
    let topDropoffLocations: [LocationSummary]
    
    struct LocationSummary: Codable {
        let area: String
        let count: Int
        let averageEarnings: Double
    }
    
    var fuelEfficiency: Double {
        grossEarnings / estimatedGasCost
    }
    
    var earningsPerHour: Double {
        let hours = totalDriveTime / 3600
        return grossEarnings / hours
    }
    
    var earningsPerMile: Double {
        grossEarnings / totalDistance
    }
} 