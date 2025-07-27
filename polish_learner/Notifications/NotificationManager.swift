//
//  NotificationManager.swift
//  polish_learner
//
//  Created by Микола Ясінський on 27/07/2025.
//

import Foundation
import SwiftUI
import UserNotifications





struct NotificationManager {
    static let reccuringIdNotification1 = "reccuringIdofNot1"
    
    static func scheduleRegularNotification(settings: NotificationSettings){
        deleteRegularNotification1()
        
        let calendar = Calendar.current
        let content = UNMutableNotificationContent()
        let center = UNUserNotificationCenter.current()
        content.sound = UNNotificationSound.default
        content.title = "Regular Reminder"
        content.body = "Don't forget to practise your words"
        
        
        for i in 0...16{
            let dayOffSet = i * settings.notificationIntervalInDays
            
            guard let triggerDate = calendar.date(byAdding: .day, value: dayOffSet, to: Date()) else{
                print("crash1, error")
                continue
            }
            
            var dateComponents = calendar.dateComponents([.year, .hour, .minute], from: triggerDate)
            
            dateComponents.hour = calendar.component(.hour, from: settings.notificationTime)
            dateComponents.minute = calendar.component(.minute, from: settings.notificationTime)
            
            guard let checkTrigger = calendar.date(from: dateComponents), checkTrigger < Date() else{
                continue
            }
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let id = "\(reccuringIdNotification1)\(i)"
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
            print("added \(i) notification")
        }
        
        
    }
    
    
    
    private static func deleteRegularNotification1() {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .map { $0.identifier }
                .filter { $0.hasPrefix(reccuringIdNotification1) }
            if !identifiersToRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
                print("cleared \(identifiersToRemove.count) notifications")
            }
            else{
                print("no notifications to delete")
            }
        }
    }
        
}
    
    

