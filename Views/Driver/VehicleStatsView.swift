import SwiftUI
import Charts

struct VehicleStatsView: View {
    @StateObject private var viewModel = VehicleStatsViewModel()
    
    var body: some View {
        List {
            // Performance Metrics
            Section(header: Text("Performance")) {
                VStack(spacing: 20) {
                    Chart(viewModel.performanceData) { data in
                        LineMark(
                            x: .value("Date", data.date),
                            y: .value("MPG", data.mpg)
                        )
                        .foregroundStyle(.green)
                        
                        LineMark(
                            x: .value("Date", data.date),
                            y: .value("Cost", data.costPerMile)
                        )
                        .foregroundStyle(.blue)
                    }
                    .frame(height: 200)
                    
                    HStack {
                        StatCard(
                            title: "Avg MPG",
                            value: viewModel.averageMPG.formatted(),
                            trend: viewModel.mpgTrend
                        )
                        
                        StatCard(
                            title: "Cost/Mile",
                            value: viewModel.costPerMile.formatted(.currency(code: "USD")),
                            trend: viewModel.costTrend
                        )
                    }
                }
            }
            
            // Maintenance
            Section(header: Text("Maintenance")) {
                ForEach(viewModel.maintenanceItems) { item in
                    MaintenanceRow(item: item)
                }
            }
            
            // Vehicle Rating
            Section(header: Text("Vehicle Rating")) {
                VehicleRatingView(stats: viewModel.vehicleStats)
            }
        }
        .navigationTitle("Vehicle Statistics")
        .refreshable {
            await viewModel.loadData()
        }
    }
} 