//
//  FlashcardListView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 29/06/2025.
//

import SwiftUI
import SwiftData

struct FlashCardListView: View {
    @Query(sort: \Flashcard.frontside) var flashcards: [Flashcard]
    
    var body: some View {
        
            VStack {
                List {
                    ForEach(flashcards) { flashcard in
                        FlashcardView(flashcard: flashcard)
                    }
                }
            }
        }
    init(searchText: String){
        let predicate: Predicate<Flashcard>?
        
        
        if searchText.isEmpty {
            predicate = nil
        }
        else {
            predicate = #Predicate<Flashcard>{ flashcard in
                flashcard.frontside.contains(searchText) || flashcard.backside.contains(searchText)
            }
        }
        _flashcards = Query(filter: predicate)
        
    }
}


#Preview {
    //FlashcardListView()
}
