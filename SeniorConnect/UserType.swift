// UserType.swift
// SeniorConnect
//
// Created by Aadi Juthani on 9/1/25.
//

import SwiftUI

enum UserType: String, CaseIterable, Codable {
    case senior
    case volunteer

    var displayName: String {
        switch self {
        case .senior:    return "Senior Citizen"
        case .volunteer: return "Volunteer"
        }
    }

    var title: String {
        switch self {
        case .senior:    return "Seniors: Create Account!"
        case .volunteer: return "Join us as a volunteer"
        }
    }

    var subtitle: String {
        switch self {
        case .senior:    return "Get help with your mobile device from caring volunteers"
        case .volunteer: return "Help seniors with their technology needs"
        }
    }

    var buttonText: String {
        switch self {
        case .senior:    return "I Need Help"
        case .volunteer: return "I Want to Volunteer"
        }
    }

    var color: Color {
        switch self {
        case .senior:    return .blue
        case .volunteer: return .green
        }
    }
}
