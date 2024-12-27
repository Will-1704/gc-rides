import Foundation
import CoreLocation

struct RouteDeviation {
    let distance: Double // in meters
    let timestamp: Date
    let location: CLLocationCoordinate2D
} 