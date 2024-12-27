import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage
    @EnvironmentObject var authManager: AuthenticationManager
    
    private var isCurrentUser: Bool {
        message.senderId == authManager.currentUser?.id
    }
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if message.isRideRequest {
                    RideRequestMessageView(message: message)
                } else {
                    RegularMessageView(message: message)
                }
                
                Text(message.timestamp.timeAgoDisplay())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct RideRequestMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Ride Request", systemImage: "car.fill")
                .font(.caption)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                LocationRow(icon: "mappin.circle.fill",
                          color: .red,
                          text: message.rideRequest?.pickup ?? "")
                
                LocationRow(icon: "mappin.circle.fill",
                          color: .blue,
                          text: message.rideRequest?.destination ?? "")
                
                if let partySize = message.rideRequest?.partySize {
                    Label("\(partySize) passengers", systemImage: "person.2.fill")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct RegularMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        Text(message.content)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
} 