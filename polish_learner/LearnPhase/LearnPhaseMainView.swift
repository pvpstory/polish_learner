//
//  LearnPhaseMainView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 01/07/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct LearnPhaseMainView: View {
    @Query var learnPhaseFlashCards: [Flashcard]
    @State var flashcardsCoppy: [Flashcard] = []
    @State var currentIndex: Int = 0
    var body: some View {
        VStack{
            Text("\(currentIndex+1)/\(flashcardsCoppy.count)")
                .font(.title)
                .position(x: 50, y: 30)
        }.task {
            startNewSession()
        }

    }

    
    private func startNewSession(){
        flashcardsCoppy = Array(learnPhaseFlashCards)
        currentIndex = 0
        
    }
    
}

#Preview {
    LearnPhaseMainView()
}
