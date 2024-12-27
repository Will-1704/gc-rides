import SwiftUI

struct ReviewsListView: View {
    let user: User
    @StateObject private var viewModel = ReviewsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Overall Rating")
                                .font(.headline)
                            HStack {
                                Text(String(format: "%.1f", user.rating))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                RatingView(rating: user.rating, size: 24)
                            }
                        }
                        Spacer()
                        Text("\(user.ridesCompleted) rides")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    ForEach(viewModel.reviews) { review in
                        ReviewCard(review: review)
                    }
                }
            }
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadReviews(for: user.id)
            }
        }
    }
} 