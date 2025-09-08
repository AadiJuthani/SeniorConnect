//
//  VolunteerContactView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/6/25.
//
import SwiftUI

// MARK: - Model
struct MockVolunteerContact: Identifiable {
    let id: Int
    let name: String
    let specialty: String
    let isAvailable: Bool
    let phoneNumber: String
    let rating: Double
}

// MARK: - Volunteer Contact Card
struct VolunteerContactCard: View {
    let volunteer: MockVolunteerContact
    @ObservedObject private var callManager = CallManager.shared

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(volunteer.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        if volunteer.isAvailable {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                        }
                    }

                    Text(volunteer.specialty)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Spacer()

                // Availability / Call button
                if volunteer.isAvailable {
                    Button(action: {
                        // Start call via CallManager
                        callManager.startCall(to: volunteer.phoneNumber, contactName: volunteer.name)
                        print("Calling \(volunteer.name) at \(volunteer.phoneNumber)")
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                            Text("Call")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: "phone.slash")
                            .font(.title2)
                        Text("Busy")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
            }

            // Rating row
            HStack(spacing: 6) {
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(volunteer.rating) ? "star.fill" : "star")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                Text(String(format: "%.1f", volunteer.rating))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

// MARK: - Main View
struct VolunteerContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var callManager = CallManager.shared

    private var mockVolunteers: [MockVolunteerContact] {
        [
            MockVolunteerContact(id: 1, name: "John Davis", specialty: "Phone Settings", isAvailable: true, phoneNumber: "5551234567", rating: 4.8),
            MockVolunteerContact(id: 2, name: "Sarah Wilson", specialty: "Apps & Email", isAvailable: true, phoneNumber: "5559876543", rating: 4.9),
            MockVolunteerContact(id: 3, name: "Mike Johnson", specialty: "Photos & Camera", isAvailable: false, phoneNumber: "5555555555", rating: 4.7),
            MockVolunteerContact(id: 4, name: "Lisa Chen", specialty: "Internet & Wi-Fi", isAvailable: true, phoneNumber: "5552468135", rating: 5.0)
        ]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose a Volunteer to Call")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)

                    Text("All volunteers are ready to help you")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    ForEach(mockVolunteers) { volunteer in
                        VolunteerContactCard(volunteer: volunteer)
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Call for Help")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            })
            .overlay(callStatusIndicator, alignment: .bottom)
        }
    }

    // MARK: - Call Status Indicator overlay
    private var callStatusIndicator: some View {
        Group {
            if callManager.isCallActive {
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
                            callManager.endCall()
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
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: callManager.isCallActive)
            }
        }
    }
}
