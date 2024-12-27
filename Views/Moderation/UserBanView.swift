import SwiftUI

struct UserBanView: View {
    let user: User
    @StateObject private var viewModel = UserBanViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ban Duration")) {
                    Picker("Duration", selection: $viewModel.banDuration) {
                        ForEach(BanDuration.allCases) { duration in
                            Text(duration.description).tag(duration)
                        }
                    }
                    
                    if case .custom = viewModel.banDuration {
                        DatePicker(
                            "Until",
                            selection: $viewModel.customEndDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                    }
                }
                
                Section(header: Text("Reason")) {
                    Picker("Category", selection: $viewModel.banReason) {
                        ForEach(BanReason.allCases) { reason in
                            Text(reason.rawValue).tag(reason)
                        }
                    }
                    
                    TextEditor(text: $viewModel.banNote)
                        .frame(height: 100)
                }
                
                Section(header: Text("Additional Actions")) {
                    Toggle("Delete all messages", isOn: $viewModel.deleteMessages)
                    Toggle("Hide all reviews", isOn: $viewModel.hideReviews)
                    Toggle("Notify user", isOn: $viewModel.notifyUser)
                }
                
                Section {
                    Button(action: banUser) {
                        Text("Ban User")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Ban User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Ban User", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }
    
    private func banUser() {
        Task {
            if await viewModel.banUser(user) {
                dismiss()
            }
        }
    }
}

enum BanDuration: Identifiable, CaseIterable {
    case day
    case week
    case month
    case year
    case permanent
    case custom
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .day: return "24 Hours"
        case .week: return "1 Week"
        case .month: return "1 Month"
        case .year: return "1 Year"
        case .permanent: return "Permanent"
        case .custom: return "Custom"
        }
    }
    
    var duration: TimeInterval? {
        switch self {
        case .day: return 86400
        case .week: return 604800
        case .month: return 2592000
        case .year: return 31536000
        case .permanent: return nil
        case .custom: return nil
        }
    }
}

enum BanReason: String, CaseIterable, Identifiable {
    case harassment = "Harassment"
    case spam = "Spam/Advertising"
    case inappropriate = "Inappropriate Content"
    case fraud = "Fraudulent Activity"
    case multiple = "Multiple Violations"
    case other = "Other"
    
    var id: String { rawValue }
} 