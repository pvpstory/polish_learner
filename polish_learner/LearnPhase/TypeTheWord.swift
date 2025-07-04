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
    @State var TypedWord: String
    @State var showResult: Bool = false
    @State var isCorrect: Bool = false
    
    
    
    var body: some View{
        VStack{
            halfFlashCard(text: backside)
            
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

        }
        .onChange(of: backside){
            showResult = false
            TypedWord = ""
            isCorrect = false
        }
            
    }
    func halfFlashCard(text: String) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30).fill(.white)
            Text(backside).font(.headline).foregroundStyle(.black)
        }.frame(width: 600, height: 600).padding(50)
    }
    func onSubmit(){
        showResult = true
        isCorrect = TypedWord.lowercased() == frontside.lowercased( )
        onAnswer(isCorrect)
    }
        
        
}
    
    
    





