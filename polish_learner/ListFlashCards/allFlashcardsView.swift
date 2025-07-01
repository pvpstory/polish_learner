//
//  allFlashcardsView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 20/05/2025.
//

import SwiftUI
import SwiftData

struct allFlashcardsView: View {
    @Query(sort: \Flashcard.frontside) var flashcards: [Flashcard]
    @State var searchText: String = ""
    

    var body: some View {
        NavigationStack{
            FlashCardListView(searchText: searchText).searchable(text: $searchText)
        }
    }
}
#Preview {
    allFlashcardsView().modelContainer(for: Flashcard.self, inMemory: true)
}
