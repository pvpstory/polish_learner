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
            HStack(spacing: 25){
                if !detailView{
                    VStack{
                        Text("Frontside").font(.title2)
                    }.frame(maxWidth: 300, alignment: .leading)
                }else{
                    VStack{
                        Text("Frontside").font(.title2)
                    }.frame(maxWidth: 150,alignment: .leading)
                }
                
                VStack(alignment: .leading){
                    Text("Backside").font(.title2)
                }.frame(maxWidth: .infinity,alignment: .leading)
                
                if detailView{
                    VStack{
                        Text("Next Review Date").font(.title2)
                        
                    }.frame(maxWidth: 300, alignment: .leading)
                    VStack{
                        Text("Succesfull reviews is a row").font(.title2)
                    }.frame(maxWidth: 300,alignment: .leading)
                }
                Button(action: {
                    if true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        }
                    }
                }) {
                    Text("Done")
                }.buttonStyle(.bordered).opacity(0).disabled(true)
                
                Button(action: {
                    withAnimation {
                    }
                    
                    
                }) {
                    Image(systemName: "trash")
                    
                }.tint(.red)
                    .buttonStyle(.borderless)
                    .opacity(0)
                    .disabled(true)
                
            }.padding(10)
            FlashCardListView(searchText: searchText, detailView: detailView).searchable(text: $searchText)
        }.toolbar{
            Toggle("Detail View", isOn: $detailView)
        }
    }
}
#Preview {
    allFlashcardsView().modelContainer(for: Flashcard.self, inMemory: true)
}
