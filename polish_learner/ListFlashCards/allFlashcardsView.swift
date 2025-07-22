//
//  allFlashcardsView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 20/05/2025.
//

import SwiftUI
import SwiftData

struct allFlashcardsView: View {
    @State var searchText: String = ""
    @State var detailView: Bool = false

    var body: some View {
        NavigationStack{
            FlashCardListView(searchText: searchText, detailView: detailView).searchable(text: $searchText)
        }.toolbar{
            Toggle("Detail View", isOn: $detailView)
        }
    }
}
#Preview {
    allFlashcardsView().modelContainer(for: Flashcard.self, inMemory: true)
}
