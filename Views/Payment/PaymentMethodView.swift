import SwiftUI

struct PaymentMethodView: View {
    let paymentInfo: PaymentInfo
    let amount: Double?
    
    var body: some View {
        Button {
            openPaymentApp()
        } label: {
            HStack {
                Image(paymentInfo.platform.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(paymentInfo.platform.displayName)
                
                Spacer()
                
                if let amount = amount {
                    Text(amount.formatted(.currency(code: "USD")))
                        .fontWeight(.medium)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
        }
    }
    
    private func openPaymentApp() {
        guard let prefix = paymentInfo.platform.deepLinkPrefix,
              let url = URL(string: "\(prefix)\(paymentInfo.username)") else {
            return
        }
        
        UIApplication.shared.open(url)
    }
} 