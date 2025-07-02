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
    
    
    var body: some View{
        VStack{
            HStack{
                buttonAnswer(text: allOptions[0])
                buttonAnswer(text: allOptions[1])
            }
            HStack{
                buttonAnswer(text: allOptions[2])
                buttonAnswer(text: allOptions[3])
            }
            
        }.task {
            allOptions.shuffle()
        }
    }
}

func buttonAnswer(text: String) ->  some View {
    Button(text){
        
    }
}

