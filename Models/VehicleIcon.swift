import Foundation
import SwiftUI

struct VehicleIcon: Codable {
    let make: String
    let model: String
    let type: VehicleType
    let year: Int
    
    enum VehicleType: String, Codable {
        case sedan
        case suv
        case van
        case luxury
        case compact
        case truck
        case electric
        
        var iconName: String {
            switch self {
            case .sedan: return "car.side.fill"
            case .suv: return "suv.side.fill"
            case .van: return "van.side.fill"
            case .luxury: return "car.side.luxury.fill"
            case .compact: return "car.side.compact.fill"
            case .truck: return "truck.side.fill"
            case .electric: return "car.side.electric.fill"
            }
        }
        
        static func determineType(make: String, model: String) -> VehicleType {
            // Add common vehicle classifications
            let make = make.lowercased()
            let model = model.lowercased()
            
            // Electric vehicles
            if ["tesla", "leaf", "bolt", "ionic"].contains(where: { make.contains($0) }) {
                return .electric
            }
            
            // Luxury vehicles
            if ["mercedes", "bmw", "audi", "lexus", "porsche"].contains(where: { make.contains($0) }) {
                return .luxury
            }
            
            // SUVs
            if ["suv", "crossover", "rav4", "cr-v", "explorer"].contains(where: { model.contains($0) }) {
                return .suv
            }
            
            // Vans
            if ["sienna", "odyssey", "pacifica", "caravan"].contains(where: { model.contains($0) }) {
                return .van
            }
            
            // Trucks
            if ["f-150", "silverado", "ram", "tundra", "tacoma"].contains(where: { model.contains($0) }) {
                return .truck
            }
            
            // Compact
            if ["civic", "corolla", "sentra", "fit"].contains(where: { model.contains($0) }) {
                return .compact
            }
            
            // Default to sedan
            return .sedan
        }
    }
    
    // Add color support and more customization
    struct Customization: Codable {
        let color: String
        let tint: String?
        let decals: [Decal]?
        let accessories: Set<Accessory>
        
        struct Decal: Codable, Identifiable {
            let id: String
            let type: DecalType
            let position: Position
            
            enum DecalType: String, Codable {
                case stripe
                case logo
                case number
                case custom
            }
            
            enum Position: String, Codable {
                case front, side, rear, roof
            }
        }
        
        enum Accessory: String, Codable {
            case roofRack
            case bikeRack
            case skiRack
            case lightBar
            case wheelUpgrade
            case tintedWindows
        }
    }
    
    // Add more vehicle classifications
    enum VehicleClass: String, Codable {
        case economy
        case standard
        case premium
        case luxury
        case specialty
        
        var rateMultiplier: Double {
            switch self {
            case .economy: return 1.0
            case .standard: return 1.2
            case .premium: return 1.5
            case .luxury: return 2.0
            case .specialty: return 1.8
            }
        }
    }
    
    // Add vehicle statistics
    struct Statistics: Codable {
        let fuelEfficiency: Double // MPG
        let range: Double // Miles
        let cargoCapacity: Double // Cubic feet
        let acceleration: Double // 0-60 time
        let safetyRating: Int // 1-5
        let yearlyMaintenanceCost: Double
    }
} 