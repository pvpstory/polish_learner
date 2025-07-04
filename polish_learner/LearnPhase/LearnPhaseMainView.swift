//
//  LearnPhaseMainView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 01/07/2025.
//
    
import Foundation
import SwiftUI
import SwiftData

struct FlashcardCoppy{
    var frontside: String
    var backside: String
    var stage: String
}

struct LearnPhaseMainView: View {
    @Query var learnPhaseFlashCards: [Flashcard]
    @State var flashcardsCoppy: [Flashcard] = []
    @State var currentIndex: Int = 0
    @State var canClickNext: Bool = false
    @State var currentFlashCard: FlashcardCoppy = FlashcardCoppy(frontside: "", backside: "", stage: "")
    var body: some View {
        VStack{
            
            
            if flashcardsCoppy.count == 0{
                Text("Good Boy")
            }
            else{
                Text("\(currentIndex+1)/\(flashcardsCoppy.count)")
                    .font(.title)
                    .position(x: 50, y: 30)
                ZStack{
                    Button(action : {
                        
                    }) {
                        Image(systemName: "arrow.right")
                    }.position(x: 1400, y: 380).opacity(0)
                    if canClickNext{
                        Button(action: {
                            incrementIndex()
                        }) {
                            Image(systemName: "arrow.right")
                        }.position(x: 1400, y: 380)
                    }
                }
                switch currentFlashCard.stage {
                case "learning":
                    MultiChoiceWord(backside: currentFlashCard.backside, frontside: currentFlashCard.frontside, onAnswer: onAnswer, allOptionsInput: ["tuka","buka","assasin",currentFlashCard.frontside])
                case "new":
                    TypeTheWord(backside: currentFlashCard.backside, frontside:
                                    currentFlashCard.frontside, onAnswer: onAnswer, TypedWord: "")
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
        print("triggered")
        currentFlashCard = FlashcardCoppy(frontside: flashcardsCoppy[currentIndex].frontside, backside: flashcardsCoppy[currentIndex].backside, stage: flashcardsCoppy[currentIndex].stage)
    }
    private func incrementIndex(){
        
        if currentIndex < flashcardsCoppy.count-1{
            currentIndex+=1
            canClickNext = false
            currentFlashCard = FlashcardCoppy(frontside: flashcardsCoppy[currentIndex].frontside, backside: flashcardsCoppy[currentIndex].backside, stage: flashcardsCoppy[currentIndex].stage)
        }
        else if currentIndex == flashcardsCoppy.count-1 {
            canClickNext = false
            currentIndex = 0
            flashcardsCoppy = []
        }
        
    }
    private func onAnswer(isSuccess: Bool){
        canClickNext = true
        if isSuccess{
            flashcardsCoppy[currentIndex].stage = "learning"
        }
        
    }
    
}

#Preview {
    LearnPhaseMainView()
}
