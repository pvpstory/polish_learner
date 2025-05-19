//
//  ContentView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/05/2025.
//

struct exampleEntry: Identifiable {
    let id: Int
    var example: String
    var isSelected: Bool = false
}

struct definitionEntry: Identifiable {
    let id: Int
    var defintion: String
    var isSelected: Bool = false
    var examples: [exampleEntry] = []
}

import SwiftUI

struct ContentView: View {

    @State var definitions = [definitionEntry]()
   
    func submittedWord(){
        definitions.append(definitionEntry(id: 0, defintion: "karakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakaraka"))
        definitions.append(definitionEntry(id: 1, defintion: "karakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakarakakaraka"))
    }
    func submitDefenitions(){
        for (i,definition) in definitions.enumerated(){
            if definition.isSelected == false{
                definitions.remove(at: i)
            }
        }
        definitions[0].examples.append(exampleEntry(id: 3, example: "duradura dada"))
    }
    func submitExamples(){
        //insert data
        definitions = []
        text = ""
        
    }
    
    @State private var text = ""
    var body: some View {
        VStack{
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

#Preview {
    ContentView()
}
