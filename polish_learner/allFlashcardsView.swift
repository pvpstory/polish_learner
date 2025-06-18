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
    
    var body: some View {
        VStack{
            
        
        List {
            ForEach(flashcards) { flashcard in
                VStack{
                    Text(flashcard.frontside)
                    Text(flashcard.backside)
                }
                
            }
            
        }
    }
}
}
#Preview {
    allFlashcardsView().modelContainer(for: flashcard.self, inMemory: true)
}
