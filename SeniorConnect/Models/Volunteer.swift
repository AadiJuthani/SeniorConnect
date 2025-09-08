import SwiftUI

struct Volunteer: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var phoneNumber: String
    var profileImageURL: String?
    var specialties: [VolunteerSpeciality]
    var isAvailable: Bool
    var rating: Double
    var totalHelpSessions: Int
    var joinedDate: Date
}

enum VolunteerSpeciality: String, CaseIterable, Codable{
    case phoneSettings = "Phone Settings"
    case apps = "Apps"
    case internet = "Internet & Wi-Fi"
    case photos = "Photos & Camera"
    case calls = "Calls & Contacts"
    case general = "General Support"
}
