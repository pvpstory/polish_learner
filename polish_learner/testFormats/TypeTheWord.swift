//
//  MultiChoiceWord.swift
//  polish_learner
//
//  Created by Микола Ясінський on 02/07/2025.
//



import Foundation
import SwiftUI



struct TypeTheWord: View {
    let backside: String
    let frontside: String
    let onAnswer: (Bool) -> Void
    let backside_blured: String
    let onNextFlashcard: () -> Void
    let onAnswerGrade: ((Int) -> Void)?
    let ReviewView: Bool
    @State var backsideShow: String = ""
    @State var TypedWord: String = ""
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    @State var canClickNext: Bool = false
    
    
    
    
    var body: some View{
        VStack{
            Text("Type the correct word").font(.largeTitle).fontWeight(.bold).offset(y: 25)
            HStack{
                NextButton(callFunction: {}).opacity(0).offset(y: 50).padding(10)
                Spacer()
                halfFlashCard(text: backsideShow)
                
                Spacer()
                ZStack{
                    if (showResult && !ReviewView) || (ReviewView && canClickNext){
                        NextButton(callFunction: onNextFlashcard)
                    }
                    else{
                        NextButton(callFunction: {}).opacity(0)
                    }
                }.offset(y: 50).padding(10)
            }.frame(maxWidth: .infinity)
            
            TextField("Guees the word", text: $TypedWord).onSubmit {
                onSubmitWord()
            }
            .font(.title2)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 600, maxHeight: 80)
            .padding(.bottom, 120)
            
            if ReviewView{
                if showResult{
                    EvaluationButtons(callFunction: onGrade).disabled(canClickNext).offset(y: -30)
                    
                }
                else{
                    EvaluationButtons(callFunction: onAnswerGradeEmpty).opacity(0)
                }
            }
            ZStack{
                Text("Placeholder")
                    .font(.headline)
                    .opacity(0)
                if showResult {
                    Text(isCorrect ? "Correct!" : "Wrong! The answer is \(frontside)")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                }
            }.frame(height: 30).padding(.top, -120)

        }.task{
            backsideShow = backside_blured
        }
        .onChange(of: backside){
            backsideShow = backside_blured
            showResult = false
            TypedWord = ""
            isCorrect = false
            canClickNext = false
        }
            
    }
    func halfFlashCard(text: String) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30).fill(.white)
            Text(text).font(.headline).foregroundStyle(.black)
        }.frame(width: 600, height: 600).padding(50)
    }
    func onSubmitWord(){
        backsideShow = backside
        showResult = true
        isCorrect = TypedWord.lowercased() == frontside.lowercased( )
        onAnswer(isCorrect)
    }
    
    func onGrade(grade: Int){
        canClickNext = true
        if let gradeFunc = onAnswerGrade{
            gradeFunc(grade)
        }
        else{
            print("Error, no grade function provided")
        }
        
    }
    func onAnswerGradeEmpty(grade: Int){
        
    }
    
    
        
        
}
    
    
    





