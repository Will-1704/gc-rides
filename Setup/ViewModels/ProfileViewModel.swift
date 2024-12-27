import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User = User(
        id: "test-id",
        email: "test@test.com",
        firstName: "Test",
        lastName: "User",
        profileImageUrl: nil
    )
} 