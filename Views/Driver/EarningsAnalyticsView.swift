import SwiftUI
import Charts
import MapKit

struct EarningsAnalyticsView: View {
    @StateObject private var viewModel = EarningsAnalyticsViewModel()
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Time Range Picker
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Earnings Breakdown
                if let breakdown = viewModel.earningsBreakdown {
                    EarningsBreakdownView(breakdown: breakdown)
                }
                
                // Peak Hours Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Peak Hours")
                        .font(.headline)
                    
                    Chart(viewModel.peakHoursData) { data in
                        BarMark(
                            x: .value("Hour", data.hour),
                            y: .value("Earnings", data.averageEarnings)
                        )
                        .foregroundStyle(
                            Color.blue.gradient.opacity(data.demandMultiplier / 2)
                        )
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Location Heatmap
                VStack(alignment: .leading, spacing: 8) {
                    Text("Popular Areas")
                        .font(.headline)
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 33.0801, longitude: -83.2321),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )))
                    .frame(height: 300)
                    .overlay(
                        HeatmapOverlay(data: viewModel.locationHeatmap)
                    )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Performance Metrics
                if let metrics = viewModel.performanceMetrics {
                    PerformanceMetricsView(metrics: metrics)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Earnings Analytics")
        .onChange(of: selectedTimeRange) { newValue in
            viewModel.loadAnalytics(timeRange: newValue)
        }
    }
}

struct EarningsBreakdownView: View {
    let breakdown: EarningsAnalyticsViewModel.EarningsBreakdown
    
    var body: some View {
        VStack(spacing: 16) {
            // Pie Chart for earnings breakdown
            // Implementation details...
            
            // Key metrics
            LazyVGrid(columns: [.init(), .init()], spacing: 16) {
                MetricView(title: "Per Hour", value: breakdown.averagePerHour)
                MetricView(title: "Per Mile", value: breakdown.averagePerMile)
                MetricView(title: "Per Ride", value: breakdown.averagePerRide)
                MetricView(title: "Tips %", value: breakdown.tipPercentage, format: .percent)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 