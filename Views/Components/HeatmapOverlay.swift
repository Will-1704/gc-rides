import SwiftUI
import MapKit

struct HeatmapOverlay: UIViewRepresentable {
    let data: [EarningsAnalyticsViewModel.LocationHeatData]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Create heat map overlay
        let points = data.map { MKMapPoint($0.coordinate) }
        let weights = data.map { Float($0.intensity) }
        
        if let overlay = HeatMapOverlay(points: points, weights: weights) {
            mapView.addOverlay(overlay)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let heatMapOverlay = overlay as? HeatMapOverlay {
                return HeatMapRenderer(overlay: heatMapOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

class HeatMapOverlay: MKOverlay {
    let points: [MKMapPoint]
    let weights: [Float]
    
    init?(points: [MKMapPoint], weights: [Float]) {
        guard points.count == weights.count, !points.isEmpty else { return nil }
        self.points = points
        self.weights = weights
        
        var rect = MKMapRect.null
        points.forEach { point in
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            rect = rect.union(pointRect)
        }
        self.boundingMapRect = rect.insetBy(dx: -1000, dy: -1000)
    }
    
    var coordinate: CLLocationCoordinate2D {
        let center = boundingMapRect.mid
        return MKCoordinateForMapPoint(center)
    }
}

class HeatMapRenderer: MKOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let overlay = overlay as? HeatMapOverlay else { return }
        
        let rect = self.rect(for: mapRect)
        let radius = 50.0 / zoomScale
        
        context.setAlpha(0.5)
        
        for (point, weight) in zip(overlay.points, overlay.weights) {
            let pointRect = self.rect(for: MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
            let center = CGPoint(x: pointRect.midX, y: pointRect.midY)
            
            let colors = [
                CGColor(red: 0, green: 0, blue: 1, alpha: 0),
                CGColor(red: 1, green: 0, blue: 0, alpha: Double(weight))
            ]
            
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 1]
            )!
            
            context.drawRadialGradient(
                gradient,
                startCenter: center,
                startRadius: 0,
                endCenter: center,
                endRadius: radius,
                options: .drawsBeforeStartLocation
            )
        }
    }
} 