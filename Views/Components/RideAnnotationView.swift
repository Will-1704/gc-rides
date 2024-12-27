import SwiftUI

struct RideAnnotationView: View {
    let ride: ActiveRide
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "car.fill")
                .font(.system(size: 24))
                .foregroundColor(ride.status.color)
                .background(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 2)
                )
            
            Image(systemName: "triangle.fill")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .offset(y: -3)
        }
    }
}

struct StartRideButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Start Driving")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(12)
                .padding()
        }
    }
}

struct FilterButton: View {
    var body: some View {
        Menu {
            Button("All Rides", action: {})
            Button("Nearby", action: {})
            Button("Recent", action: {})
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title2)
        }
    }
} 