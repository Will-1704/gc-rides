import SwiftUI

struct UserProfileCard: View {
    let user: User
    let showFullProfile: Bool
    @State private var showAllReviews = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: user.profilePicture ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(user.fullName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    HStack {
                        RatingView(rating: user.rating)
                        Text("(\(user.ridesCompleted) rides)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            
            if user.isDriver {
                DriverInfoSection(user: user)
            }
            
            // Recent Reviews
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Recent Reviews")
                        .font(.headline)
                    Spacer()
                    if showFullProfile {
                        Button("See All") {
                            showAllReviews = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
                
                ForEach(user.recentReviews.prefix(showFullProfile ? 3 : 1)) { review in
                    ReviewCard(review: review)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .sheet(isPresented: $showAllReviews) {
            ReviewsListView(user: user)
        }
    }
}

struct DriverInfoSection: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
            
            // Vehicle Info
            HStack {
                Label {
                    Text("\(user.driver.vehicleMake) \(user.driver.vehicleModel)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "car.fill")
                }
                
                Spacer()
                
                Label {
                    Text("\(user.driver.seatCapacity) seats")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "person.2.fill")
                }
            }
            
            // Driver Status
            if let lastSession = user.driver.lastDrivingSession {
                Text("Last Active: \(lastSession.endTime.timeAgoDisplay())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Payment Methods
            HStack {
                ForEach(user.driver.paymentMethods, id: \.self) { method in
                    Image(method.lowercased())
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
            
            // Graduation Year
            Text("Class of \(user.driver.graduationYear)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
} 