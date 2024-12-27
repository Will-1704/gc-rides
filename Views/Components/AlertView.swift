import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
    var primaryButton: Alert.Button?
    
    var alert: Alert {
        if let primary = primaryButton {
            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: primary,
                secondaryButton: dismissButton
            )
        } else {
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: dismissButton
            )
        }
    }
}

extension View {
    func errorAlert(_ error: Binding<Error?>) -> some View {
        let alertItem = error.wrappedValue.map { err in
            AlertItem(
                title: "Error",
                message: err.localizedDescription,
                dismissButton: .default(Text("OK")) {
                    error.wrappedValue = nil
                }
            )
        }
        
        return alert(item: Binding(
            get: { alertItem },
            set: { _ in error.wrappedValue = nil }
        )) { item in
            item.alert
        }
    }
} 