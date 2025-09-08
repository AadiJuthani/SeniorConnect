//
//  EditProfileView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/7/25.
//
// EditProfileView.swift
// SeniorConnect
//
// Created by You on <date>

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var userManager: UserManager
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var profileImageURL: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Full name", text: $name)
                    TextField("Phone number", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Profile image URL (optional)", text: $profileImageURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Persist changes
                        userManager.updateCurrentUser { user in
                            user.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                            user.phoneNumber = phone.trimmingCharacters(in: .whitespacesAndNewlines)
                            user.profileImageURL = profileImageURL.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        isPresented = false
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || phone.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                // Prefill with current values
                name = userManager.currentUser?.name ?? ""
                phone = userManager.currentUser?.phoneNumber ?? ""
                profileImageURL = userManager.currentUser?.profileImageURL ?? ""
            }
        }
    }
}
