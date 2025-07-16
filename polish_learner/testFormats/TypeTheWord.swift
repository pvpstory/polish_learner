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
    @State var backsideShow: String = ""
    @State var TypedWord: String = ""
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    
    
    
    var body: some View{
        VStack{
            Text("Type the correct word").font(.largeTitle).fontWeight(.bold).offset(y: 20)

            halfFlashCard(text: backsideShow)
            
            TextField("Guees the word", text: $TypedWord).onSubmit {
                onSubmit()
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
            backsideShow = backside_blured
        }
        .onChange(of: backside){
            backsideShow = backside_blured
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
    func onSubmit(){
        backsideShow = backside
        showResult = true
        isCorrect = TypedWord.lowercased() == frontside.lowercased( )
        onAnswer(isCorrect)
    }
        
        
}
    
    
    





