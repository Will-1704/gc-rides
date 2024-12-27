import Foundation
import Combine

class ReviewsViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedFilter: ReviewFilter = .all
    @Published var sortOrder: ReviewSortOrder = .newest
    
    private var cancellables = Set<AnyCancellable>()
    private let reviewService: ReviewService
    
    enum ReviewFilter: String, CaseIterable {
        case all = "All"
        case positive = "5 Star"
        case negative = "Critical"
        
        var predicate: ((Review) -> Bool) {
            switch self {
            case .all: return { _ in true }
            case .positive: return { $0.rating >= 5 }
            case .negative: return { $0.rating <= 3 }
            }
        }
    }
    
    enum ReviewSortOrder: String, CaseIterable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case highestRated = "Highest Rated"
        case lowestRated = "Lowest Rated"
        
        var comparator: ((Review, Review) -> Bool) {
            switch self {
            case .newest: return { $0.date > $1.date }
            case .oldest: return { $0.date < $1.date }
            case .highestRated: return { $0.rating > $1.rating }
            case .lowestRated: return { $0.rating < $1.rating }
            }
        }
    }
    
    init(reviewService: ReviewService = .shared) {
        self.reviewService = reviewService
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        Publishers.CombineLatest($selectedFilter, $sortOrder)
            .sink { [weak self] filter, sort in
                self?.applyFilterAndSort(filter: filter, sort: sort)
            }
            .store(in: &cancellables)
    }
    
    func loadReviews(for userId: String) {
        isLoading = true
        
        reviewService.getReviews(for: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] reviews in
                self?.reviews = reviews
                self?.applyFilterAndSort(
                    filter: self?.selectedFilter ?? .all,
                    sort: self?.sortOrder ?? .newest
                )
            }
            .store(in: &cancellables)
    }
    
    private func applyFilterAndSort(filter: ReviewFilter, sort: ReviewSortOrder) {
        reviews = reviews
            .filter(filter.predicate)
            .sorted(by: sort.comparator)
    }
} 