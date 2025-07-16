


import SwiftUI
import SwiftData
import Foundation
struct AddingMainView: View {
    @Query  var flashcards: [Flashcard]
    @Environment(\.modelContext) private var context
    @State var definitions = [definitionEntry]()
    @State private var sumbittedWord = ""
    @State private var isLoading: Bool = false
    func submitWord() async{
        isLoading = true
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
        isLoading = false
        
    }
    func submitDefenitions(){
        print(definitions)
        definitions.removeAll { definition in
            return definition.isSelected == false
        }
        whatToShow = "examples"
    }
    func submitExamples(){
        definitions.removeAll { definition in
            return definition.isSelected == false
        }
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
            VStack(spacing: 20){
                if (whatToShow == "start"){
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Learn a New Word")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Type the polish word you want to learn")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        }

                    TextField("Enter the word", text: $sumbittedWord)
                        .textFieldStyle(.roundedBorder)
                        .font(.title2)
                        .onSubmit {
                            Task {
                                await submitWord()
                            }
                        }
                    if isLoading{
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                }
                
                if (whatToShow == "definitions"){
                
                    
                    Text("Choose the definitions you want to study or write your own")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    List{
                        TextField("Custom Definiton", text: $customDefinition).onSubmit {
                            definitions.append(definitionEntry(definition: customDefinition,isSelected: true,examples: []))
                            customDefinition = ""
                        }
                        .font(.title2)
                        .padding(.bottom, 10)
                        .listRowSeparator(.hidden)
                        
                        
                        ForEach($definitions) { $definition in
                            Toggle(definition.definition, isOn: $definition.isSelected)
                                .font(.title2)
                                .listRowSeparator(.hidden)
                            if (!definition.examples.isEmpty){
                                Text(definition.examples[0].example)
                                    .font(.title2)
                                    .offset(x: 50)
                                    .listRowSeparator(.hidden)
                            }
                        }
                            
                            
                        
                    }
                    Button(action: submitDefenitions) {
                        Text("Submit")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.6))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
            }
                            
                if (whatToShow == "examples"){
                    Text("Choose the examples you want to include or write your own")
                        .font(.largeTitle)
                        .fontWeight(.bold)
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
                        }
                        .font(.title2)
                        .padding(.bottom, 10)
                        .listRowSeparator(.hidden)
                        
                        
                        ForEach($definitions){ $definition in
                            Toggle(definition.definition, isOn: $definition.isSelected)
                                .font(.title2)
                                .listRowSeparator(.hidden)
                            ForEach($definition.examples){ $example in
                                Toggle(example.example,isOn : $example.isSelected)
                                    .font(.title2)
                                    .listRowSeparator(.hidden)
                            }.offset(x:50)
                        }
                        
                    }
                    Button(action: submitExamples) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.6))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.padding(20).frame(maxWidth: 1000,minHeight: 500, maxHeight: 800,)
        }
    }


#Preview{
    AddingMainView()
}
