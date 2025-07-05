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
    let firstPrompt = "12312"
        
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
    func addSamples() async{
        let myAI = AI()
        await myAI.give_meaning(prompt: "write me most frequent and useful definitions and exampples for those definitions of polish word (obcy). Return me a well structure JSON object with definitions and exa,ples. The definitions and examples must be in polish ")
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
        let myAI = AI()
        let output = await myAI.give_meaning(prompt: "prompt")
        //modify the JSON
        
    }
    func submitDefenitions(){
        print(definitions)
        for (i,definition) in definitions.enumerated(){
            if definition.isSelected == false{
                definitions.remove(at: i)
            }
        }
        whatToShow = "examples"
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
    @State private var whatToShow: String = "start"
    var body: some View {
            VStack {
                Button(action: {
                    Task {
                        await addSamples()
                        
                    }
                }){
                    Text("add")
                }
                if (whatToShow == "start"){
                    TextField("Enter",text: $text).onSubmit {
                        Task {
                        await submittedWord()
                        whatToShow = "definitions"
                    }
                    }
                }
                if (whatToShow == "definitions"){
                    List{
                        TextField("Custom Definiton", text: $customDefinition).onSubmit {
                            definitions.append(definitionEntry(definition: customDefinition,isSelected: true,examples: []))
                            customDefinition = ""
                        }.font(.title2)
                        
                        ForEach($definitions) { $definition in
                            Toggle(definition.definition, isOn: $definition.isSelected).font(.title2)
                            if ($definition.examples.count > 0){
                                Toggle(definition.examples[0].example, isOn: $definition.examples[0].isSelected)
                            }
                        }
                        
                        
                    }
                    Button("submit", action: submitDefenitions).font(.title2)
                }
                            
                if (whatToShow == "examples"){
                    List{
                        TextField("Custom Example",text: $customExample).onSubmit {
                            
                            if let firstchr = customExample.first {
                                if let i = Int(String(firstchr)){
                                    if(i >= 0 && i < definitions.count ){
                                        definitions[i].examples.append(exampleEntry(example: String(customExample.dropFirst()), isSelected: true))
                                    }
                                }
                            }
                        }.font(.title2)
                        
                        
                        ForEach($definitions){ $definition in
                            Toggle(definition.definition, isOn: $definition.isSelected).font(.title2)
                            ForEach($definition.examples){ $example in
                                Toggle(example.example,isOn : $example.isSelected).font(.title2)
                            }.offset(x:50)
                        }
                        
                    }
                    Button(action: submitExamples){
                        Text("sumbit").font(.title2)
                    }
                }
            }.padding(20).frame(maxWidth: 800,minHeight: 500, maxHeight: 800,)
        }
    }
        
    


#Preview {
    ContentView()
        .modelContainer(for: Flashcard.self, inMemory: true)
}
