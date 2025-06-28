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
    @Environment(\.modelContext) private var context
    
    func deleteFlashcards(_ indexSet: IndexSet) {
        for index in indexSet {
            let flashcard = flashcards[index]
            context.delete(flashcard)
        }
    }
    
    var body: some View {
        VStack{
        List {
            ForEach(flashcards) { flashcard in
                FlashcardView(flashcard: flashcard)
                
            }.onDelete(perform: deleteFlashcards)
            
        }
    }
}
}
#Preview {
    allFlashcardsView().modelContainer(for: flashcard.self, inMemory: true)
}
