import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let rideId: String
    let reviewerId: String
    let revieweeId: String
    let rating: Int
    let comment: String?
    let timestamp: Date
    let type: ReviewType
    let flags: Set<ReviewFlag>
    
    enum ReviewType: String, Codable {
        case driver
        case rider
    }
    
    enum ReviewFlag: String, Codable {
        case inappropriate
        case spam
        case falseInformation
    }
    
    var isValid: Bool {
        flags.isEmpty && rating >= 1 && rating <= 5
    }
}

struct ReviewSummary: Codable {
    let userId: String
    let averageRating: Double
    let totalReviews: Int
    let recentReviews: [Review]
    let ratingDistribution: [Int: Int] // Rating -> Count
    
    var formattedRating: String {
        String(format: "%.1f", averageRating)
    }
} 