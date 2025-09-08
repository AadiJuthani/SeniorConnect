//
//  HelpRequest.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/1/25.
//

import Foundation
import SwiftUI

// MARK: - Help Request Model
struct HelpRequest: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    var title: String
    var description: String
    var requestType: RequestType
    var status: RequestStatus
    var createdAt: Date
    var assignedVolunteerId: UUID?
    var attachmentURLs: [String]

    // Derived properties for the dashboard
    var category: HelpCategory {
        switch requestType {
        case .generalHelp:     return .phoneSettings
        case .appSupport:      return .apps
        case .deviceSetup:     return .phoneSettings
        case .troubleshooting: return .phoneSettings
        case .emergency:       return .calls
        }
    }

    var urgencyLevel: UrgencyLevel {
        switch requestType {
        case .emergency:       return .high
        case .troubleshooting: return .medium
        default:               return .low
        }
    }

    var seniorName: String {
        // Replace with real user data lookup later
        return "Senior User"
    }

    var timestamp: Date {
        return createdAt
    }

    // MARK: - Initializer
    init(
        userId: UUID,
        title: String,
        description: String,
        requestType: RequestType
    ) {
        self.id = UUID()
        self.userId = userId
        self.title = title
        self.description = description
        self.requestType = requestType
        self.status = .pending
        self.createdAt = Date()
        self.assignedVolunteerId = nil
        self.attachmentURLs = []
    }
}

// MARK: - Help Category
enum HelpCategory: String, CaseIterable {
    case phoneSettings = "Phone Settings"
    case photos        = "Photos"
    case calls         = "Calls"
    case apps          = "Apps"
    case internet      = "Internet"
    case messages      = "Messages"

    var icon: String {
        switch self {
        case .phoneSettings: return "gear"
        case .photos:        return "photo"
        case .calls:         return "phone"
        case .apps:          return "square.grid.2x2"
        case .internet:      return "wifi"
        case .messages:      return "message"
        }
    }
}

// MARK: - Urgency Level
enum UrgencyLevel: String, CaseIterable {
    case low    = "Low"
    case medium = "Medium"
    case high   = "High"

    var color: Color {
        switch self {
        case .low:    return .green
        case .medium: return .orange
        case .high:   return .red
        }
    }

    /// Higher number = higher urgency (for sorting)
    var rank: Int {
        switch self {
        case .low:    return 0
        case .medium: return 1
        case .high:   return 2
        }
    }
}

// MARK: - Request Type
enum RequestType: String, CaseIterable, Codable {
    case generalHelp     = "General Help"
    case appSupport      = "App Support"
    case deviceSetup     = "Device Setup"
    case troubleshooting = "Troubleshooting"
    case emergency       = "Emergency"
}

// MARK: - Request Status
enum RequestStatus: String, CaseIterable, Codable {
    case pending    = "Pending"
    case inProgress = "In Progress"
    case completed  = "Completed"
    case cancelled  = "Cancelled"
}

