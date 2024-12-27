import SwiftUI

struct SafetyView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    SafetySettingsView()
                } label: {
                    Label("Safety Settings", systemImage: "shield.fill")
                }
                
                NavigationLink {
                    SafetyAnalyticsView()
                } label: {
                    Label("Safety Analytics", systemImage: "chart.bar.fill")
                }
                
                NavigationLink {
                    CampusZoneMapView()
                } label: {
                    Label("Campus Safety Zones", systemImage: "map.fill")
                }
            }
            .navigationTitle("Safety")
        }
    }
} 