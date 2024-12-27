import SwiftUI

struct ReportContentView: View {
    let contentType: ContentReport.ContentType
    let contentId: String
    @StateObject private var viewModel = ReportViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reason for Report")) {
                    Picker("Reason", selection: $viewModel.selectedReason) {
                        ForEach(ContentReport.ReportReason.allCases, id: \.self) { reason in
                            Text(reason.description)
                                .tag(reason)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section(header: Text("Details")) {
                    TextEditor(text: $viewModel.description)
                        .frame(height: 100)
                        .overlay(
                            Group {
                                if viewModel.description.isEmpty {
                                    Text("Please provide additional details about your report...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                if viewModel.selectedReason == .inappropriate {
                    Section(header: Text("Content Type")) {
                        ForEach(InappropriateContentType.allCases) { type in
                            Button {
                                viewModel.selectedContentTypes.toggle(type)
                            } label: {
                                HStack {
                                    Text(type.description)
                                    Spacer()
                                    if viewModel.selectedContentTypes.contains(type) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                Section {
                    Button {
                        Task {
                            if await viewModel.submitReport(
                                contentType: contentType,
                                contentId: contentId
                            ) {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Submit Report")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!viewModel.isValid)
                }
            }
            .navigationTitle("Report Content")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

enum InappropriateContentType: CaseIterable, Identifiable {
    case offensive
    case explicit
    case violence
    case hate
    case personal
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .offensive: return "Offensive Language"
        case .explicit: return "Explicit Content"
        case .violence: return "Violence/Threats"
        case .hate: return "Hate Speech"
        case .personal: return "Personal Information"
        }
    }
} 