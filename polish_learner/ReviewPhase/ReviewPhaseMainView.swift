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
    @Query var flashcards: [Flashcard] //filter at innit
    
    @Query var randomFlashcards: [Flashcard] // is it inefficient?
    @State var testFormat: Int = Int.random(in: 0..<2)
    @State var flashcardsCoppy: [Flashcard] = []
    @State var curBackside: String = ""
    @State var curFrontside: String = ""
    @State var curBluredBackside: String = ""
    @State var whatToShow: String = "noCards"
    @State var currentIndex: Int  = 0
    var body: some View {
        VStack{
            if whatToShow == "noCards"{
                Text("No need to Review Today Bro")
            }
            if whatToShow == "cards"{
                Text("\(currentIndex+1)/\(flashcardsCoppy.count)")
                    .font(.title)
                    .position(x: 50, y: 30)
                
                switch testFormat{
                case 0:
                    TypeTheSentence(backside: curBackside, frontside: curFrontside, onAnswerGrade: changeFlashCardNextReview, definitions: flashcardsCoppy[currentIndex].definition, incrementButtonFunc: incrementIndex)
                case 1:
                    TypeTheWord(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer(correct:), backside_blured: curBluredBackside, onNextFlashcard: incrementIndex, onAnswerGrade: changeFlashCardNextReview, ReviewView: true, evaluationButtonsText: getALLPossibleChangeDates())
                case 11:
                    MultiChoiceDefinition(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer, allOptionsInput: getOptionDefinitions(randomFlashcards: randomFlashcards, curFrontside: curFrontside, curFlashcard: flashcardsCoppy[currentIndex]))
                    
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
            testFormat = Int.random(in: 0..<2)
            currentIndex += 1
            curBackside = flashcardsCoppy[currentIndex].backside
            curFrontside = flashcardsCoppy[currentIndex].frontside
            curBluredBackside = flashcardsCoppy[currentIndex].backside_blured
        }
        
        
        
    }
    func onAnwer(correct: Bool) {
        // do we need correct or do we only use the self evaluation???
    }
    func getALLPossibleChangeDates() -> [String]{
        var allChangeDates: [String] = []
        for i in 1...6{
            var inDays = getPossibleChangeDates(grade: i, successesInARow: flashcardsCoppy[currentIndex].successfullReviewsInARow)
            allChangeDates.append("\(inDays) days")
        }
        return allChangeDates
    }
    func getPossibleChangeDates(grade: Int, successesInARow: Int) -> Int {
        var nextReview = 0
        if grade >= 3{
            if successesInARow >= 0{
                nextReview = (grade-1) * 2
            }
            else if successesInARow == 2{
                nextReview = grade * 2
            }
            else{
                let lastReview = flashcardsCoppy[currentIndex].lastReview
                let components = Calendar.current.dateComponents([.day], from: lastReview, to: Date.now)
                
                if let lastTimeInterval = components.day{
                    nextReview = (lastTimeInterval * Int(flashcardsCoppy[currentIndex].easeFactor))
                }
            }
        }
        else{
            if successesInARow == 0{
                nextReview = 0
            }
            else if successesInARow <= 2{
                nextReview = grade
            }
            else if successesInARow >= 3{
                nextReview = grade * 2
            }
        }
        return nextReview
    }
    func changeFlashCardNextReview(grade: Int){
        //change flashcard based on the grade
        let successesInARow = flashcardsCoppy[currentIndex].successfullReviewsInARow
        //let successes = flashcardsCoppy[currentIndex].successfullReviews
        //let lastTimeInterval = flashcardsCoppy[currentIndex].nextReview - flashcardsCoppy[currentIndex].lastReview
        let nextReview = getPossibleChangeDates(grade: grade, successesInARow: successesInARow)
        if grade >= 3{
            
            flashcardsCoppy[currentIndex].successfullReviewsInARow += 1
            flashcardsCoppy[currentIndex].successfullReviews += 1
            
        }
        else{
            flashcardsCoppy[currentIndex].successfullReviewsInARow = 0
        }
        
        print(String(nextReview) + " days")
        let quality = Double(grade - 1)
        let innerFactor = 0.08 + (5.0 - quality) * 0.02
        let mainTerm = 5.0 - quality * innerFactor
        let newEaseFactor = 0.1 - mainTerm

        flashcardsCoppy[currentIndex].easeFactor += newEaseFactor
                                     
                                     
        flashcardsCoppy[currentIndex].lastReview = Date.now
        flashcardsCoppy[currentIndex].nextReview = Date.now.addingTimeInterval(Double(nextReview * 86000))
        
    }
    
    init(curDate: Date){
        let predicate: Predicate<Flashcard>?
        
        
        predicate = #Predicate<Flashcard>{ flashcard in
            flashcard.nextReview <= curDate && flashcard.stage == "review"}
        
        _flashcards = Query(filter: predicate)
    }
    
    
}

