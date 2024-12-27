import SwiftUI
import MapKit

struct AvailableDriversView: View {
    @StateObject private var viewModel = AvailableDriversViewModel()
    @Environment(\.dismiss) private var dismiss
    let rideRequest: RideRequest
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Map showing driver locations
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: viewModel.rankedDrivers) { driver in
                    MapAnnotation(coordinate: driver.driver.currentLocation?.coordinate ?? .init()) {
                        DriverMapMarker(driver: driver)
                            .onTapGesture {
                                viewModel.selectedDriver = driver
                            }
                    }
                }
                .frame(height: 300)
                
                // Driver list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.rankedDrivers, id: \.driver.id) { driver in
                            DriverRequestCard(
                                driver: driver,
                                isSelected: viewModel.selectedDriver?.driver.id == driver.driver.id,
                                onSelect: {
                                    viewModel.selectedDriver = driver
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // Request button
                if let selectedDriver = viewModel.selectedDriver {
                    Button {
                        Task {
                            if await viewModel.requestDriver(selectedDriver) {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Request \(selectedDriver.driver.firstName)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Available Drivers")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadDrivers(for: rideRequest)
        }
    }
}

struct DriverRequestCard: View {
    let driver: DriverRankingEngine.RankedDriver
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Driver photo
                AsyncImage(url: URL(string: driver.driver.profilePicture ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    // Name and rating
                    HStack {
                        Text(driver.driver.firstName)
                            .font(.headline)
                        RatingView(rating: driver.driver.rating, size: 14)
                    }
                    
                    // Vehicle info
                    Text("\(driver.driver.vehicleMake) \(driver.driver.vehicleModel)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // ETA and distance
                    HStack {
                        Label(formatTime(driver.estimatedArrivalTime), systemImage: "clock")
                        Text("•")
                        Label(String(format: "%.1f mi", driver.distance), systemImage: "location")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Driver score indicator
                CircularScoreView(score: driver.score)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds / 60)
        return "\(minutes) min"
    }
}

struct CircularScoreView: View {
    let score: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 3)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(score / 5, 1)))
                .stroke(scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text(String(format: "%.1f", score))
                .font(.caption)
                .bold()
        }
        .frame(width: 40, height: 40)
    }
    
    private var scoreColor: Color {
        switch score {
        case 4.5...: return .green
        case 4.0..<4.5: return .blue
        case 3.0..<4.0: return .yellow
        default: return .red
        }
    }
} 