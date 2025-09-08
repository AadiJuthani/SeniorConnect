import SwiftUI

struct SeniorHomeView: View {
    @EnvironmentObject private var userManager: UserManager
    @State private var showingEditProfile = false

    // Help UI state
    @State private var showingHelpOptions = false           // choose call vs form
    @State private var showingHelpForm = false              // show HelpRequestView
    @State private var showingCallConfirmation = false     // confirm before starting CallKit call
    @State private var callTargetPhone: String = ""         // phone to call
    @State private var isCalling = false
    @ObservedObject private var volunteerManager = VolunteerManager.shared
    @State private var showingNoVolunteerAlert = false     // show if no volunteer available

    // Convenience computed values
    private var userName: String { userManager.currentUser?.name ?? "Friend" }
    private var phoneNumber: String? { userManager.currentUser?.phoneNumber }
    private var userTypeDisplay: String { userManager.currentUser?.userType.displayName ?? "" }

    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header Section
                VStack(spacing: 10) {
                    Text("Good Day, \(userName)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(currentDate)
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                .padding(.horizontal)

                // Profile row with edit button
                HStack(spacing: 12) {
                    profileImageView()
                        .frame(width: 72, height: 72)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(userName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        if let phone = phoneNumber {
                            Text(phone)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Text("No phone on file")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Text(userTypeDisplay)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: { showingEditProfile = true }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 30)

                // Status Section
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)

                        Text("System Ready")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Spacer()
                    }

                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .font(.title3)

                        Text("\(volunteerManager.volunteers.filter { $0.isAvailable }.count) volunteers available to help")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 30)

                // Call Status Indicator
                if CallManager.shared.isCallActive {
                    callInProgressView()
                        .padding(.horizontal, 30)
                }

                // Main Help Button -> show options (Call vs Help Form)
                Button(action: { showingHelpOptions = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 28))
                        Text("I Need Help")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 20)
                }

                // Emergency Call Button (direct) -> dials 911
                Button(action: startEmergencyCall) {
                    VStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 28))
                        Text("Call for Help")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.green)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 30)
                }

                // Secondary Action Buttons
                VStack(spacing: 20) {
                    quickActionButton(icon: "lightbulb.fill", color: .orange, title: "Quick Tips") {
                        print("Show quick tips")
                    }

                    quickActionButton(icon: "clock.fill", color: .blue, title: "My Help History") {
                        print("View help history")
                    }

                    quickActionButton(icon: "gear.circle.fill", color: .gray, title: "My Settings") {
                        print("Open settings")
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .background(Color(.systemBackground))
        // Sheets / alerts
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(isPresented: $showingEditProfile)
                .environmentObject(userManager)
        }
        .sheet(isPresented: $showingHelpForm) {
            HelpRequestView()
        }
        .actionSheet(isPresented: $showingHelpOptions) {
            ActionSheet(
                title: Text("How would you like to get help?"),
                message: Text("Call a volunteer immediately or submit a help request."),
                buttons: [
                    .default(Text("Call a volunteer")) {
                        chooseVolunteerPhoneAndConfirm()
                    },
                    .default(Text("Fill out help request")) {
                        showingHelpForm = true
                    },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $showingCallConfirmation) {
            Alert(
                title: Text("Start Call"),
                message: Text("Call \(callTargetPhone) now?"),
                primaryButton: .default(Text("Call")) {
                    performCall()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("No volunteers available", isPresented: $showingNoVolunteerAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("No volunteers are currently available. Try again later or use the help form.")
        }
    }

    // MARK: - Subviews / helpers

    @ViewBuilder
    private func profileImageView() -> some View {
        if let urlString = userManager.currentUser?.profileImageURL,
           let url = URL(string: urlString),
           !urlString.trimmingCharacters(in: .whitespaces).isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 72, height: 72)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 72, height: 72)
                @unknown default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 72, height: 72)
                }
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
        }
    }

    private func callInProgressView() -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "phone.connection")
                    .foregroundColor(.green)
                    .font(.title2)

                Text("Call in Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)

                Spacer()
            }

            HStack {
                Text("Connected to volunteer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {
                    CallManager.shared.endCall()
                }) {
                    HStack {
                        Image(systemName: "phone.down.fill")
                        Text("End Call")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }

    private func quickActionButton(icon: String, color: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)

                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .foregroundColor(.primary)
    }

    // MARK: - Call logic

    private func startEmergencyCall() {
        // Try to pick a real volunteer's phone number (best available first).
        if let volunteer = volunteerManager.getBestAvailableVolunteer() ?? volunteerManager.getAvailableVolunteer() {
            callTargetPhone = volunteer.phoneNumber
            // Optionally you could show a sheet with volunteer details here before confirming.
            showingCallConfirmation = true
        } else {
            // No volunteer available — inform the user and offer the help form instead.
            showingNoVolunteerAlert = true
        }
    }

    private func chooseVolunteerPhoneAndConfirm() {
        // Prefer the best available volunteer (by rating) then first available
        if let volunteer = volunteerManager.getBestAvailableVolunteer() ?? volunteerManager.getAvailableVolunteer() {
            callTargetPhone = volunteer.phoneNumber
            showingCallConfirmation = true
        } else {
            // No volunteer available
            showingNoVolunteerAlert = true
        }
    }

    private func performCall() {
        // Call using CallManager (CallKit)
        guard !callTargetPhone.isEmpty else { return }
        isCalling = true

        // Use the volunteer name if available
        let contactName = volunteerManager.volunteers.first(where: { $0.phoneNumber == callTargetPhone })?.name ?? "Volunteer"

        CallManager.shared.startCall(to: callTargetPhone, contactName: contactName)

        // Optionally set isCalling -> after some delay clear or rely on CallManager.isCallActive
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isCalling = false
        }
    }
}

