//
//  ContentView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/05/2025.
//
import SwiftUI
import SwiftData

struct exampleEntry: Identifiable {
    let id = UUID()
    var example: String
    var isSelected: Bool = false
    var example_blured: String
}

struct definitionEntry: Identifiable {
    let id = UUID()
    var definition: String
    var isSelected: Bool = false
    var examples: [exampleEntry] = []
}
struct Item: Decodable, Identifiable { // Identifiable for SwiftUI lists
    let id: Int
    let name: String
    let description: String?
    let price: Double
}

enum Screen: Hashable {
    case first
    case second
    case third
    case fourth
    case fifth
}
struct ContentView: View {
    let firstPrompt = "12312"
        
    @State var selection: Screen? = .first
    var body: some View{
        NavigationSplitView{
            List(selection: $selection){
                Label("Main View", systemImage: "1.circle").tag(Screen.first)
                Label("All cards", systemImage: "2.circle").tag(Screen.second)
                Label("Learn Phase Flashcards", systemImage: "3.circle").tag(Screen.third)
                Label("Learn", systemImage: "4.circle").tag(Screen.fourth)
                Label("Review", systemImage: "5.circle").tag(Screen.fifth)
            }
            .navigationTitle("Language learner")
            .navigationSplitViewColumnWidth(220)
        } detail: {
            switch selection{
            case .first:
                AddingMainView()
            case .second:
                allFlashcardsView()
            case .third:
                LearnPhaseAllMainView()
            case .fourth:
                LearnPhaseMainView()
            case .fifth:
                ReviewPhaseMainView(curDate: Date.now)
            case .none:
                Text("Select a view")
            }
        }.toolbar{
            ToolbarItemGroup(placement: .keyboard){
                Button("Go to first View"){
                    selection = .first
                }.keyboardShortcut("1", modifiers: [])
                
                Button("Go to second View"){
                    selection = .second
                }.keyboardShortcut("2", modifiers: [])
                Button("Go to third View"){
                    selection = .third
                }.keyboardShortcut("3", modifiers: [])
                Button("Go to the fourth View"){
                    selection = .fourth
                }.keyboardShortcut("4", modifiers: [])
                
                Button("Go to the fifth View"){
                    selection = .fifth
                }.keyboardShortcut("5", modifiers: [])
            }
        }
        
    }
    
}

        
    


#Preview {
    ContentView()
        .modelContainer(for: Flashcard.self, inMemory: true)
}
