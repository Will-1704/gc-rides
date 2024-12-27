import SwiftUI

struct RideMapView: View {
    @StateObject private var viewModel: RideMapViewModel
    @State private var selectedDriver: Driver?
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            showsUserLocation: true,
            annotationItems: viewModel.nearbyDrivers) { driver in
            MapAnnotation(coordinate: driver.location.coordinate) {
                VehicleMapMarker(
                    driver: driver,
                    isSelected: selectedDriver?.id == driver.id
                )
                .onTapGesture {
                    withAnimation {
                        selectedDriver = driver
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let driver = selectedDriver {
                DriverInfoCard(driver: driver)
                    .transition(.move(edge: .bottom))
            }
        }
    }
} 