import SwiftUI

struct TrainingDashboardView: View {
    @StateObject private var viewModel = TrainingDashboardViewModel()
    
    var body: some View {
        List {
            // Required Training Section
            if !viewModel.requiredModules.isEmpty {
                Section(header: Text("Required Training")) {
                    ForEach(viewModel.requiredModules) { module in
                        RequiredTrainingRow(module: module)
                            .swipeActions {
                                Button {
                                    viewModel.startModule(module)
                                } label: {
                                    Label("Start", systemImage: "play.fill")
                                }
                                .tint(.blue)
                            }
                    }
                }
            }
            
            // Optional Training Section
            Section(header: Text("Available Courses")) {
                ForEach(viewModel.availableModules) { module in
                    TrainingModuleRow(module: module)
                }
            }
            
            // Certifications Section
            Section(header: Text("My Certifications")) {
                ForEach(viewModel.certificates) { cert in
                    CertificationRow(certificate: cert)
                }
            }
            
            // Achievements Section
            if !viewModel.achievements.isEmpty {
                Section(header: Text("Achievements")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.achievements) { achievement in
                                AchievementBadge(achievement: achievement)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationTitle("Training & Certification")
        .refreshable {
            await viewModel.loadData()
        }
        .sheet(item: $viewModel.selectedModule) { module in
            TrainingModuleView(module: module)
        }
    }
}

struct TrainingModuleRow: View {
    let module: TrainingModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: moduleIcon)
                    .foregroundColor(moduleColor)
                    .font(.title3)
                
                Text(module.title)
                    .font(.headline)
                
                Spacer()
                
                if let reward = module.reward {
                    RewardBadge(reward: reward)
                }
            }
            
            Text(module.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label(
                    module.estimatedDuration.formatted(.units()),
                    systemImage: "clock"
                )
                .font(.caption)
                
                if let prerequisites = module.prerequisites, !prerequisites.isEmpty {
                    Text("•")
                    Label("\(prerequisites.count) prerequisites", systemImage: "list.bullet")
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var moduleIcon: String {
        switch module.type {
        case .safety: return "shield.fill"
        case .service: return "person.fill.checkmark"
        case .policy: return "doc.text.fill"
        case .vehicle: return "car.fill"
        case .accessibility: return "figure.roll"
        case .advanced: return "star.fill"
        case .specialization: return "medal.fill"
        }
    }
    
    private var moduleColor: Color {
        switch module.type {
        case .safety: return .red
        case .service: return .blue
        case .policy: return .gray
        case .vehicle: return .green
        case .accessibility: return .purple
        case .advanced: return .orange
        case .specialization: return .yellow
        }
    }
}

struct RewardBadge: View {
    let reward: TrainingModule.Reward
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: rewardIcon)
            Text(rewardText)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.green.opacity(0.2))
        .foregroundColor(.green)
        .cornerRadius(8)
    }
    
    private var rewardIcon: String {
        switch reward.type {
        case .bonus: return "dollarsign.circle.fill"
        case .rateMultiplier: return "percent"
        case .priorityDispatch: return "star.fill"
        }
    }
    
    private var rewardText: String {
        switch reward.type {
        case .bonus: return "+\(reward.value.formatted(.currency(code: "USD")))"
        case .rateMultiplier: return "\(reward.value)x"
        case .priorityDispatch: return "Priority"
        }
    }
} 