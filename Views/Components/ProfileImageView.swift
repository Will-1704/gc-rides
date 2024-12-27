struct ProfileImageView: View {
    let user: User
    let size: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            
            if let badge = user.primaryBadge {
                BadgeIcon(type: badge.type)
                    .frame(width: size * 0.4, height: size * 0.4)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
                    .offset(x: 2, y: 2)
            }
        }
        .frame(width: size, height: size)
    }
}

struct BadgeIcon: View {
    let type: DriverBadge.BadgeType
    
    var body: some View {
        Image(systemName: type.icon)
            .foregroundColor(Color(type.color))
            .font(.system(size: 12, weight: .bold))
            .symbolRenderingMode(.multicolor)
    }
} 