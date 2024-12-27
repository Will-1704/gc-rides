import SwiftUI
import MapKit

struct RealTimeLocationView: View {
    let ride: Ride
    @StateObject private var viewModel = RealTimeLocationViewModel()
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: [viewModel.driverLocation, viewModel.destination]) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LocationMarker(type: location.type)
                }
            }
            .ignoresSafeArea()
            
            VStack {
                // ETA Panel
                ETAPanel(
                    timeRemaining: viewModel.estimatedTimeRemaining,
                    distance: viewModel.remainingDistance
                )
                .padding()
                
                Spacer()
                
                // Safety Controls
                SafetyControlPanel(
                    onShareLocation: viewModel.shareLocation,
                    onTriggerSOS: viewModel.triggerSOS
                )
                .padding()
            }
        }
        .overlay(alignment: .topLeading) {
            Button {
                viewModel.centerOnVehicle()
            } label: {
                Image(systemName: "location.fill")
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding()
        }
        .onAppear {
            viewModel.startTracking(ride: ride)
        }
        .onDisappear {
            viewModel.stopTracking()
        }
    }
}

struct LocationMarker: View {
    let type: LocationType
    
    var body: some View {
        Image(systemName: type.icon)
            .font(.title)
            .foregroundColor(type.color)
            .background(
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 44, height: 44)
                    .shadow(radius: 2)
            )
    }
} 