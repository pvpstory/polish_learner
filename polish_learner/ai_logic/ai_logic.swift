


import FirebaseAI

class AI{
    
    
    // Initialize the Gemini Developer API backend service
    let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    
    // Create a `GenerativeModel` instance with a model that supports your use case
    
    func give_meaning(prompt: String) async{
        let model = ai.generativeModel(modelName: "gemini-2.0-flash")
        
        do{
            let response = try await model.generateContent(prompt)
            print(response.text ?? "No text in response.")
        }catch{
            print("error")
        }
    }
}


