import SwiftUI
import Charts

struct ModerationAnalyticsView: View {
    @StateObject private var viewModel = ModerationAnalyticsViewModel()
    @State private var timeRange: TimeRange = .week
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Cards
                LazyVGrid(columns: [.init(), .init()], spacing: 16) {
                    MetricCard(
                        title: "Total Reports",
                        value: viewModel.analytics.totalReports,
                        trend: viewModel.reportsTrend
                    )
                    
                    MetricCard(
                        title: "Avg Response Time",
                        value: viewModel.analytics.averageResponseTime,
                        trend: viewModel.responseTrend,
                        format: .duration
                    )
                    
                    MetricCard(
                        title: "Active Bans",
                        value: viewModel.analytics.bannedUsers.count,
                        trend: viewModel.bansTrend
                    )
                    
                    MetricCard(
                        title: "Resolution Rate",
                        value: Double(viewModel.analytics.resolvedReports) / 
                               Double(viewModel.analytics.totalReports),
                        trend: viewModel.resolutionTrend,
                        format: .percentage
                    )
                }
                
                // Reports by Type Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reports by Type")
                        .font(.headline)
                    
                    Chart(viewModel.reportsByTypeData) { data in
                        SectorMark(
                            angle: .value("Count", data.count),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Type", data.type))
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                // Recent Actions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Actions")
                        .font(.headline)
                    
                    ForEach(viewModel.recentActions) { action in
                        ModeratorActionRow(action: action)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Analytics")
        .onChange(of: timeRange) { newValue in
            Task {
                await viewModel.loadAnalytics(timeRange: newValue)
            }
        }
    }
}

struct ModeratorActionRow: View {
    let action: ModerationAnalytics.ModeratorAction
    
    var body: some View {
        HStack {
            Circle()
                .fill(actionColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading) {
                Text(actionTitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(action.timestamp.timeAgoDisplay())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(action.reason)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
    
    private var actionColor: Color {
        switch action.actionType {
        case .delete: return .red
        case .dismiss: return .gray
        case .ban: return .purple
        case .warn: return .yellow
        case .restore: return .green
        }
    }
    
    private var actionTitle: String {
        "\(action.actionType.rawValue.capitalized) \(action.contentType.rawValue)"
    }
} 