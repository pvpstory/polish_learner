//
//  MultiChoiceWord.swift
//  polish_learner
//
//  Created by Микола Ясінський on 02/07/2025.
//



import Foundation
import SwiftUI



struct MultiChoiceWord: View {
    let backside: String
    let frontside: String
    let onAnwer: () -> Void
    @State var allOptions: [String]
    @State var selectedAnswer: String?
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    var body: some View{
        VStack{
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(allOptions,id: \.self) { option in
                buttonAnswer(text: option)}
            }
            
        }.task {
            allOptions.shuffle()
        }
    }
    func buttonAnswer(text: String) ->  some View {
        Button(action: {
            if selectedAnswer == nil{
                selectedAnswer = text
            }
        }){
            Text(text).font(.title).foregroundStyle(.black)
            
        }.background(backgroundColorFor(option: text))
    }
    
    func backgroundColorFor(option: String) -> Color{
        if option == selectedAnswer && option != frontside{
            return .red
        }
        else if option == frontside && option == selectedAnswer{
            return .green
        }
        else{
            if option == frontside && selectedAnswer != nil{
                return .green.opacity(0.5)
            }
            return .white
        }
        
    }

}


func buttonClicled(answer: String){
    
}

