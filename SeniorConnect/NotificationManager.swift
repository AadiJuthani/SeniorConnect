//
//  NotificationManager.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/6/25.
//

import UserNotifications
import Foundation

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                print("Notification permission granted: \(granted)")
                if let error = error {
                    print("Error requesting Notification permission denied: \(error)")
                }
            }
        }
    }
    
    func sendVolunteerAlert(helpType: String) {
        let content = UNMutableNotificationContent()
        content.title = "Help Request"
        content.body = "A senior citizen needs help with: \(helpType)"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Help request notification sent successfully")
            }
        }
    }
}
