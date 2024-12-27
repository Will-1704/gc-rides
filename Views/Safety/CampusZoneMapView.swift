import SwiftUI
import MapKit

struct CampusZoneMapView: View {
    @StateObject private var viewModel = CampusZoneViewModel()
    @State private var region = MKCoordinateRegion()
    @State private var selectedZone: CampusZone?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: viewModel.zones) { zone in
                MapAnnotation(coordinate: calculateZoneCenter(zone.coordinates)) {
                    ZoneMarker(zone: zone, isSelected: selectedZone?.id == zone.id) {
                        selectedZone = zone
                    }
                }
            }
            .preferredColorScheme(colorScheme)
            .overlay(alignment: .top) {
                SafetyLevelLegend()
                    .background(AppColor.cardBackground.opacity(0.9))
                    .padding()
            }
            
            if let zone = selectedZone {
                VStack {
                    Spacer()
                    ZoneDetailCard(zone: zone)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                FilterButton(filters: $viewModel.activeFilters)
                
                Button {
                    viewModel.centerOnUser()
                } label: {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            .padding()
        }
    }
}

struct ZoneMarker: View {
    let zone: CampusZone
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(zone.safetyLevel.color))
                .frame(width: isSelected ? 44 : 32, height: isSelected ? 44 : 32)
                .overlay(
                    Image(systemName: zone.type.icon)
                        .foregroundColor(.white)
                )
                .shadow(radius: isSelected ? 3 : 1)
        }
        .animation(.spring(), value: isSelected)
    }
} 