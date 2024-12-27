import SwiftUI
import Charts

struct EarningsDashboardView: View {
    @StateObject private var viewModel = EarningsViewModel()
    @State private var timeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case day = "Today"
        case week = "This Week"
        case month = "This Month"
        case year = "This Year"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Cards
                LazyVGrid(columns: [.init(), .init()], spacing: 16) {
                    EarningsSummaryCard(
                        title: "Total Earnings",
                        amount: viewModel.totalEarnings,
                        trend: viewModel.earningsTrend
                    )
                    
                    EarningsSummaryCard(
                        title: "Total Rides",
                        amount: viewModel.totalRides,
                        trend: viewModel.ridesTrend,
                        format: .number
                    )
                    
                    EarningsSummaryCard(
                        title: "Avg. per Ride",
                        amount: viewModel.averagePerRide,
                        trend: viewModel.avgRideTrend
                    )
                    
                    EarningsSummaryCard(
                        title: "Online Hours",
                        amount: viewModel.totalHours,
                        trend: viewModel.hoursTrend,
                        format: .hours
                    )
                }
                .padding(.horizontal)
                
                // Earnings Chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("Earnings Breakdown")
                        .font(.headline)
                    
                    Picker("Time Range", selection: $timeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Chart(viewModel.earningsData) { data in
                        BarMark(
                            x: .value("Date", data.date),
                            y: .value("Amount", data.amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Recent Sessions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Sessions")
                        .font(.headline)
                    
                    ForEach(viewModel.recentSessions) { session in
                        DrivingSessionCard(session: session)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Earnings")
        .onChange(of: timeRange) { newValue in
            viewModel.loadEarnings(for: newValue)
        }
    }
}

struct EarningsSummaryCard: View {
    let title: String
    let amount: Double
    let trend: Double
    var format: Format = .currency
    
    enum Format {
        case currency, number, hours
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(formattedAmount)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                Text("\(abs(trend), specifier: "%.1f")%")
            }
            .font(.caption)
            .foregroundColor(trend >= 0 ? .green : .red)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var formattedAmount: String {
        switch format {
        case .currency:
            return amount.formatted(.currency(code: "USD"))
        case .number:
            return String(format: "%.0f", amount)
        case .hours:
            let hours = Int(amount)
            let minutes = Int((amount.truncatingRemainder(dividingBy: 1)) * 60)
            return "\(hours)h \(minutes)m"
        }
    }
} 