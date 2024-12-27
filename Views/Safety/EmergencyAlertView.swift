import SwiftUI
import CoreLocation

struct EmergencyAlertView: View {
    @StateObject private var viewModel = EmergencyAlertViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Emergency Header
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Emergency Alert")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            // Location Status
            LocationStatusView(status: viewModel.locationStatus)
            
            // Emergency Options
            VStack(spacing: 12) {
                EmergencyButton(
                    title: "Contact Police",
                    icon: "phone.circle.fill",
                    color: .blue
                ) {
                    viewModel.contactPolice()
                }
                
                EmergencyButton(
                    title: "Share Location",
                    icon: "location.fill",
                    color: .green
                ) {
                    viewModel.shareLocation()
                }
                
                EmergencyButton(
                    title: "Alert Contacts",
                    icon: "bell.fill",
                    color: .orange
                ) {
                    viewModel.alertContacts()
                }
            }
            .padding()
            
            // Safety Instructions
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    SafetyInstruction(
                        title: "Stay Calm",
                        description: "Find a safe location and stay on the line with emergency services"
                    )
                    
                    SafetyInstruction(
                        title: "Share Details",
                        description: "Provide your exact location and situation to responders"
                    )
                    
                    SafetyInstruction(
                        title: "Keep Connected",
                        description: "Stay on the app until help arrives"
                    )
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
    }
} 