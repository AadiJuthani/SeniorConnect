//
//  AppUser.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/7/25.
//

// AppUser.swift
// SeniorConnect
//
// Created by Aadi Juthani on 9/1/25.
//

import Foundation

struct AppUser: Identifiable, Codable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var userType: UserType
    var profileImageURL: String?
    var preferredContactMethod: String?
    var isActive: Bool
    var isRegistered: Bool

    init(name: String,
         phoneNumber: String,
         userType: UserType,
         profileImageURL: String? = nil,
         preferredContactMethod: String? = nil,
         isActive: Bool = true,
         isRegistered: Bool = true) {
        self.id = UUID()
        self.name = name
        self.phoneNumber = phoneNumber
        self.userType = userType
        self.profileImageURL = profileImageURL
        self.preferredContactMethod = preferredContactMethod
        self.isActive = isActive
        self.isRegistered = isRegistered
    }
}
