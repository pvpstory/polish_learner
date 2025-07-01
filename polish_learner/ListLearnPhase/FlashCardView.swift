//
//  FlashCardView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 01/07/2025.
//

import Foundation
import SwiftUI

struct FlashCardView: View {
    let flashcard: flashcard
    @State private var isFlipped: Bool = false
    
    var body: some View {
        ZStack {
            CardSide(text: flashcard.frontside).opacity(isFlipped ? 0 : 1)
            CardSide(text: flashcard.backside).opacity(isFlipped ? 1 : 0)
            
        }.onTapGesture {
            isFlipped.toggle()
        }
    }
}

struct CardSide: View {
    let text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.green)
            
            
            Text(text).font(.title3)
        }.frame(width: 400, height: 400)
        
    }
}

