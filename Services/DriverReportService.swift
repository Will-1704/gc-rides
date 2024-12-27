import Foundation
import Combine

class DriverReportService {
    static let shared = DriverReportService()
    private let networkService: NetworkService
    private let emailService: EmailService
    
    init(networkService: NetworkService = .shared,
         emailService: EmailService = .shared) {
        self.networkService = networkService
        self.emailService = emailService
    }
    
    func generateShiftReport(shiftId: String) async throws -> DriverShiftReport {
        let report = try await networkService.request(
            "/driver/shifts/\(shiftId)/report",
            method: "GET"
        ).decoded() as DriverShiftReport
        
        if UserDefaults.standard.bool(forKey: "autoEmailReports") {
            await emailShiftReport(report)
        }
        
        return report
    }
    
    func emailShiftReport(_ report: DriverShiftReport) async {
        guard let driver = AuthenticationManager.shared.currentUser else { return }
        
        let html = generateReportHTML(report)
        let subject = "Shift Summary - \(report.startTime.formatted(date: .abbreviated, time: .shortened))"
        
        do {
            try await emailService.sendEmail(
                to: driver.email,
                subject: subject,
                html: html
            )
        } catch {
            print("Failed to send report email: \(error)")
        }
    }
    
    private func generateReportHTML(_ report: DriverShiftReport) -> String {
        // Create a professional HTML template for the report
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { text-align: center; padding: 20px; background: #f8f9fa; }
                .metric { margin: 10px 0; }
                .metric-label { color: #666; }
                .metric-value { font-weight: bold; }
                .section { margin: 20px 0; }
                .highlight { color: #007bff; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Shift Summary</h1>
                    <p>\(report.startTime.formatted()) - \(report.endTime.formatted())</p>
                </div>
                
                <div class="section">
                    <h2>Earnings</h2>
                    <div class="metric">
                        <span class="metric-label">Gross Earnings:</span>
                        <span class="metric-value">\(report.grossEarnings.formatted(.currency(code: "USD")))</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Tips:</span>
                        <span class="metric-value">\(report.tips.formatted(.currency(code: "USD")))</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Estimated Gas Cost:</span>
                        <span class="metric-value">\(report.estimatedGasCost.formatted(.currency(code: "USD")))</span>
                    </div>
                    <div class="metric highlight">
                        <span class="metric-label">Estimated Net Earnings:</span>
                        <span class="metric-value">\(report.estimatedNetEarnings.formatted(.currency(code: "USD")))</span>
                    </div>
                </div>
                
                <div class="section">
                    <h2>Trip Statistics</h2>
                    <div class="metric">
                        <span class="metric-label">Total Trips:</span>
                        <span class="metric-value">\(report.totalTrips)</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Total Distance:</span>
                        <span class="metric-value">\(report.totalDistance.formatted()) miles</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Drive Time:</span>
                        <span class="metric-value">\(formatDuration(report.totalDriveTime))</span>
                    </div>
                </div>
                
                <div class="section">
                    <h2>Performance</h2>
                    <div class="metric">
                        <span class="metric-label">Average Rating:</span>
                        <span class="metric-value">⭐️ \(report.averageRating.formatted(.number.precision(.fractionLength(1))))</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Earnings per Hour:</span>
                        <span class="metric-value">\(report.earningsPerHour.formatted(.currency(code: "USD")))</span>
                    </div>
                    <div class="metric">
                        <span class="metric-label">Earnings per Mile:</span>
                        <span class="metric-value">\(report.earningsPerMile.formatted(.currency(code: "USD")))</span>
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
    }
    
    private func formatDuration(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
} 