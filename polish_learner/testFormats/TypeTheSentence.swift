//
//  MultiChoiceWord.swift
//  polish_learner
//
//  Created by Микола Ясінський on 02/07/2025.
//



import Foundation
import SwiftUI


//struct SentenceAnalyticsFeedback: Codable {
//    let correct: Bool
//    let coreCorection: String
//    let deeperDive: String
//}


struct TypeTheSentence: View {
    let backside: String
    let frontside: String
    let onAnswerGrade: (Int) -> Void
    let definitions: [String]
    let incrementButtonFunc: () -> Void
    @State var canShowEvaluation: Bool = false
    @State var canClickNext: Bool = false
    @State var backsideShow: String = ""
    @State var typedSentence: String = ""
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    @State var isLoading: Bool = false
    @State var sentenceFeedback: SentenceAnalyticsFeedback = SentenceAnalyticsFeedback(correct: false, coreCorrection: "", deeperDive: "")
    var body: some View{
        VStack{
            Text("Type the example sentence with the correct word").font(.largeTitle).fontWeight(.bold).offset(y: 20)
            
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    if isLoading{
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                    if showResult{
                        if sentenceFeedback.correct{
                            Text("Good Job! No errors and correct usage")
                                .font(.headline)
                                .lineLimit(nil)
                                .foregroundStyle(.green)
                        }
                        else{
                            Text("Unfortunately your sentence isn't entirely correct")
                                .foregroundStyle(.red)
                        }
                        if !sentenceFeedback.correct{
                            Text(sentenceFeedback.coreCorrection)
                                .cornerRadius(8)
                        }
                        
                        Text(sentenceFeedback.deeperDive)
                            .font(.headline)
                            .lineLimit(nil)
                        
                    }
                }.frame(maxWidth: 340, alignment: .leading).padding(15)

                
                halfFlashCard(text: backsideShow).padding(.horizontal)
                Spacer()
                if canClickNext{
                    NextButton(callFunction: incrementButtonFunc).offset(y: 50).padding(10)
                }
                
            }.frame(maxWidth: .infinity)
                
            
            
            TextField("Write the sentence", text: $typedSentence).onSubmit {
                Task{
                    await onSubmit()
                }
            }
            .font(.title2)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 600, maxHeight: 80)
            .padding(.bottom, 120)
            ZStack{
                if canShowEvaluation{
                    EvaluationButtons(callFunction: onGrade).offset(y: -50).disabled(canClickNext)
                }
                else{
                    EvaluationButtons(callFunction: onAnswerGradeEmpty).offset(y: -50).opacity(0)
                }
            }
            
            

        }.task{
            for definition in definitions {
                backsideShow += definition + "\n"
            }
        }
        .onChange(of: backside){
            for definition in definitions {
                backsideShow += definition + "\n"
            }
            canClickNext = false
            canShowEvaluation = false
            showResult = false
            typedSentence = ""
            isCorrect = false
        }
            
    }
    func halfFlashCard(text: String) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30).fill(.white)
            Text(text).font(.headline).foregroundStyle(.black)
        }.frame(width: 600, height: 600).padding(50)
    }
    func onSubmit() async{
        let myAi = AI()
        isLoading = true
        do{
            sentenceFeedback = try await myAi.analyze_sentence(sentence: typedSentence, word: frontside)
        }catch{
            print("Error with the sentence analysis", error)
        }
        print(sentenceFeedback.deeperDive)
        backsideShow = backside
        showResult = true
        canShowEvaluation = true
        isCorrect = typedSentence.lowercased() == frontside.lowercased( )
        isLoading = false
    }
    func onGrade(grade: Int){
        canClickNext = true
        onAnswerGrade(grade)
    }
    func onAnswerGradeEmpty(grade: Int){
        
    }
        
        
}
    
    
    





