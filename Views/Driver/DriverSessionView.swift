import SwiftUI
import MapKit

struct DriverSessionView: View {
    @StateObject private var viewModel = DriverSessionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Status Bar
                SessionStatusBar(
                    status: viewModel.sessionStatus,
                    earnings: viewModel.totalEarnings,
                    rides: viewModel.totalRides
                )
                
                // Map
                Map(
                    coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow)
                )
                .overlay(alignment: .topTrailing) {
                    VStack {
                        Button {
                            viewModel.toggleAvailability()
                        } label: {
                            Image(systemName: viewModel.isAvailable ? "person.fill.checkmark" : "person.fill.xmark")
                                .padding()
                                .background(viewModel.isAvailable ? Color.green : Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            viewModel.centerOnUser()
                        } label: {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
                
                // Current Ride or Settings
                if viewModel.currentRide != nil {
                    CurrentRideView(ride: viewModel.currentRide!)
                } else {
                    SessionSettingsView(
                        capacity: $viewModel.remainingCapacity,
                        pricing: $viewModel.pricing
                    )
                }
            }
            .navigationTitle("Driving Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("End Session") {
                        viewModel.showEndSession = true
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.pauseSession()
                        } label: {
                            Label("Take Break", systemImage: "pause.circle")
                        }
                        
                        Button {
                            viewModel.showEarnings = true
                        } label: {
                            Label("View Earnings", systemImage: "dollarsign.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("End Session?", isPresented: $viewModel.showEndSession) {
                Button("End", role: .destructive) {
                    Task {
                        await viewModel.endSession()
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to end your driving session?")
            }
            .sheet(isPresented: $viewModel.showEarnings) {
                SessionEarningsView(session: viewModel.session)
            }
        }
    }
} 