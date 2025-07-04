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
            
            
            if flashcardsCoppy.count == 0{
                Text("Good Boy")
            }
            else{
                Text("\(currentIndex+1)/\(flashcardsCoppy.count)")
                    .font(.title)
                    .position(x: 50, y: 30)
                if canClickNext{
                    Button(action: {
                        incrementIndex()
                    }) {
                        Image(systemName: "arrow.right")
                    }.position(x: 1400, y: 380)
                }
                switch flashcardsCoppy[currentIndex].stage {
                case "learning":
                    MultiChoiceWord(backside: flashcardsCoppy[currentIndex].backside, frontside: flashcardsCoppy[currentIndex].frontside, onAnswer: onAnswer, allOptionsInput: ["tuka","buka","assasin",flashcardsCoppy[currentIndex].frontside])
                case "new":
                    TypeTheWord(backside: flashcardsCoppy[currentIndex].backside, frontside:
                                    flashcardsCoppy[currentIndex].frontside, onAnswer: onAnswer, TypedWord: "")
                case "reviewed":
                    Text("123123")
                default:
                    Text("def")
                }
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
            canClickNext = false
        }
        else if currentIndex == flashcardsCoppy.count-1 {
            canClickNext = false
            currentIndex = 0
            flashcardsCoppy = []
        }
    }
    private func onAnswer(isSuccess: Bool){
        canClickNext = true
        //change the flashcard
        
    }
    
}

#Preview {
    LearnPhaseMainView()
}
