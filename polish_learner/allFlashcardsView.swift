//
//  allFlashcardsView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 20/05/2025.
//

import SwiftUI
import SwiftData

struct allFlashcardsView: View {
    @Query(sort: \flashcard.frontside) var flashcards: [flashcard]
    @State var searchText: String = ""
    

    var body: some View {
        NavigationStack{
            FlashcardListView(searchText: searchText).searchable(text: $searchText)
        }
    }
}
#Preview {
    allFlashcardsView().modelContainer(for: flashcard.self, inMemory: true)
}
