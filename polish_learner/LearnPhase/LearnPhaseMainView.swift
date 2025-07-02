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
    @State var canClickNext: Bool = false
    var body: some View {
        VStack{
            Text("\(currentIndex+1)/\(flashcardsCoppy.count)")
                .font(.title)
                .position(x: 50, y: 30)
            if flashcardsCoppy.count == 0{
                Text("Good Boy")
            }
            else{
                switch flashcardsCoppy[currentIndex].stage {
                case "new":
                    MultiChoiceWord(backside: flashcardsCoppy[currentIndex].backside, frontside: flashcardsCoppy[currentIndex].frontside, onAnwer: {}, allOptions: ["tuka","buka","assasin",flashcardsCoppy[currentIndex].frontside])
                case "learning":
                    Text("123")
                case "reviewed":
                    Text("123123")
                default:
                    Text("def")
                }
            }
            
            if canClickNext{
                Button(action: {
                    incrementIndex()
                }) {
                    Image(systemName: "arrow.right")
                }.position(x: 1400, y: 0)
            }
            
        }.task {
            startNewSession()
        }
        

    }

    
    private func startNewSession(){
        flashcardsCoppy = Array(learnPhaseFlashCards)
        currentIndex = 0
        
    }
    private func incrementIndex(){
        if currentIndex < flashcardsCoppy.count-1{
            currentIndex+=1
        }
        else if currentIndex == flashcardsCoppy.count-1 {
            
            flashcardsCoppy = []
        }
    }
    
}

#Preview {
    LearnPhaseMainView()
}
