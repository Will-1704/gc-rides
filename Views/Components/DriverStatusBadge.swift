import SwiftUI

struct DriverStatusBadge: View {
    let isActive: Bool
    let lastActive: Date?
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isActive ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(isActive ? .green : .secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var statusText: String {
        if isActive {
            return "Currently Driving"
        } else if let lastActive = lastActive {
            return "Last drove \(lastActive.timeAgoDisplay())"
        } else {
            return "Inactive"
        }
    }
}

// Add this to DriverInfoSection
struct DrivingSessionInfo: View {
    let session: DrivingSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Driving Session")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading) {
                    Label("\(session.ridesCompleted) rides", systemImage: "car.fill")
                    Label(session.earnings.formatted(.currency(code: "USD")), systemImage: "dollarsign.circle.fill")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                    Text("to")
                    Text(session.endTime.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 