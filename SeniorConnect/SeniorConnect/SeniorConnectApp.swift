//
//  SeniorConnectApp.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 8/31/25.
//

import SwiftUI

@main
struct SeniorConnectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserManager.shared) // <- required
        }
    }
}

