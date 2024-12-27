import SwiftUI

struct UserInfoRow: View {
    let user: User
    
    var body: some View {
        HStack {
            if let url = user.profileImageUrl {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
} 