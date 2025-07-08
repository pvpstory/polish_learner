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
        flashcard.stage == "review"    }) var flashcards: [Flashcard] // change
    @Query var randomFlashcards: [Flashcard] // is it inefficient?
    @State var testFormat: Int = Int.random(in: 0..<2)
    @State var flashcardsCoppy: [Flashcard] = []
    @State var curBackside: String = ""
    @State var curFrontside: String = ""
    @State var curBluredBackside: String = ""
    @State var canClickNext: Bool = false
    @State var whatToShow: String = "noCards"
    @State var currentIndex: Int  = 0
    var body: some View {
        VStack{
            if whatToShow == "noCards"{
                Text("No need to Review Today Bro")
            }
            if whatToShow == "cards"{
                Text("\(currentIndex+1) / \(flashcardsCoppy.count)")
                ZStack {
                    Button(action: {
                        
                    }){
                        Text("Next")
                    }.opacity(0)
                    
                    if canClickNext{
                        Button(action: {
                            incrementIndex()
                        }){
                            Text("Next")
                        }
                    }
                    
                }
                switch testFormat{
                case 0:
                    MultiChoiceWord(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer, allOptionsInput: getOptionWords(), backside_blured: curBluredBackside)
                case 1:
                    TypeTheWord(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer(correct:), backside_blured: curBluredBackside)
                default:
                    Text("WTF????")
                }
                
            }
        }.task {
            //new session
            flashcardsCoppy = Array(flashcards)
            if flashcardsCoppy.count >= 1{
                whatToShow  = "cards"
                curBackside = flashcardsCoppy[currentIndex].backside
                curFrontside = flashcardsCoppy[currentIndex].frontside
                curBluredBackside = flashcards[currentIndex].backside_blured
            }
        }
        
        
    }
    func incrementIndex() {
        if currentIndex >= flashcardsCoppy.count - 1 {
            whatToShow = "noCards"
        }
        else{
            currentIndex += 1
            canClickNext = false
        }
        
        
        
    }
    func onAnwer(correct: Bool) {
        
        canClickNext = true
        
    }
    func getOptionWords() -> [String] {
        //make this func available to the LearnPhaseMainView
        let shuffledFlashcards = randomFlashcards.shuffled() //is it inefficient?
        var frontSides: [String] = []
        for i in 0..<3{
            if shuffledFlashcards.count >= i+1 && shuffledFlashcards[i].frontside != curFrontside{
                frontSides.append(shuffledFlashcards[i].frontside)
            }
            else if shuffledFlashcards[i].frontside == curFrontside && shuffledFlashcards.count >= 5{
                frontSides.append(shuffledFlashcards[4].frontside)
            }
            else{
                frontSides.append("supeRandom")
                
            }
        }
        

        frontSides.append(curFrontside)
        frontSides = frontSides.shuffled()
        return frontSides
    }
}

