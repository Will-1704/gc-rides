struct DriverBadgeManagementView: View {
    let user: User
    @StateObject private var viewModel = DriverBadgeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Badges")) {
                    ForEach(user.badges) { badge in
                        BadgeRow(badge: badge)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.showRevokeBadge(badge)
                                } label: {
                                    Label("Revoke", systemImage: "xmark.circle")
                                }
                            }
                    }
                }
                
                Section {
                    Button {
                        viewModel.showAddBadge = true
                    } label: {
                        Label("Add Badge", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Manage Badges")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $viewModel.showAddBadge) {
                AddBadgeView(user: user)
            }
            .alert("Revoke Badge",
                isPresented: $viewModel.showRevokeBadgeAlert) {
                TextField("Reason", text: $viewModel.revokeReason)
                
                Button("Revoke", role: .destructive) {
                    viewModel.revokeBadge()
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please provide a reason for revoking this badge.")
            }
        }
    }
}

struct BadgeRow: View {
    let badge: DriverBadge
    
    var body: some View {
        HStack {
            BadgeIcon(type: badge.type)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(badge.type.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Issued \(badge.issuedAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
} 