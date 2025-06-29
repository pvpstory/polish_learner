//
//  FlashcardListView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 29/06/2025.
//

import SwiftUI
import SwiftData

struct FlashcardListView: View {
    @Query(sort: \flashcard.frontside) var flashcards: [flashcard]
    
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
        let predicate: Predicate<flashcard>?
        
        
        if searchText.isEmpty {
            predicate = nil
        }
        else {
            predicate = #Predicate<flashcard>{ flashcard in
                flashcard.frontside.contains(searchText) || flashcard.backside.contains(searchText)
            }
        }
        _flashcards = Query(filter: predicate)
        
    }
}


#Preview {
    //FlashcardListView()
}
