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
    @State  var isFlipped: Bool = false

    @State  var rotation: Double = 0

    var body: some View {
        ZStack {
            CardSide(text: flashcard.frontside)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            CardSide(text: flashcard.backside)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotation + 180), // Start with the back facing away
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )

        }.onTapGesture {
            flipCard()

        }
    }
    private func flipCard() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isFlipped.toggle()
            rotation += 180
        }
    }
}





struct CardSide: View {
    let text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.white)
            Text(text).font(.title3).foregroundStyle(.black)
        }.frame(width: 400, height: 400)

    }
}

