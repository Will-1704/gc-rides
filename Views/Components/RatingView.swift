import SwiftUI

struct RatingView: View {
    let rating: Float
    var size: CGFloat = 20
    var isEditable = false
    var onRatingChanged: ((Int) -> Void)?
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starImageName(for: index))
                    .foregroundColor(.yellow)
                    .font(.system(size: size))
                    .onTapGesture {
                        if isEditable {
                            onRatingChanged?(index)
                        }
                    }
            }
        }
    }
    
    private func starImageName(for index: Int) -> String {
        if Float(index) <= rating {
            return "star.fill"
        } else if Float(index) - rating < 1 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RatingView(rating: review.rating)
                Spacer()
                Text(review.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let comment = review.comment {
                Text(comment)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 