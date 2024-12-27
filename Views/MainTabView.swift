import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GroupChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            SafetyView()
                .tabItem {
                    Label("Safety", systemImage: "shield.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
} 