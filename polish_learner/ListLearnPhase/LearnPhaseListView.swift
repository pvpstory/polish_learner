//
//  LearnPhase.swift
//  polish_learner
//
//  Created by Микола Ясінський on 01/07/2025.
//

import SwiftUI
import SwiftData

struct LearnPhaseListView: View {
    @Query var flashcards: [flashcard]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30){
                ForEach(flashcards) { flashcard in
                    FlashCardView(flashcard: flashcard)}
            }
        }
    }
}

