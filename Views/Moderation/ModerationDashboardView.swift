import SwiftUI

struct ModerationDashboardView: View {
    @StateObject private var viewModel = ModerationDashboardViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ReportedContentView()
                .tabItem {
                    Label("Reports", systemImage: "exclamationmark.triangle")
                }
                .tag(0)
            
            ModeratedContentView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(1)
            
            ModeratorSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .navigationTitle("Moderation")
    }
}

struct ReportedContentView: View {
    @StateObject private var viewModel = ReportedContentViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.reports) { report in
                ReportCell(report: report)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.handleReport(report, action: .remove)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                        
                        Button {
                            viewModel.handleReport(report, action: .dismiss)
                        } label: {
                            Label("Dismiss", systemImage: "xmark")
                        }
                        .tint(.gray)
                    }
            }
        }
        .refreshable {
            await viewModel.loadReports()
        }
    }
} 