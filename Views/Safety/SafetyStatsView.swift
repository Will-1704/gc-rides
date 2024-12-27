import SwiftUI
import Charts

struct SafetyStatsView: View {
    @StateObject private var viewModel = SafetyStatsViewModel()
    
    var body: some View {
        List {
            // Safety Score
            Section {
                VStack(spacing: 16) {
                    CircularProgressView(
                        progress: viewModel.safetyScore / 100,
                        label: "\(Int(viewModel.safetyScore))"
                    )
                    .frame(height: 200)
                    
                    HStack {
                        StatCard(
                            title: "Safe Rides",
                            value: viewModel.safeRidesCount.formatted(),
                            trend: .up
                        )
                        
                        StatCard(
                            title: "Avg Rating",
                            value: viewModel.averageRating.formatted(".1"),
                            trend: .neutral
                        )
                    }
                }
            }
            
            // Safety Metrics
            Section(header: Text("Safety Metrics")) {
                Chart(viewModel.monthlyMetrics) { metric in
                    LineMark(
                        x: .value("Month", metric.date),
                        y: .value("Score", metric.safetyScore)
                    )
                    .foregroundStyle(.green)
                    
                    PointMark(
                        x: .value("Month", metric.date),
                        y: .value("Score", metric.safetyScore)
                    )
                    .foregroundStyle(.green)
                }
                .frame(height: 200)
            }
            
            // Safety Achievements
            Section(header: Text("Achievements")) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementRow(achievement: achievement)
                }
            }
            
            // Safety Tips
            Section(header: Text("Safety Tips")) {
                ForEach(viewModel.safetyTips) { tip in
                    SafetyTipRow(tip: tip)
                }
            }
        }
        .navigationTitle("Safety Report")
        .refreshable {
            await viewModel.loadData()
        }
    }
} 