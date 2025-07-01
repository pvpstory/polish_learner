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
}
struct ContentView: View {
    @State var selection: Screen? = .first
    var body: some View{
        NavigationSplitView{
            List(selection: $selection){
                Label("Main View", systemImage: "1.circle").tag(Screen.first)
                Label("All cards", systemImage: "2.circle").tag(Screen.second)
                Label("Learn Phase Flashcards", systemImage: "3.circle").tag(Screen.third)
                Label("Learn", systemImage: "4.circle").tag(Screen.fourth)
            }
            .navigationTitle("Language learner")
            .navigationSplitViewColumnWidth(220)
        } detail: {
            switch selection{
            case .first:
                MainView()
            case .second:
                allFlashcardsView()
            case .third:
                LearnPhaseAllMainView()
            case .fourth:
                LearnPhaseMainView()
            case .none:
                Text("Select a view")
            }
        }
        
    }
    
}
struct MainView: View {
    @Query  var flashcards: [Flashcard]
    @Environment(\.modelContext) private var context
    @State var definitions = [definitionEntry]()
    func addSamples(){
        let example = Flashcard(
            id: 1, // This 'Int' id is for the initializer, the actual UUID is generated inside
            frontside: "Jabłko",
            backside: "Apple",
            definition: "A round fruit with firm, white flesh and a green or red skin.",
            examples: [
                "Lubię jeść czerwone jabłka. (I like to eat red apples.)",
                "Szarlotka jest zrobiona z jabłek. (Apple pie is made from apples.)"
            ]
        )
        context.insert(example)
        
    }
    func submittedWord() async{
        
        
        definitions.append(definitionEntry(definition: "something", examples: []))
        definitions.append(definitionEntry(definition: "something2", examples: []))
    }
    func submitDefenitions(){
        print(definitions)
        for (i,definition) in definitions.enumerated(){
            if definition.isSelected == false{
                definitions.remove(at: i)
            }
        }
        definitions[0].examples.append(exampleEntry(example: "duradura dada"))
    }
    func submitExamples(){
        let new_flashcard = Flashcard(
            id: 1, // This 'Int' id is for the initializer, the actual UUID is generated inside
            frontside: "Jabłko",
            backside:  """
                APPLE   
                "Lubię jeść czerwone jabłka. (I like to eat red apples.)",
                "Szarlotka jest zrobiona z jabłek. (Apple pie is made from apples.)"
                """,
            definition: "aple",
            examples: [
                "Lubię jeść czerwone jabłka. (I like to eat red apples.)",
                "Szarlotka jest zrobiona z jabłek. (Apple pie is made from apples.)"
            ]
        )
        print("sumbit")
        context.insert(new_flashcard)
        do {
            try context.save()
        }
        catch {
            print(error)
        }
        
        definitions = []
        text = ""
        print(flashcards)
        
    }
    
    @State private var text = ""
    @State private var customDefinition = ""
    @State private var customExample: String = ""
    var body: some View {
        
            VStack {
                Button(action: addSamples) {
                    Text("add")
                }
                if (definitions.isEmpty){
                    TextField("Enter",text: $text).onSubmit {
                        Task {
                        await submittedWord()
                    }
                    }
                }
                if(definitions.isEmpty == false){
                    List{
                        if(definitions.count > 0 && definitions[0].examples.isEmpty){
                            TextField("Custom Definiton", text: $customDefinition).onSubmit {
                                definitions.append(definitionEntry(definition: customDefinition,isSelected: true,examples: []))
                                customDefinition = ""
                            }
                            
                        }
                        else{
                            TextField("Custom Example",text: $customExample).onSubmit {
                                
                                if let firstchr = customExample.first {
                                    if let i = Int(String(firstchr)){
                                        if(i >= 0 && i < definitions.count ){
                                            definitions[i].examples.append(exampleEntry(example: String(customExample.dropFirst()), isSelected: true))
                                    }
                                }
                                }
                            }
                        }
                        
                        ForEach($definitions){ $definition in
                            
                            
                            
                            Toggle(definition.definition, isOn: $definition.isSelected)
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


#Preview {
    ContentView()
        .modelContainer(for: Flashcard.self, inMemory: true)
}
