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
    let definitions: String
    @State var backsideShow: String = ""
    @State var TypedWord: String = ""
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    
    
    
    var body: some View{
        VStack{
            Text("Type the example sentence with the correct word").font(.largeTitle).fontWeight(.bold).offset(y: 20)

            halfFlashCard(text: backsideShow)
            
            TextField("Write the sentence", text: $TypedWord).onSubmit {
                Task{
                    await onSubmit()
                }
            }
            .font(.title2)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 600, maxHeight: 80)
            .padding(.bottom, 120)
            ZStack{
                Text("Placeholder")
                    .font(.headline)
                    .opacity(0)
                if showResult{
                    Text(isCorrect ? "Correct!" : "Wrong! The answer is \(frontside)")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                        
                    
                }
            }.frame(height: 30).padding(.top, -120)

        }.task{
            backsideShow = definitions
        }
        .onChange(of: backside){
            backsideShow = definitions
            showResult = false
            TypedWord = ""
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
        do{
            let sentenceFeedback = try await myAi.sentenceAnalysisPrompt(sentence: "12312312")
        }catch{
            print("Error with the sentence analysis", error)
        }
        backsideShow = backside
        showResult = true
        isCorrect = TypedWord.lowercased() == frontside.lowercased( )
        onAnswer(isCorrect)
    }
        
        
}
    
    
    





