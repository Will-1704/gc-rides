import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GroupChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(0)
            
            ActiveRidesView()
                .tabItem {
                    Label("Rides", systemImage: "car.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
            
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "info.circle.fill")
                }
                .tag(3)
        }
    }
} 