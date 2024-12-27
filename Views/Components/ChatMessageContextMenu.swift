import SwiftUI

struct ChatMessageContextMenu: View {
    let message: ChatMessage
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var viewModel = ChatMessageViewModel()
    @State private var showDeleteConfirmation = false
    @State private var showReportSheet = false
    
    var body: some View {
        Menu {
            if let user = authManager.currentUser {
                if user.hasPrivilege(.deleteMessages) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete Message", systemImage: "trash")
                    }
                }
                
                Button {
                    showReportSheet = true
                } label: {
                    Label("Report Message", systemImage: "exclamationmark.triangle")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
        }
        .confirmationDialog(
            "Delete Message",
            isPresented: $showDeleteConfirmation,
            actions: {
                TextField("Reason for deletion", text: $viewModel.deletionReason)
                
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteMessage(message)
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            },
            message: {
                Text("This action cannot be undone.")
            }
        )
        .sheet(isPresented: $showReportSheet) {
            ReportContentView(
                contentType: .message,
                contentId: message.id
            )
        }
    }
}

// Similar context menu for reviews
struct ReviewContextMenu: View {
    let review: Review
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var viewModel = ReviewViewModel()
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        Menu {
            if let user = authManager.currentUser, user.hasPrivilege(.deleteReviews) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete Review", systemImage: "trash")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
        }
        .confirmationDialog(
            "Delete Review",
            isPresented: $showDeleteConfirmation,
            actions: {
                TextField("Reason for deletion", text: $viewModel.deletionReason)
                
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteReview(review)
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            },
            message: {
                Text("This action cannot be undone.")
            }
        )
    }
} 