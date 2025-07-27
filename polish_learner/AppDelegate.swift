//
//  AppDelegate.swift
//  polish_learner
//
//  Created by Микола Ясінський on 27/07/2025.
//
import AppKit
import FirebaseCore
import UserNotifications
import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
      FirebaseApp.configure()
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error{
                print("Error requesting notification permission: \(error)")
            }
            if granted{
                print("Notification permission granted")
            }
            else{
                print("Notification permission denied")
            }
        }
    }
}
