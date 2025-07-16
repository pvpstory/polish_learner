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
    let onAnswer: (Bool) -> Void
    let definitions: [String]
    @State var backsideShow: String = ""
    @State var typedSentence: String = ""
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    @State var isLoading: Bool = false
    @State var sentenceFeedback: SentenceAnalyticsFeedback = SentenceAnalyticsFeedback(correct: false, coreCorrection: "", deeperDive: "")
    
    
    
    var body: some View{
        VStack{
            Text("Type the example sentence with the correct word").font(.largeTitle).fontWeight(.bold).offset(y: 20)
            
            
            VStack{
                if showResult{
                    if sentenceFeedback.correct{
                        Text("Good Job! No errors and correct usage")
                            .foregroundStyle(.green)
                            .fixedSize(horizontal: false, vertical: false) // Ensures text wraps
                    }
                    else{
                        Text("Unfortunately your sentence isn't entirely correct")
                            .foregroundStyle(.red)
                    }
                    if !sentenceFeedback.correct{
                        Text(sentenceFeedback.coreCorrection)
                            .fixedSize(horizontal: false, vertical: true) // Ensures text wraps
                            .cornerRadius(8)
                    }
                    
                    Text(sentenceFeedback.deeperDive)
                        .fixedSize(horizontal: false, vertical: false) // Ensures text wraps
                    
                }
            }.position(x: 200, y: 100)
                halfFlashCard(text: backsideShow)
                
            
            
            TextField("Write the sentence", text: $typedSentence).onSubmit {
                Task{
                    await onSubmit()
                }
            }
            .font(.title2)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 600, maxHeight: 80)
            .padding(.bottom, 120)
            
            
            if isLoading{
                ProgressView().progressViewStyle(CircularProgressViewStyle())
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
        isCorrect = typedSentence.lowercased() == frontside.lowercased( )
        onAnswer(isCorrect)
        isLoading = false
    }
        
        
}
    
    
    





