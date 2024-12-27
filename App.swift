@main
struct GCRidesApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settings.colorScheme)
                .environmentObject(settings)
        }
    }
} 