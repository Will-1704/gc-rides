class AppSettings: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    
    func toggleColorScheme() {
        switch colorScheme {
        case .none:
            colorScheme = .dark
        case .dark:
            colorScheme = .light
        case .light:
            colorScheme = nil
        }
    }
} 