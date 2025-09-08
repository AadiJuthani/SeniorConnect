import SwiftUI

struct RegistrationView: View {
    @Binding var isRegistered: Bool
    @Binding var isLoggedIn: Bool
    @Binding var userType: UserType

    @EnvironmentObject private var userManager: UserManager

    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var profileImageURL = ""
    @State private var useButtonStyle = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false

    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        phoneNumber.count >= 10
    }

    // When tapping the primary button: either register new user or update existing one
    private func saveProfile() {
        guard isFormValid else {
            alertMessage = "Please enter a valid name and phone number (at least 10 digits)."
            showAlert = true
            return
        }

        isSaving = true

        if userManager.currentUser == nil {
            // No saved user -> register new
            UserManager.shared.registerUser(name: fullName, phone: phoneNumber, userType: userType)
            // Save optional profile image URL if provided
            if !profileImageURL.trimmingCharacters(in: .whitespaces).isEmpty {
                UserManager.shared.updateCurrentUser { user in
                    user.profileImageURL = profileImageURL.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            // notify parent
            isRegistered = true
            isLoggedIn = true
        } else {
            // Update existing user
            UserManager.shared.updateCurrentUser { user in
                user.name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
                user.phoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                user.userType = userType
                user.profileImageURL = profileImageURL.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            // keep parent bindings consistent
            isRegistered = userManager.currentUser?.isRegistered ?? true
            isLoggedIn = true
        }

        // small delay to reflect changes (but not required)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isSaving = false
        }
    }

    // Prefill fields when view appears or when currentUser changes
    private func prefillFromSavedUser() {
        if let saved = userManager.currentUser {
            fullName = saved.name
            phoneNumber = saved.phoneNumber
            profileImageURL = saved.profileImageURL ?? ""
            userType = saved.userType
            isRegistered = saved.isRegistered
        } else {
            // leave fields blank / defaults
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(userType.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 24)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.25), value: userType)

                Text(userType.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.25), value: userType)

                // Profile preview + inputs
                VStack(spacing: 14) {
                    // Image preview
                    if let url = URL(string: profileImageURL.trimmingCharacters(in: .whitespacesAndNewlines)),
                       !profileImageURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.badge.exclamationmark")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .padding(.top, 6)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.top, 6)
                    }

                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title3)
                        .padding(.horizontal)

                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title3)
                        .keyboardType(.phonePad)
                        .padding(.horizontal)

                    TextField("Profile Image URL (optional)", text: $profileImageURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.subheadline)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: profileImageURL) { _ in
                            // no-op; preview updates automatically
                        }
                }
                .padding(.top, 6)

                // User type selector
                if useButtonStyle {
                    VStack(spacing: 12) {
                        Text("Who are you?")
                            .font(.headline)
                            .padding(.top, 6)

                        ForEach(UserType.allCases, id: \.self) { type in
                            let color = type.color
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    userType = type
                                }
                            }) {
                                Text(type.buttonText)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(userType == type ? .white : color)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(userType == type ? color : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(color, lineWidth: 2)
                                    )
                                    .scaleEffect(userType == type ? 1.03 : 1.0)
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Picker("Who are you?", selection: $userType) {
                        Text("Senior").tag(UserType.senior)
                        Text("Volunteer").tag(UserType.volunteer)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }

                // Primary button
                Button(action: saveProfile) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text(userManager.currentUser == nil ? "Create Account" : "Save Changes")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(userType.color)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .disabled(!isFormValid || isSaving)
                .opacity((!isFormValid || isSaving) ? 0.6 : 1.0)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                prefillFromSavedUser()
            }
            // Also refresh whenever the manager's currentUser changes
            .onReceive(userManager.$currentUser) { _ in
                prefillFromSavedUser()
            }
        }
    }
}
