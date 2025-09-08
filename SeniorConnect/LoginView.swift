import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userType: UserType
    @Binding var showRegistration: Bool

    @State private var phoneNumber = ""
    @State private var isLoggingIn = false
    @State private var loginError = ""
    @State private var showErrorAlert = false

    private var isFormValid: Bool {
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty && phoneNumber.count >= 10
    }

    private func loginUser() {
        isLoggingIn = true
        loginError = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // if persisted user matches phone, succeed
            if UserManager.shared.loginUser(phone: phoneNumber) {
                if let saved = UserManager.shared.currentUser {
                    userType = saved.userType
                }
                isLoggedIn = true
            } else {
                // For quick testing: accept a couple of mock numbers and set roles
                if phoneNumber == "1234567890" {
                    userType = .senior
                    UserManager.shared.registerUser(name: "Mock Senior", phone: phoneNumber, userType: .senior)
                    isLoggedIn = true
                } else if phoneNumber == "0987654321" {
                    userType = .volunteer
                    UserManager.shared.registerUser(name: "Mock Volunteer", phone: phoneNumber, userType: .volunteer)
                    isLoggedIn = true
                } else {
                    loginError = "Phone number not found. Please check your number or create an account."
                    showErrorAlert = true
                }
            }

            isLoggingIn = false
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("SeniorConnect")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Welcome Back!")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.headline)
                            .foregroundColor(.primary)

                        TextField("Enter your phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title3)
                            .keyboardType(.phonePad)
                            .disabled(isLoggingIn)
                    }
                    .padding(.horizontal)

                    Button(action: loginUser) {
                        HStack {
                            if isLoggingIn {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(isLoggingIn ? "Logging In..." : "Log In")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? .blue : .gray)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(!isFormValid || isLoggingIn)

                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))

                        Text("OR")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.horizontal)

                    Button(action: { showRegistration = true }) {
                        VStack(spacing: 5) {
                            Text("Don't have an account?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Create Account")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(isLoggingIn)
                }

                Spacer()

                Text("Need help? Call support at (555) 123-4567")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
        .alert("Login Error", isPresented: $showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(loginError)
        }
    }
}
