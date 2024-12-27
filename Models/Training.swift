import Foundation

struct TrainingModule: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: ModuleType
    let requiredFor: [DriverTier]
    let estimatedDuration: TimeInterval
    let expiresAfter: TimeInterval? // Optional expiration period
    let prerequisites: [String]? // IDs of required modules
    let reward: Reward?
    
    enum ModuleType: String, Codable {
        case safety
        case service
        case policy
        case vehicle
        case accessibility
        case advanced
        case specialization
    }
    
    enum DriverTier: String, Codable {
        case newDriver
        case standard
        case premium
        case specialized
    }
    
    struct Reward: Codable {
        let type: RewardType
        let value: Double
        
        enum RewardType: String, Codable {
            case bonus
            case rateMultiplier
            case priorityDispatch
        }
    }
}

struct TrainingProgress: Codable {
    let moduleId: String
    let userId: String
    let startedAt: Date
    let completedAt: Date?
    let status: Status
    let score: Int?
    let attempts: Int
    let certificateId: String?
    let expiresAt: Date?
    
    enum Status: String, Codable {
        case notStarted
        case inProgress
        case completed
        case failed
        case expired
    }
}

struct Certificate: Identifiable, Codable {
    let id: String
    let userId: String
    let moduleId: String
    let issuedAt: Date
    let expiresAt: Date?
    let status: Status
    let achievements: [Achievement]
    
    enum Status: String, Codable {
        case active
        case expired
        case revoked
    }
    
    struct Achievement: Codable {
        let title: String
        let description: String
        let awardedAt: Date
    }
} 