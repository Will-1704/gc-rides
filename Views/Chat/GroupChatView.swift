import SwiftUI

struct GroupChatView: View {
    @StateObject private var viewModel = GroupChatViewModel()
    @State private var showRules = true
    @State private var showSafetyTips = true
    @State private var showMenu = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Active Drivers Banner
                ActiveDriversBanner(drivers: viewModel.activeDrivers)
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageRow(
                                    message: message,
                                    hasFoundRide: viewModel.hasFoundRide(userId: message.userId)
                                )
                            }
                        }
                        .padding()
                    }
                }
                
                // Message Input
                MessageInputView(
                    text: $viewModel.messageText,
                    showFormatter: $viewModel.showRideFormatter
                ) {
                    viewModel.sendMessage()
                }
            }
            .navigationTitle("GC Rides")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showMenu = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
        .sheet(isPresented: $showRules) {
            RulesView()
        }
        .sheet(isPresented: $showSafetyTips) {
            SafetyTipsView()
        }
        .sheet(isPresented: $viewModel.showRideFormatter) {
            RideRequestFormatterView(completion: viewModel.sendFormattedRequest)
        }
    }
} 