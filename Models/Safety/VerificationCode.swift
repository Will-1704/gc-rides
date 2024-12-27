import Foundation

struct VerificationCode: Codable {
    let code: String
    let expiresAt: Date
    let rideId: String
    let type: CodeType
    
    enum CodeType: String, Codable {
        case rideStart
        case nightMode
        case emergency
        
        var length: Int {
            switch self {
            case .rideStart: return 4
            case .nightMode: return 6
            case .emergency: return 8
            }
        }
    }
    
    static func generate(for type: CodeType) -> VerificationCode {
        let code = String((0..<type.length).map { _ in
            String(Int.random(in: 0...9))
        }.joined())
        
        return VerificationCode(
            code: code,
            expiresAt: Date().addingTimeInterval(300), // 5 minutes
            rideId: UUID().uuidString,
            type: type
        )
    }
} 