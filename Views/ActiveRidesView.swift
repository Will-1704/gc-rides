import SwiftUI
import MapKit

struct ActiveRidesView: View {
    @StateObject private var viewModel = ActiveRidesViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.0801, longitude: -83.2321), // GCSU coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: viewModel.activeRides) { ride in
                    MapAnnotation(coordinate: ride.coordinate) {
                        RideAnnotationView(ride: ride)
                            .onTapGesture {
                                viewModel.selectedRide = ride
                            }
                    }
                }
                .ignoresSafeArea(edges: .vertical)
                
                VStack {
                    Spacer()
                    
                    if let selectedRide = viewModel.selectedRide {
                        RideDetailCard(ride: selectedRide)
                            .transition(.move(edge: .bottom))
                    }
                    
                    if viewModel.isDriver {
                        StartRideButton(action: viewModel.toggleDriverMode)
                    }
                }
            }
            .navigationTitle("Active Rides")
            .navigationBarItems(trailing: FilterButton())
            .sheet(isPresented: $viewModel.showRideRequest) {
                RideRequestFormView()
            }
        }
    }
}

struct RideDetailCard: View {
    let ride: ActiveRide
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(ride.status.rawValue)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ride.status.color.opacity(0.2))
                    .foregroundColor(ride.status.color)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(ride.estimatedTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                LocationRow(icon: "mappin.circle.fill",
                          color: .red,
                          text: ride.pickup)
                
                LocationRow(icon: "mappin.circle.fill",
                          color: .blue,
                          text: ride.destination)
            }
            
            HStack {
                Button(action: {}) {
                    Label("Message", systemImage: "message.fill")
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Spacer()
                
                Button(action: {}) {
                    Text(ride.status == .pending ? "Accept Ride" : "Complete Ride")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding()
    }
} 