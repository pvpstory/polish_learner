//
//  allFlashcardsView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 20/05/2025.
//

import SwiftUI
import SwiftData

struct allFlashcardsView: View {
    @Query var flashcards: [flashcard]
    @Environment(\.modelContext) var managedContext
    var body: some View {
        
        List {
            
            ForEach(flashcards) { flashcard in
                Text(flashcard.frontside)
                Text(flashcard.backside)
            }
            
        }
    }
}
#Preview {
    allFlashcardsView()
        .modelContainer(for: flashcard.self, inMemory: true)
}
