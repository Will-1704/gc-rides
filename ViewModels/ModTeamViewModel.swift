import Foundation
import Combine

class ModTeamViewModel: ObservableObject {
    @Published var activeModerators: [ModeratorProfile] = []
    @Published var pendingApplications: [ModeratorApplication] = []
    @Published var shiftCoverage: [ShiftCoverage] = []
    @Published var averageResponseTime: TimeInterval = 0
    @Published var totalReportsHandled: Int = 0
    @Published var totalActiveHours: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let moderationService: ModerationService
    
    init(moderationService: ModerationService = .shared) {
        self.moderationService = moderationService
        setupSubscriptions()
        loadData()
    }
    
    private func setupSubscriptions() {
        // Listen for moderator status changes
        NotificationCenter.default.publisher(for: .moderatorStatusChanged)
            .sink { [weak self] _ in
                self?.loadData()
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        // Load active moderators
        moderationService.getActiveModerators()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] moderators in
                self?.activeModerators = moderators
            }
            .store(in: &cancellables)
        
        // Load applications
        moderationService.getPendingApplications()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] applications in
                self?.pendingApplications = applications
            }
            .store(in: &cancellables)
        
        // Load performance metrics
        moderationService.getTeamPerformance()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] performance in
                self?.updatePerformanceMetrics(performance)
            }
            .store(in: &cancellables)
    }
    
    private func updatePerformanceMetrics(_ performance: TeamPerformance) {
        averageResponseTime = performance.averageResponseTime
        totalReportsHandled = performance.totalReportsHandled
        totalActiveHours = performance.totalActiveHours
        shiftCoverage = performance.shiftCoverage
    }
    
    func approveApplication(_ application: ModeratorApplication) {
        Task {
            do {
                try await moderationService.approveApplication(application.id)
                await MainActor.run {
                    pendingApplications.removeAll { $0.id == application.id }
                }
            } catch {
                print("Failed to approve application: \(error)")
            }
        }
    }
    
    func rejectApplication(_ application: ModeratorApplication) {
        Task {
            do {
                try await moderationService.rejectApplication(application.id)
                await MainActor.run {
                    pendingApplications.removeAll { $0.id == application.id }
                }
            } catch {
                print("Failed to reject application: \(error)")
            }
        }
    }
    
    func deactivateModerator(_ moderator: ModeratorProfile) {
        Task {
            do {
                try await moderationService.deactivateModerator(moderator.id)
                await MainActor.run {
                    activeModerators.removeAll { $0.id == moderator.id }
                }
            } catch {
                print("Failed to deactivate moderator: \(error)")
            }
        }
    }
} 