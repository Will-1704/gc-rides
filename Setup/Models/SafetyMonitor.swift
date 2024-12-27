import Foundation
import Combine

class SafetyMonitor: Identifiable, Hashable {
    let id: String
    let ride: Ride
    
    let routePublisher = PassthroughSubject<RouteDeviation, Never>()
    let speedPublisher = PassthroughSubject<Double, Never>()
    let stopDurationPublisher = PassthroughSubject<TimeInterval, Never>()
    let batteryPublisher = PassthroughSubject<Double, Never>()
    
    init(ride: Ride) {
        self.id = UUID().uuidString
        self.ride = ride
    }
    
    static func == (lhs: SafetyMonitor, rhs: SafetyMonitor) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 