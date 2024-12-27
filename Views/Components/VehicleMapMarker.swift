import SwiftUI

struct VehicleMapMarker: View {
    let driver: Driver
    let isSelected: Bool
    @State private var isAnimating = false
    
    private var vehicleIcon: VehicleIcon {
        VehicleIcon(
            make: driver.vehicle.make,
            model: driver.vehicle.model,
            type: .determineType(make: driver.vehicle.make, model: driver.vehicle.model),
            year: driver.vehicle.year
        )
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                .frame(width: 44, height: 44)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
            
            // Vehicle icon
            Image(systemName: vehicleIcon.type.iconName)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .blue : .primary)
                .rotationEffect(.degrees(driver.heading ?? 0))
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 36, height: 36)
                        .shadow(radius: 2)
                )
        }
        .onChange(of: isSelected) { newValue in
            withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(2)) {
                isAnimating = newValue
            }
        }
    }
} 