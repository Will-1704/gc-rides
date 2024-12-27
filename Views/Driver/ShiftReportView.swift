import SwiftUI
import Charts

struct ShiftReportView: View {
    let report: DriverShiftReport
    @State private var showEmailSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with main earnings
                VStack(spacing: 8) {
                    Text("Shift Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(report.estimatedNetEarnings.formatted(.currency(code: "USD")))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("\(formatDuration(report.endTime.timeIntervalSince(report.startTime)))")
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Earnings Breakdown
                EarningsBreakdownCard(report: report)
                
                // Trip Statistics
                TripStatisticsCard(report: report)
                
                // Fuel Analysis
                FuelAnalysisCard(report: report)
                
                // Performance Metrics
                PerformanceMetricsCard(report: report)
                
                // Popular Areas
                PopularAreasCard(report: report)
                
                // Action Buttons
                HStack(spacing: 20) {
                    Button {
                        showEmailSheet = true
                    } label: {
                        Label("Email Report", systemImage: "envelope")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    ShareLink(
                        item: generateReportText(report),
                        preview: SharePreview("Shift Report")
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .sheet(isPresented: $showEmailSheet) {
            EmailReportView(report: report)
        }
    }
    
    private func generateReportText(_ report: DriverShiftReport) -> String {
        // Generate a plain text version of the report for sharing
        return """
        Shift Summary
        \(report.startTime.formatted()) - \(report.endTime.formatted())
        
        Net Earnings: \(report.estimatedNetEarnings.formatted(.currency(code: "USD")))
        Total Trips: \(report.totalTrips)
        Distance: \(report.totalDistance.formatted()) miles
        Drive Time: \(formatDuration(report.totalDriveTime))
        
        Gas Used: \(report.estimatedGasUsed.formatted()) gallons
        Gas Cost: \(report.estimatedGasCost.formatted(.currency(code: "USD")))
        
        Average Rating: ⭐️ \(report.averageRating.formatted())
        """
    }
}

// Supporting view components...
struct EarningsBreakdownCard: View {
    let report: DriverShiftReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Earnings Breakdown")
                .font(.headline)
            
            Chart {
                BarMark(
                    x: .value("Category", "Base"),
                    y: .value("Amount", report.grossEarnings - report.tips - report.bonuses)
                )
                .foregroundStyle(.blue)
                
                BarMark(
                    x: .value("Category", "Tips"),
                    y: .value("Amount", report.tips)
                )
                .foregroundStyle(.green)
                
                BarMark(
                    x: .value("Category", "Bonuses"),
                    y: .value("Amount", report.bonuses)
                )
                .foregroundStyle(.orange)
            }
            .frame(height: 200)
            
            Divider()
            
            HStack {
                Text("Estimated Gas Cost")
                Spacer()
                Text("-\(report.estimatedGasCost.formatted(.currency(code: "USD")))")
                    .foregroundColor(.red)
            }
            
            HStack {
                Text("Net Earnings")
                    .fontWeight(.bold)
                Spacer()
                Text(report.estimatedNetEarnings.formatted(.currency(code: "USD")))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 