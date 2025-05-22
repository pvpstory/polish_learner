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
}

struct definitionEntry: Identifiable {
    let id = UUID()
    var defintion: String
    var isSelected: Bool = false
    var examples: [exampleEntry] = []
}


struct ContentView: View {
    @Query  var flashcards: [flashcard]
    @Environment(\.modelContext) private var context
    @State var definitions = [definitionEntry]()
   
    func submittedWord(){
        definitions.append(definitionEntry( defintion: "karakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakaraka"))
        definitions.append(definitionEntry( defintion: "karakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakaraka"))
    }
    func submitDefenitions(){
        for (i,definition) in definitions.enumerated(){
            if definition.isSelected == false{
                definitions.remove(at: i)
            }
        }
        definitions[0].examples.append(exampleEntry(example: "duradura dada"))
    }
    func submitExamples(){
        let new_flashcard = flashcard(
            id: 1, // This 'Int' id is for the initializer, the actual UUID is generated inside
            frontside: "Jabłko",
            backside: "Apple",
            definition: "A round fruit with firm, white flesh and a green or red skin.",
            examples: [
                "Lubię jeść czerwone jabłka. (I like to eat red apples.)",
                "Szarlotka jest zrobiona z jabłek. (Apple pie is made from apples.)"
            ]
        )
        print("sumbit")
        context.insert(new_flashcard)
        definitions = []
        text = ""
        print(flashcards)
        
    }
    
    @State private var text = ""
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    allFlashcardsView()
                } label: {
                    Label("View All Flashcards", systemImage: "list.bullet.rectangle.portrait")
                }
                .padding(.bottom) // Add some spacing
                if (definitions.isEmpty){
                    TextField("Enter",text: $text).onSubmit {
                        submittedWord()
                    }
                }
                if(definitions.isEmpty == false){
                    
                    List{
                        ForEach($definitions){ $definition in
                            
                            
                            
                            Toggle(definition.defintion, isOn: $definition.isSelected)
                            ForEach($definition.examples){ $example in
                                Toggle(example.example,isOn : $example.isSelected)
                            }.offset(x:50)
                        }
                        
                    }
                    HStack{
                        Spacer()
                        if (definitions.count > 0 && definitions[0].examples.isEmpty){
                            Button("submit", action: submitDefenitions)
                        }
                        else{
                            Button("sumbit example",action: submitExamples)
                        }
                        Spacer()
                        
                    }
                    
                }
                
                
            }.padding(20).frame(maxWidth: 500,minHeight: 500, maxHeight: 800,)
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: flashcard.self, inMemory: true)
}
