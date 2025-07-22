//
//  SwiftUIView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 28/06/2025.
//

import SwiftUI

struct FlashcardView: View {
    @Bindable var flashcard: Flashcard
    let detailView: Bool
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
                        .frame(maxWidth: 300)
                } else {
                    if !detailView {
                        Text("\(flashcard.frontside)")
                            .font(.title3)
                            .frame(maxWidth: 300, alignment: .leading)
                    }else{
                        Text("\(flashcard.frontside)")
                            .font(.title3)
                            .frame(maxWidth: 150, alignment: .leading)
                        }
                    
                }
            }
            
            
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
            if detailView{
                VStack(alignment: .leading){
                    Text("\(flashcard.nextReview)")
                }.frame(maxWidth: 300).font(.title3)
                VStack(alignment: .leading){
                    Text("\(flashcard.successfullReviewsInARow) times in a row")
                }.frame(maxWidth: 300,alignment: .leading).font(.title3)
            }
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


