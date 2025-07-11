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
    var backside_blured: String
}

struct LearnPhaseMainView: View {
    @Query(filter: #Predicate<Flashcard>{ flashcard in
        flashcard.stage == "new" || flashcard.stage == "learning"
    }) var learnPhaseFlashCards: [Flashcard]
    @State var flashcardsCoppy: [Flashcard] = []
    @State var currentIndex: Int = 0
    @State var canClickNext: Bool = false
    @State var currentFlashCard: FlashcardCoppy = FlashcardCoppy(frontside: "", backside: "", stage: "", backside_blured: "")
    @State var whatToShow: String = "noCards"
    var body: some View {
        VStack{
            if whatToShow == "noCards"{
                Text("Good Boy")
            }
            else if whatToShow == "cards"{
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
                case "new":
                    MultiChoiceWord(backside: currentFlashCard.backside, frontside: currentFlashCard.frontside, onAnswer: onAnswer, allOptionsInput: ["tuka","buka","assasin",currentFlashCard.frontside], backside_blured: currentFlashCard.backside_blured)
                case "learning":
                    TypeTheWord(backside: currentFlashCard.backside, frontside:
                                    currentFlashCard.frontside, onAnswer: onAnswer, backside_blured: currentFlashCard.backside_blured)
                case "reviewed":
                    Text("123123")
                default:
                    Text("def")
                }
            }
            else if whatToShow == "finishedPortion"{
                Text("Good boy, good job")
                Button(action: {
                    startNewSession()
                }){
                    Text("Next")
                }
                
            }
                        
        }.task {
            startNewSession()
        }
        

    }

    
    private func startNewSession(){
        if learnPhaseFlashCards.count == 0{
            whatToShow = "noCards"
        }
        else{
            flashcardsCoppy = Array(learnPhaseFlashCards)
            currentIndex = 0
            currentFlashCard = FlashcardCoppy(frontside: flashcardsCoppy[currentIndex].frontside, backside: flashcardsCoppy[currentIndex].backside, stage: flashcardsCoppy[currentIndex].stage, backside_blured: flashcardsCoppy[currentIndex].backside_blured)
            whatToShow = "cards"
        }
    }
    private func incrementIndex(){
        
        if currentIndex < flashcardsCoppy.count-1{
            currentIndex+=1
            canClickNext = false
            currentFlashCard = FlashcardCoppy(frontside: flashcardsCoppy[currentIndex].frontside, backside: flashcardsCoppy[currentIndex].backside, stage: flashcardsCoppy[currentIndex].stage, backside_blured: flashcardsCoppy[currentIndex].backside_blured)
        }
        else if currentIndex == flashcardsCoppy.count-1 {
            canClickNext = false
            currentIndex = 0
            flashcardsCoppy = []
            if learnPhaseFlashCards.count == 0{
                whatToShow = "noCards"
            }
            else{
                whatToShow = "finishedPortion"
            }
            
        }
        
    }
    private func onAnswer(isSuccess: Bool){
        canClickNext = true
        if isSuccess{
            if currentFlashCard.stage == "new"{
                flashcardsCoppy[currentIndex].stage = "learning"
            }
            else if currentFlashCard.stage == "learning"{
                flashcardsCoppy[currentIndex].stage = "review"
                //flashcardsCoppy[currentIndex].nextReview = Date.now.addingTimeInterval(86400)
                flashcardsCoppy[currentIndex].nextReview = Date.now
                flashcardsCoppy[currentIndex].lastReview = Date.now
            }
            
        }
        
    }
    
}

#Preview {
    LearnPhaseMainView()
}
