import Foundation
import CoreLocation

class DriverRankingEngine {
    struct RankedDriver {
        let driver: User
        let score: Double
        let distance: Double // in miles
        let estimatedArrivalTime: TimeInterval
    }
    
    // Weighting factors for different ranking criteria
    private struct Weights {
        static let rating = 0.35
        static let distance = 0.25
        static let responseTime = 0.15
        static let completionRate = 0.15
        static let experienceScore = 0.10
        
        // Penalty factors
        static let cancellationPenalty = 0.2
        static let lowRatingPenalty = 0.3
    }
    
    func rankDrivers(
        for request: RideRequest,
        availableDrivers: [User],
        completion: @escaping ([RankedDriver]) -> Void
    ) {
        let pickup = CLLocation(
            latitude: request.pickup.latitude,
            longitude: request.pickup.longitude
        )
        
        let rankedDrivers = availableDrivers.map { driver -> RankedDriver in
            let driverLocation = CLLocation(
                latitude: driver.currentLocation?.latitude ?? 0,
                longitude: driver.currentLocation?.longitude ?? 0
            )
            
            let distance = driverLocation.distance(from: pickup) * 0.000621371 // Convert to miles
            let score = calculateScore(for: driver, distance: distance)
            
            return RankedDriver(
                driver: driver,
                score: score,
                distance: distance,
                estimatedArrivalTime: calculateArrivalTime(distance: distance)
            )
        }
        
        // Sort by score in descending order
        let sortedDrivers = rankedDrivers.sorted { $0.score > $1.score }
        completion(sortedDrivers)
    }
    
    private func calculateScore(for driver: User, distance: Double) -> Double {
        // Rating Score (0-5)
        let ratingScore = driver.rating
        
        // Distance Score (inverse relationship: closer = better)
        let distanceScore = max(0, 5 - distance)
        
        // Response Time Score
        let responseScore = calculateResponseScore(driver.averageResponseTime)
        
        // Completion Rate Score
        let completionScore = Double(driver.completedRides) / Double(driver.totalRides) * 5
        
        // Experience Score
        let experienceScore = calculateExperienceScore(
            completedRides: driver.ridesCompleted,
            daysActive: driver.daysActive
        )
        
        // Calculate weighted score
        var finalScore = (
            ratingScore * Weights.rating +
            distanceScore * Weights.distance +
            responseScore * Weights.responseTime +
            completionScore * Weights.completionRate +
            experienceScore * Weights.experienceScore
        )
        
        // Apply penalties
        if driver.cancellationRate > 0.1 { // More than 10% cancellation rate
            finalScore *= (1 - Weights.cancellationPenalty)
        }
        
        if driver.rating < 4.0 {
            finalScore *= (1 - Weights.lowRatingPenalty)
        }
        
        return finalScore
    }
    
    private func calculateResponseScore(_ responseTime: TimeInterval) -> Double {
        // Convert response time to a 0-5 score
        // Assuming ideal response time is under 30 seconds
        let maxResponseTime: TimeInterval = 300 // 5 minutes
        let score = 5 * (1 - min(responseTime / maxResponseTime, 1))
        return score
    }
    
    private func calculateExperienceScore(completedRides: Int, daysActive: Int) -> Double {
        // Calculate experience score based on rides completed and time active
        let ridesScore = min(Double(completedRides) / 100, 5) // Max score at 100 rides
        let timeScore = min(Double(daysActive) / 30, 5) // Max score at 30 days
        return (ridesScore + timeScore) / 2
    }
    
    private func calculateArrivalTime(distance: Double) -> TimeInterval {
        // Rough estimate: 3 minutes per mile plus 2 minutes base time
        return TimeInterval(distance * 180 + 120)
    }
} 