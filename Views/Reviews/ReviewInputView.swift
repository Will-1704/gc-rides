import SwiftUI

struct ReviewInputView: View {
    let ride: Ride
    let reviewType: Review.ReviewType
    @StateObject private var viewModel = ReviewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Star Rating
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= viewModel.rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.title2)
                                .onTapGesture {
                                    viewModel.rating = star
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
                
                Section(header: Text("Comments")) {
                    TextEditor(text: $viewModel.comment)
                        .frame(height: 100)
                }
                
                Section {
                    Button {
                        Task {
                            if await viewModel.submitReview(for: ride, type: reviewType) {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Submit Review")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .navigationTitle(reviewType == .driver ? "Rate Driver" : "Rate Rider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }
} 