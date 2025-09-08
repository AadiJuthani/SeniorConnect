//
//  VolunteerManager.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/7/25.


import Foundation
import Combine

final class VolunteerManager: ObservableObject {
    static let shared = VolunteerManager()

    @Published private(set) var volunteers: [Volunteer] = []
    private let userDefaultsKey = "SeniorConnect.volunteers"

    private init() {
        loadVolunteers()
        // If none exist and you want a local seed for dev, uncomment:
        // if volunteers.isEmpty { loadSampleVolunteers() }
    }

    // MARK: - Querying

    /// Returns the first available volunteer (or nil).
    /// Replace selection logic with better matching (distance, skills, rating) as needed.
    func getAvailableVolunteer() -> Volunteer? {
        return volunteers.first { $0.isAvailable }
    }

    /// Returns the best candidate using a simple heuristic (highest rating & available)
    func getBestAvailableVolunteer() -> Volunteer? {
        return volunteers
            .filter { $0.isAvailable }
            .sorted { $0.rating > $1.rating }
            .first
    }

    // MARK: - CRUD

    func addVolunteer(_ volunteer: Volunteer) {
        volunteers.append(volunteer)
        saveVolunteers()
    }

    func updateVolunteer(_ id: UUID, _ update: (inout Volunteer) -> Void) {
        guard let idx = volunteers.firstIndex(where: { $0.id == id }) else { return }
        var v = volunteers[idx]
        update(&v)
        volunteers[idx] = v
        saveVolunteers()
    }

    func removeVolunteer(_ id: UUID) {
        volunteers.removeAll { $0.id == id }
        saveVolunteers()
    }

    // MARK: - Persistence

    private func saveVolunteers() {
        do {
            let data = try JSONEncoder().encode(volunteers)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("VolunteerManager: failed to encode volunteers: \(error)")
        }
    }

    private func loadVolunteers() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            volunteers = []
            return
        }
        do {
            volunteers = try JSONDecoder().decode([Volunteer].self, from: data)
        } catch {
            print("VolunteerManager: failed to decode volunteers: \(error)")
            volunteers = []
        }
    }

    // Optional: dev helper to populate a few volunteers for testing
    func loadSampleVolunteers() {
        let v1 = Volunteer(
            id: UUID(),
            name: "Alice Volunteer",
            email: "alice@example.com",
            phoneNumber: "1234567890",
            profileImageURL: nil,
            specialties: [.general],
            isAvailable: true,
            rating: 4.8,
            totalHelpSessions: 42,
            joinedDate: Date(timeIntervalSinceNow: -60*60*24*200)
        )
        let v2 = Volunteer(
            id: UUID(),
            name: "Bob Helper",
            email: "bob@example.com",
            phoneNumber: "0987654321",
            profileImageURL: nil,
            specialties: [.apps, .photos],
            isAvailable: false,
            rating: 4.6,
            totalHelpSessions: 30,
            joinedDate: Date(timeIntervalSinceNow: -60*60*24*300)
        )
        volunteers = [v1, v2]
        saveVolunteers()
    }

    // MARK: - Backend hook
    // Replace this method to fetch volunteers from your server and populate `volunteers`.
    func fetchFromServer(completion: (() -> Void)? = nil) {
        // implement network call; on success assign `self.volunteers = fetched` and `saveVolunteers()`
        completion?()
    }
}
