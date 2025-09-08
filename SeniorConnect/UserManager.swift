// UserManager.swift
// SeniorConnect
//
// Created by Aadi Juthani on 8/31/25.
//

import Foundation
import Combine

final class UserManager: ObservableObject {
    static let shared = UserManager()

    // Published app user (use AppUser, not User)
    @Published var currentUser: AppUser?
    @Published var isLoggedIn: Bool = false

    private let userDefaultsKey = "SeniorConnect.currentUser"
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Load persisted user (if any)
        loadUserData()

        // Optional: automatically persist whenever currentUser changes
        // Uncomment if you want automatic saves on every change
        /*
        $currentUser
            .sink { [weak self] _ in
                self?.saveUserData()
            }
            .store(in: &cancellables)
        */
    }

    // MARK: - Registration / Login / Logout

    /// Register a new user and persist immediately.
    func registerUser(name: String, phone: String, userType: UserType) {
        let newUser = AppUser(name: name, phoneNumber: phone, userType: userType)
        DispatchQueue.main.async {
            self.currentUser = newUser
            self.isLoggedIn = true
            self.saveUserData()
        }
    }

    /// Attempt to log in an existing user by phone number.
    /// Returns true when the provided phone matches the saved user.
    /// (Replace with backend auth when available.)
    func loginUser(phone: String) -> Bool {
        if let saved = currentUser, saved.phoneNumber == phone {
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            return true
        }
        return false
    }

    /// Logs out the current user (does not delete persisted user).
    func logout() {
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }

    // MARK: - Update & Persistence Helpers

    /// Update the current user atomically and persist the change.
    /// Usage: UserManager.shared.updateCurrentUser { $0.name = "New Name" }
    func updateCurrentUser(_ update: (inout AppUser) -> Void) {
        guard var user = currentUser else { return }
        update(&user)
        DispatchQueue.main.async {
            self.currentUser = user
            self.saveUserData()
        }
    }

    // MARK: - Persistence (UserDefaults + JSON)

    /// Save the current user (encoded as JSON) into UserDefaults.
    private func saveUserData() {
        guard let user = currentUser else {
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            return
        }

        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("UserManager: failed to encode user: \(error)")
        }
    }

    /// Load the persisted user (if any) from UserDefaults.
    private func loadUserData() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            currentUser = nil
            isLoggedIn = false
            return
        }

        do {
            let user = try JSONDecoder().decode(AppUser.self, from: data)
            DispatchQueue.main.async {
                self.currentUser = user
                // We do NOT auto-login by default. Set to `true` if you want automatic sign-in.
                self.isLoggedIn = false
            }
        } catch {
            print("UserManager: failed to decode user: \(error)")
            currentUser = nil
            isLoggedIn = false
        }
    }

    // MARK: - Utilities

    /// Completely remove the saved user and reset state.
    func clearSavedUser() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
