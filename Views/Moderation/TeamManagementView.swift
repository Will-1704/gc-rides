import SwiftUI

struct TeamManagementView: View {
    @StateObject private var viewModel = ModTeamViewModel()
    @State private var showAddModerator = false
    @State private var showPerformanceDetails = false
    @State private var selectedModerator: ModeratorProfile?
    
    var body: some View {
        List {
            // Active Moderators Section
            Section(header: Text("Active Moderators")) {
                ForEach(viewModel.activeModerators) { moderator in
                    ModeratorRow(moderator: moderator)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deactivateModerator(moderator)
                            } label: {
                                Label("Remove", systemImage: "person.fill.xmark")
                            }
                            
                            Button {
                                selectedModerator = moderator
                                showPerformanceDetails = true
                            } label: {
                                Label("Stats", systemImage: "chart.bar")
                            }
                            .tint(.blue)
                        }
                }
            }
            
            // Performance Overview
            Section(header: Text("Team Performance")) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Response Time")
                        Spacer()
                        Text(viewModel.averageResponseTime.formatted())
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Reports Handled")
                        Spacer()
                        Text("\(viewModel.totalReportsHandled)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Active Hours")
                        Spacer()
                        Text(viewModel.totalActiveHours.formatted())
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Shift Coverage
            Section(header: Text("Shift Coverage")) {
                ShiftCoverageView(coverage: viewModel.shiftCoverage)
            }
            
            // Pending Applications
            if !viewModel.pendingApplications.isEmpty {
                Section(header: Text("Pending Applications")) {
                    ForEach(viewModel.pendingApplications) { application in
                        ModeratorApplicationRow(application: application)
                            .swipeActions {
                                Button {
                                    viewModel.approveApplication(application)
                                } label: {
                                    Label("Approve", systemImage: "checkmark")
                                }
                                .tint(.green)
                                
                                Button(role: .destructive) {
                                    viewModel.rejectApplication(application)
                                } label: {
                                    Label("Reject", systemImage: "xmark")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Moderation Team")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddModerator = true
                } label: {
                    Label("Add Moderator", systemImage: "person.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showAddModerator) {
            AddModeratorView()
        }
        .sheet(item: $selectedModerator) { moderator in
            ModeratorPerformanceView(moderator: moderator)
        }
    }
}

struct ModeratorRow: View {
    let moderator: ModeratorProfile
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: moderator.avatarUrl)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(moderator.name)
                    .font(.headline)
                
                HStack {
                    Text(moderator.role.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(roleColor.opacity(0.2))
                        .foregroundColor(roleColor)
                        .clipShape(Capsule())
                    
                    if moderator.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(moderator.actionsToday) actions")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                RatingView(rating: moderator.rating)
                    .frame(height: 12)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var roleColor: Color {
        switch moderator.role {
        case .admin: return .purple
        case .moderator: return .blue
        case .supportAgent: return .green
        }
    }
}

struct ShiftCoverageView: View {
    let coverage: [ShiftCoverage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(coverage) { shift in
                HStack {
                    Text(shift.timeRange)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(shift.moderatorsOnline) online")
                        .font(.caption)
                        .foregroundColor(shift.moderatorsOnline < 2 ? .red : .secondary)
                    
                    ProgressView(value: shift.coverage)
                        .frame(width: 60)
                        .tint(coverageColor(shift.coverage))
                }
            }
        }
    }
    
    private func coverageColor(_ coverage: Double) -> Color {
        switch coverage {
        case 0.8...: return .green
        case 0.5...: return .yellow
        default: return .red
        }
    }
}

struct ModeratorPerformanceView: View {
    let moderator: ModeratorProfile
    @StateObject private var viewModel = ModeratorPerformanceViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Performance Metrics
                Section(header: Text("Performance")) {
                    MetricRow(title: "Response Time", value: viewModel.averageResponseTime)
                    MetricRow(title: "Resolution Rate", value: viewModel.resolutionRate, format: .percentage)
                    MetricRow(title: "Accuracy", value: viewModel.accuracy, format: .percentage)
                }
                
                // Activity Timeline
                Section(header: Text("Recent Activity")) {
                    ForEach(viewModel.recentActions) { action in
                        ActionTimelineRow(action: action)
                    }
                }
                
                // Feedback & Reviews
                Section(header: Text("Feedback")) {
                    ForEach(viewModel.feedback) { feedback in
                        FeedbackRow(feedback: feedback)
                    }
                }
                
                // Training & Certifications
                Section(header: Text("Training")) {
                    ForEach(viewModel.trainings) { training in
                        TrainingRow(training: training)
                    }
                }
            }
            .navigationTitle(moderator.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            viewModel.editRole()
                        } label: {
                            Label("Edit Role", systemImage: "person.badge.key")
                        }
                        
                        Button {
                            viewModel.scheduleTraining()
                        } label: {
                            Label("Schedule Training", systemImage: "book")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.removeModerator()
                        } label: {
                            Label("Remove Access", systemImage: "person.fill.xmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
} 