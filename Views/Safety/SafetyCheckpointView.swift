import SwiftUI

struct SafetyCheckpointView: View {
    @StateObject private var viewModel = SafetyCheckpointViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Safety Verification Code
            if viewModel.requiresVerification {
                VerificationCodeInput(
                    code: $viewModel.verificationCode,
                    isValid: viewModel.isCodeValid
                )
            }
            
            // Safety Questions
            ForEach(viewModel.safetyQuestions) { question in
                SafetyQuestionCard(
                    question: question,
                    response: viewModel.responses[question.id] ?? false
                ) { response in
                    viewModel.responses[question.id] = response
                }
            }
            
            // Quick Actions
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Share Location",
                    icon: "location.fill",
                    action: viewModel.shareLocation
                )
                
                QuickActionButton(
                    title: "Contact Support",
                    icon: "phone.fill",
                    action: viewModel.contactSupport
                )
                
                QuickActionButton(
                    title: "Emergency",
                    icon: "sos",
                    action: viewModel.triggerEmergency
                )
            }
            
            // Continue Button
            Button {
                Task {
                    if await viewModel.submitCheckpoint() {
                        dismiss()
                    }
                }
            } label: {
                Text("Confirm Safety Check")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.canSubmit ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!viewModel.canSubmit)
        }
        .padding()
        .navigationTitle("Safety Checkpoint")
        .alert("Safety Alert", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
            if let action = viewModel.alertAction {
                Button(action.title, role: .destructive, action: action.handler)
            }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
} 