import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var userType: UserType = .senior
    @State private var isRegistered = false
    @State private var showRegistration = false

    @ObservedObject private var userManager = UserManager.shared

    var body: some View {
        Group {
            if !isRegistered || showRegistration {
                RegistrationView(
                    isRegistered: $isRegistered,
                    isLoggedIn: $isLoggedIn,
                    userType: $userType
                )
                .onAppear {
                    showRegistration = false
                }
            } else if isLoggedIn {
                if userType == .senior {
                    SeniorHomeView()
                } else {
                    VolunteerDashboardView()
                }
            } else {
                LoginView(
                    isLoggedIn: $isLoggedIn,
                    userType: $userType,
                    showRegistration: $showRegistration
                )
            }
        }
        .onAppear {
            // sync local flags from persisted user if present
            if let saved = userManager.currentUser {
                isRegistered = saved.isRegistered
                userType = saved.userType
                isLoggedIn = userManager.isLoggedIn
            } else {
                isRegistered = false
            }
        }
    }
}
