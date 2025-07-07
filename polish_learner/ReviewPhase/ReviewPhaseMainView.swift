//
//  ReviewPhaseMainView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 07/07/2025.
//

import SwiftUI
import SwiftData
//make a ZStack for the next button
//when it's clicked or during task we randomly choose the regime the next card is gonna be
// switch , case based on the random
struct ReviewPhaseMainView: View {
    @Query(filter: #Predicate<Flashcard> { flashcard in
        flashcard.nextReview == Date()
    }) var flashcards: [Flashcard]
    @State var flashcardsCoppy: [Flashcard] = []
    var body: some View {
        VStack{
            
        }.task {
            flashcardsCoppy = Array(flashcards)
        }
    }
}

