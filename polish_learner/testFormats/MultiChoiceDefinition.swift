//
//  MultiChoiceWord.swift
//  polish_learner
//
//  Created by Микола Ясінський on 02/07/2025.
//



import Foundation
import SwiftUI



struct MultiChoiceDefinition: View {
    let backside: String
    let definition: String
    let frontside: String
    let onAnswer: (Bool) -> Void
    var allOptionsInput: [String]
    @State var backsideShow: String = ""
    @State var allOptions: [String] = []
    @State var selectedAnswer: String?
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    var body: some View{
        VStack{
            halfFlashCard(text: frontside).offset(y: -50)
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(allOptions,id: \.self) { option in
                buttonAnswer(text: option)}
            }
        }.task {
            allOptions = allOptionsInput.shuffled()
                    }
        .onChange(of: allOptionsInput){
            
            allOptions = allOptionsInput.shuffled()
            selectedAnswer = nil
        }
    }
    func halfFlashCard(text: String) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30).fill(.white)
            Text(text).font(.headline).foregroundStyle(.black)
        }.frame(width: 600, height: 600)
    }
    func buttonAnswer(text: String) ->  some View {
        Button(action: {
            if selectedAnswer == nil{
                selectedAnswer = text
            }
            
            onAnswer(selectedAnswer == definition)
            
        }){
            Text(text).font(.headline).frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .foregroundStyle(.black)
                .padding()
            
        }
            .background(backgroundColorFor(option: text))
            .shadow(radius: 3)
            .animation(.easeInOut(duration: 0.3), value: selectedAnswer)
            .disabled(selectedAnswer != nil)
    }
    
    func backgroundColorFor(option: String) -> Color{
        if option == selectedAnswer && option != definition{
            return .red
        }
        else if option == definition && option == selectedAnswer{
            return .green
        }
        else{
            if option == definition && selectedAnswer != nil{
                return .green.opacity(0.5)
            }
            return .white
        }
        
    }

}



