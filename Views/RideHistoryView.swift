import SwiftUI

struct RideHistoryView: View {
    @StateObject private var viewModel = RideHistoryViewModel()
    @State private var showFilter = false
    
    var body: some View {
        List {
            ForEach(viewModel.groupedRides.keys.sorted().reversed(), id: \.self) { date in
                Section(header: Text(date.formatted(.dateTime.month().day().year()))) {
                    ForEach(viewModel.groupedRides[date] ?? []) { ride in
                        RideHistoryCell(ride: ride)
                            .swipeActions(edge: .trailing) {
                                if ride.status == .completed {
                                    Button {
                                        viewModel.leaveReview(for: ride)
                                    } label: {
                                        Label("Review", systemImage: "star")
                                    }
                                    .tint(.yellow)
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Ride History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilter = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showFilter) {
            RideHistoryFilterView(
                filters: $viewModel.filters,
                apply: viewModel.applyFilters
            )
        }
        .refreshable {
            await viewModel.loadRides()
        }
    }
}

struct RideHistoryCell: View {
    let ride: RideHistoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(ride.date.formatted(.dateTime.hour().minute()))
                        .font(.headline)
                    Text(ride.status.rawValue)
                        .font(.subheadline)
                        .foregroundColor(ride.status.color)
                }
                
                Spacer()
                
                if let amount = ride.amount {
                    Text(amount.formatted(.currency(code: "USD")))
                        .font(.headline)
                }
            }
            
            LocationRow(icon: "mappin.circle.fill",
                       color: .red,
                       text: ride.pickup)
            
            LocationRow(icon: "mappin.circle.fill",
                       color: .blue,
                       text: ride.destination)
            
            if let driver = ride.driver {
                HStack {
                    AsyncImage(url: URL(string: driver.profilePicture ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                    }
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    
                    Text(driver.fullName)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    if let rating = ride.rating {
                        RatingView(rating: rating, size: 12)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
} 