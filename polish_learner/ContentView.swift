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
                MainView()
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
struct MainView: View {
    @Query  var flashcards: [Flashcard]
    @Environment(\.modelContext) private var context
    @State var definitions = [definitionEntry]()
    @State private var sumbittedWord = ""
    func addSamples() async{
    }
    func submitWord() async{
        let myAI = AI()
        var analysisResult: AnalysisResult
        do{
            analysisResult = try await myAI.give_meaning(word: sumbittedWord)
            for analys in analysisResult.analysis{
                var new_definition = (definitionEntry(definition: analys.definition, isSelected: false))
                for example in analys.examples{
                    new_definition.examples.append(exampleEntry(example: example.polish,isSelected: false,example_blured: example.polish_blured))
                }
                definitions.append(new_definition)
            }
        }catch let error as MeaningError{
            switch error{
            case .apiRequestFailed(let underlyingError):
                print("API request error: \(underlyingError)")
            case .emptyOrInvalinResponse:
                print("Invalid API response")
            case .jsonDecodingFailed(let underlyingError, let json):
                print("Json decoding failed, \(underlyingError), \(json)")
            }
        } catch {
            print("An unexpected error occurred: \(error)")
        }
        print(definitions)
        whatToShow = "definitions"
        
    }
    func submitDefenitions(){
        print(definitions)
        definitions.removeAll { definition in
            return definition.isSelected == false
        }
        whatToShow = "examples"
    }
    func submitExamples(){
        for i in definitions.indices{
            definitions[i].examples.removeAll{ example in
                return example.isSelected == false
            }
            
        }
        var backside = ""
        var definitions_c: [String] = []
        var examples: [String] = []
        var backside_blured = ""
        
        var i = 1
        for definition in definitions{
            definitions_c.append(definition.definition)
            backside += "\(i): " + definition.definition + "\n"
            i+=1
        }
        backside += "Przykłady:" + "\n"
        backside_blured = backside
        
        i = 1
        for definition in definitions {
            for example in definition.examples{
                examples.append(example.example)
                backside += "  \(i): " + example.example + "\n"
                backside_blured += "  \(i): " + example.example_blured + "\n"
                i+=1
            }
            
        }   
        
        let new_flashcard = Flashcard(
            frontside: sumbittedWord,
            backside:  backside,
            definition: definitions_c,
            examples: examples,
            backside_blured: backside_blured,
            
        )
        print(new_flashcard.backside_blured)
        print("sumbit")
        context.insert(new_flashcard)
        do {
            try context.save()
        }
        catch {
            print(error)
        }
        
        definitions = []
        sumbittedWord = ""
        print(flashcards)
        whatToShow = "start"
        
    }
    
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
                    TextField("Enter",text: $sumbittedWord).onSubmit {
                        Task {
                        await submitWord()
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
                                        definitions[i].examples.append(exampleEntry(example: String(customExample.dropFirst()), isSelected: true, example_blured: "fix the example_blured addition"))
                                        //fix
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
