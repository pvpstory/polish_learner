//
//  SwiftUIView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 28/06/2025.
//

import SwiftUI

struct FlashcardView: View {
    @Bindable var flashcard: Flashcard
    @State var isEditing = false
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isDetailsFieldFocused: Bool
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        HStack(spacing: 25){
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("Frontside", text: $flashcard.frontside, axis: .vertical)
                        .font(.title3)
                        .textFieldStyle(.roundedBorder)
                        .focused($isNameFieldFocused)
                } else {
                    Text("\(flashcard.frontside) + \(flashcard.stage) + \(flashcard.nextReview)")
                        .font(.title3)
                        .frame(maxWidth: 500, alignment: .leading)
                }
            }
            .frame(maxWidth: 300)
            
            VStack(alignment: .leading) {
            if isEditing {
                TextEditor(text: $flashcard.backside)
                    .font(.title3)
                    .focused($isDetailsFieldFocused)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                    } else {
                        Text(flashcard.backside)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
               
                .frame(maxWidth: .infinity)
            
            Button(action: {
                isEditing.toggle()
                if isEditing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isNameFieldFocused = true
                    }
                }
            }) {
                Text(isEditing ? "Done" : "Edit")
            }.buttonStyle(.bordered)
            Button(action: {
                withAnimation {
                    modelContext.delete(flashcard)
                }
                
                
            }) {
                Image(systemName: "trash")
                
            }.tint(.red)
                .buttonStyle(.borderless)
            
            
        }.padding(.vertical,10)
    }
}


