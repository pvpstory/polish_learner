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
    @State var canClickNext: Bool = false
    @State var whatToShow: String = "noCards"
    @State var currentIndex: Int  = 0
    @State var canShowSelfEvaluation = false
    @State var evaluationGrade: Int = -1
    var body: some View {
        VStack{
            if whatToShow == "noCards"{
                Text("No need to Review Today Bro")
            }
            if whatToShow == "cards"{
                Text("\(currentIndex+1) / \(flashcardsCoppy.count)")
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
                switch testFormat{
                case 0:
                    MultiChoiceWord(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer, allOptionsInput: getOptionWords(), backside_blured: curBluredBackside)
                case 1:
                    TypeTheWord(backside: curBackside, frontside: curFrontside, onAnswer: onAnwer(correct:), backside_blured: curBluredBackside)
                default:
                    Text("WTF????")
                }
                
                ZStack{
                    EvaluationButton(grade: 1, text: "grade 1").opacity(0)
                    EvaluationButton(grade: 2, text: "grade 2").opacity(0)
                    EvaluationButton(grade: 3, text: "grade 3").opacity(0)
                    EvaluationButton(grade: 4, text: "grade 4").opacity(0)
                    EvaluationButton(grade: 5, text: "grade 5").opacity(0)
                    EvaluationButton(grade: 6, text: "grade 6").opacity(0)
                    
                    if canShowSelfEvaluation{
                        HStack(spacing: 10){
                            
                            EvaluationButton(grade: 1, text: "grade 1")
                            EvaluationButton(grade: 2, text: "grade 2")
                            EvaluationButton(grade: 3, text: "grade 3")
                            EvaluationButton(grade: 4, text: "grade 4")
                            EvaluationButton(grade: 5, text: "grade 5")
                            EvaluationButton(grade: 6, text: "grade 6")
                            
                            
                        }
                    }
                    
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
            canShowSelfEvaluation = false
            evaluationGrade = -1
        }
        
        
        
    }
    func onAnwer(correct: Bool) {
        // do we need correct or do we only use the self evaluation???
        canShowSelfEvaluation = true
        
    }
    func changeFlashCardNextReview(){
        //change flashcard based on the grade
        let successesInARow = flashcardsCoppy[currentIndex].successfullReviewsInARow
        let successes = flashcardsCoppy[currentIndex].successfullReviews
        //let lastTimeInterval = flashcardsCoppy[currentIndex].nextReview - flashcardsCoppy[currentIndex].lastReview
        var nextReview = 0
        if evaluationGrade >= 3{
            if successesInARow >= 0{
                nextReview = (evaluationGrade-1) * 2
            }
            else if successesInARow == 2{
                nextReview = evaluationGrade * 2
            }
            else{
                //nextReview = (lastTineInterval * EaseFactor)
                //make grade matter here?
            }
            flashcardsCoppy[currentIndex].successfullReviewsInARow += 1
            
        }
        else{
            if successesInARow == 1{
                nextReview = 1
            }
            else if successesInARow == 2{
                nextReview = evaluationGrade
            }
            else if successesInARow >= 3{
                nextReview = evaluationGrade * 2
            }
            flashcardsCoppy[currentIndex].successfullReviewsInARow = 0
        }
        print(Double(nextReview * 86000))
        flashcardsCoppy[currentIndex].nextReview = Date.now.addingTimeInterval(Double(nextReview * 86000))
        
    }
    func getOptionWords() -> [String] {
        //make this func available to the LearnPhaseMainView
        let shuffledFlashcards = randomFlashcards.shuffled() //is it inefficient?
        var frontSides: [String] = []
        for i in 0..<3{
            if shuffledFlashcards.count >= i+1 && shuffledFlashcards[i].frontside != curFrontside{
                frontSides.append(shuffledFlashcards[i].frontside)
            }
            else if shuffledFlashcards.count >= 5 && shuffledFlashcards[i].frontside == curFrontside{
                frontSides.append(shuffledFlashcards[4].frontside)
            }
            else{
                frontSides.append("supeRandom\(i)" )
                
            }
        }
        print(frontSides)
        

        frontSides.append(curFrontside)
        frontSides = frontSides.shuffled()
        return frontSides
    }
    func getOptionDefinitions() -> [String] {
        let shuffledFlashcards = randomFlashcards.shuffled()
        var definitions: [String] = []
        var randomIndex: Int = 0
        for i in 0..<3{
            if shuffledFlashcards.count >= i+1 && shuffledFlashcards[i].frontside != curFrontside{
                randomIndex = Int.random(in: 0..<shuffledFlashcards[i].definition.count)
                definitions.append(shuffledFlashcards[i].definition[randomIndex])
            }
            else if shuffledFlashcards.count >= 5 && shuffledFlashcards[i].frontside == curFrontside{
                randomIndex = Int.random(in: 0..<shuffledFlashcards[4].definition.count)
                definitions.append(shuffledFlashcards[4].definition[randomIndex])
                
            }
            else{
                definitions.append("not enough]\(i)") // take other indexes instead
            }
            
        }
        randomIndex = Int.random(in: 0..<flashcardsCoppy[currentIndex].definition.count)
        definitions.append(flashcardsCoppy[currentIndex].definition[randomIndex])
        return definitions
    }
    func EvaluationButton(grade: Int,text: String) -> some View {
        Button(action:{
            evaluationGrade = grade
            canClickNext = true
            changeFlashCardNextReview()
            
        }){
            Text(text)
        }.disabled(evaluationGrade != -1)
        
    }
    init(curDate: Date){
        let predicate: Predicate<Flashcard>?
        
        
        
        predicate = #Predicate<Flashcard>{ flashcard in
            flashcard.nextReview <= curDate && flashcard.stage == "review"}
        
        _flashcards = Query(filter: predicate)
    }
    
    
}

