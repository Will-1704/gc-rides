import SwiftUI

struct GroupChatView: View {
    @StateObject private var viewModel = GroupChatViewModel()
    @State private var messageText = ""
    @State private var showRideRequestForm = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Driver Banner
                DriverBannerView(drivers: viewModel.activeDrivers)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .shadow(radius: 2)
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                ChatMessageView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.last?.id)
                        }
                    }
                }
                
                // Message Input
                VStack(spacing: 8) {
                    HStack {
                        Button(action: { showRideRequestForm.toggle() }) {
                            Image(systemName: "car.fill")
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        TextField("Message", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .disabled(messageText.isEmpty)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("GC Rides Chat")
            .sheet(isPresented: $showRideRequestForm) {
                RideRequestFormView()
            }
        }
    }
    
    private func sendMessage() {
        viewModel.sendMessage(messageText)
        messageText = ""
    }
} 