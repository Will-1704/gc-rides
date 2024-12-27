struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(AppColor.cardBackground)
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
} 