//
//  polish_learnerApp.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/05/2025.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    FirebaseApp.configure()
  }
}

@main
struct polish_learnerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Flashcard.self)
        }
    }
     
}
