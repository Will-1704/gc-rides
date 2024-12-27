import Foundation
import CoreLocation

struct MockData {
    static let messages: [Message] = [
        Message(
            id: "1",
            userId: "test-id",
            text: "Looking for a ride to downtown",
            timestamp: Date(),
            type: .text
        ),
        Message(
            id: "2",
            userId: "driver-1",
            text: "I can help with that",
            timestamp: Date(),
            type: .text
        )
    ]
    
    static let drivers: [Driver] = [
        Driver(
            id: "driver-1",
            user: User(
                id: "d1",
                email: "driver1@test.com",
                firstName: "John",
                lastName: "Driver",
                profileImageUrl: nil
            ),
            isActive: true,
            vehicle: Driver.VehicleDetails(
                make: "Toyota",
                model: "Camry",
                capacity: 4
            )
        )
    ]
    
    static let safetyQuestions: [SafetyQuestion] = [
        SafetyQuestion(
            id: "1",
            text: "Are you in a safe location?",
            isRequired: true
        ),
        SafetyQuestion(
            id: "2",
            text: "Is the driver following the route?",
            isRequired: true
        )
    ]
} 