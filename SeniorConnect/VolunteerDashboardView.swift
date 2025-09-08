import SwiftUI

struct VolunteerDashboardView: View {
    @State private var volunteerName = "John Davis" // This will come from user data later
    @State private var isAvailable = true
    @State private var activeRequests = 3 // Mock data for now
    @State private var mockIncomingCall: MockIncomingCall? = MockIncomingCall(
        seniorName: "Margaret Smith",
        phoneNumber: "5559876543"
    )
    
    struct MockIncomingCall {
        let seniorName: String
        let phoneNumber: String
    }

    // Mock data — this will come from real data later
    private var mockHelpRequests: [MockHelpRequest] {
        [
            MockHelpRequest(id: 1, userName: "Margaret Smith", problem: "I can't find my photos from last week", urgency: "Medium", timeAgo: "5 min ago", hasVoiceMessage: true),
            MockHelpRequest(id: 2, userName: "Robert Johnson", problem: "My phone keeps making weird noises", urgency: "High", timeAgo: "12 min ago", hasVoiceMessage: false),
            MockHelpRequest(id: 3, userName: "Dorothy Miller", problem: "Need help setting up video call with family", urgency: "Low", timeAgo: "25 min ago", hasVoiceMessage: true)
        ]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 12) {
                        Text("Welcome, \(volunteerName)")
                            .font(.title)
                            .fontWeight(.bold)

                        HStack {
                            Circle()
                                .fill(isAvailable ? Color.green : Color.red)
                                .frame(width: 12, height: 12)

                            Text(isAvailable ? "Available to Help" : "Not Available")
                                .font(.subheadline)
                                .foregroundColor(isAvailable ? .green : .red)
                        }

                        Text("\(activeRequests) seniors need help")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)

                    // Availability Toggle
                    VStack(spacing: 15) {
                        Text("Your Status")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Toggle(isOn: $isAvailable) {
                            HStack {
                                Image(systemName: isAvailable ? "person.fill.checkmark" : "person.fill.xmark")
                                    .foregroundColor(isAvailable ? .green : .red)

                                Text(isAvailable ? "Available for Help Requests" : "Not Taking Requests")
                                    .font(.body)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 2)
                    .padding(.horizontal)

                    // Volunteer Statistics
                    VStack(spacing: 15) {
                        Text("Your Impact")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("47")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                Text("People Helped")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                HStack(spacing: 2) {
                                    Text("4.8")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                }
                                
                                Text("Average Rating")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text("8")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text("This Week")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    
                    // Incoming Call Section
                    if mockIncomingCall != nil {
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "phone.ring")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .scaleEffect(1.2)
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                               value: mockIncomingCall != nil)

                                Text("Incoming Call Request")
                                    .font(.headline)
                                    .fontWeight(.bold)

                                Spacer()
                            }

                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(mockIncomingCall?.seniorName ?? "Unknown")
                                        .font(.title2)
                                        .fontWeight(.semibold)

                                    Text("Needs help with phone settings")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                HStack(spacing: 15) {
                                    Button(action: {
                                        // Accept call
                                        if let call = mockIncomingCall {
                                            CallManager.shared.startCall(
                                                to: call.phoneNumber,
                                                contactName: call.seniorName
                                            )
                                            mockIncomingCall = nil
                                        }
                                    }) {
                                        Image(systemName: "phone.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .clipShape(Circle())
                                    }

                                    Button(action: {
                                        // Decline call
                                        mockIncomingCall = nil
                                        print("Call declined")
                                    }) {
                                        Image(systemName: "phone.down.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)
                        )
                        .padding(.horizontal)
                    }


                    // Active Help Requests
                    VStack(spacing: 15) {
                        HStack {
                            Text("Help Requests")
                                .font(.headline)

                            Spacer()

                            Text("\(mockHelpRequests.count) active")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if mockHelpRequests.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "checkmark.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)

                                Text("No help requests right now")
                                    .font(.title2)
                                    .fontWeight(.medium)

                                Text("You're all caught up!")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 40)
                        } else {
                            ForEach(mockHelpRequests, id: \.id) { request in
                                HelpRequestCard(request: request)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 2)
                    .padding(.horizontal)

                    Spacer(minLength: 30)
                }
            }
            .navigationTitle("Volunteer Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// --- Combined section from screenshots (inserted here) ---

struct MockHelpRequest: Identifiable {
    let id: Int
    let userName: String
    let problem: String
    let urgency: String
    let timeAgo: String
    let hasVoiceMessage: Bool
}

struct HelpRequestCard: View {
    let request: MockHelpRequest

    var urgencyColor: Color {
        switch request.urgency {
        case "High": return .red
        case "Medium": return .orange
        case "Low": return .green
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.userName)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(request.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(request.urgency)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(urgencyColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(urgencyColor.opacity(0.2))
                    .cornerRadius(8)
            }

            Text(request.problem)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)

            // Add voice message code here
            if request.hasVoiceMessage {
                HStack(spacing: 12) {
                    Button(action: {
                        print("Playing voice message from \(request.userName)")
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)

                            Text("Voice Message (0:45)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }

                    Spacer()

                    Image(systemName: "waveform")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            // End of Voice Message Code

            // Action Buttons Section (Call, Accept, View Details)
            HStack(spacing: 12) {
                // Call the senior directly (using a mock number)
                Button(action: {
                    // Replace the mock number below with a real one if you add it to the model
                    CallManager.shared.startCall(to: "5559876543", contactName: request.userName)
                    print("Calling \(request.userName)")
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.subheadline)
                        Text("Call")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .accessibilityLabel("Call \(request.userName)")

                // Accept the request
                Button(action: {
                    print("Accepting help request from \(request.userName)")
                }) {
                    Text("Accept")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .accessibilityLabel("Accept request from \(request.userName)")

                // View details
                Button(action: {
                    print("Viewing details for \(request.userName)")
                }) {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .accessibilityLabel("View details for \(request.userName)")

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

