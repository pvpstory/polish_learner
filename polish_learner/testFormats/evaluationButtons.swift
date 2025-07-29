//
//  evaluationButtons.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/07/2025.
//

import SwiftUI
import Foundation


func EvaluationButton(callFunction: @escaping (Int) -> Void, grade: Int,text: String) -> some View {
    Button(action: {
        callFunction(grade)
    }){
        Text(text)
    }
}
func EvaluationButtons(callFunction: @escaping (Int) -> Void, textArray: [String]) -> some View{
    HStack{
        ForEach(1...6, id: \.self){ i in
            if textArray.count > i-1{
                EvaluationButton(callFunction: callFunction, grade: i, text: textArray[i-1])
            }
            else{
                EvaluationButton(callFunction: callFunction, grade: i, text: "grade \(i)")
            }
        }
    }

}


func NextButton(callFunction: @escaping () -> Void) -> some View{
    Button(action: {
        callFunction()
    }){
        Image(systemName: "arrow.right")
    }.keyboardShortcut(.rightArrow, modifiers: [])
}
