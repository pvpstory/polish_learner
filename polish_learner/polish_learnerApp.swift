//
//  polish_learnerApp.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/05/2025.
//

import SwiftUI
import SwiftData

@main
struct polish_learnerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: flashcard.self)
        }
    }
}
