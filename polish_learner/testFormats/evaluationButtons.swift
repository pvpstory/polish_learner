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
func EvaluationButtons(callFunction: @escaping (Int) -> Void) -> some View{
    HStack{
        EvaluationButton(callFunction: callFunction, grade: 1, text: "Grade 1")
        EvaluationButton(callFunction: callFunction, grade: 2, text: "Grade 2")
        EvaluationButton(callFunction: callFunction, grade: 3, text: "Grade 3")
        EvaluationButton(callFunction: callFunction, grade: 4, text: "Grade 4")
        EvaluationButton(callFunction: callFunction, grade: 5, text: "Grade 5")
        EvaluationButton(callFunction: callFunction, grade: 6, text: "Grade 6")
    }
}
