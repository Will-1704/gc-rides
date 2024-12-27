struct AppearanceSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section(header: Text("Theme")) {
                Picker("App Theme", selection: $settings.colorScheme) {
                    Text("System").tag(Optional<ColorScheme>.none)
                    Text("Light").tag(Optional<ColorScheme>.some(.light))
                    Text("Dark").tag(Optional<ColorScheme>.some(.dark))
                }
            }
        }
        .background(AppColor.background)
    }
} 