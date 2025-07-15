


import FirebaseAI
import Foundation

struct AnalysisResult: Codable {
    let analysis: [WordAnalysis]
}


struct WordAnalysis: Codable {
    let definition: String
    let partOfSpeech: String // Using camelCase for Swift convention
    let examples: [Example]

    
    enum CodingKeys: String, CodingKey {
        case definition
        case partOfSpeech = "part_of_speech"
        case examples
    }
}

struct Example: Codable {
    let polish: String
    let type: ExampleType
    let polish_blured: String
}

enum ExampleType: String, Codable {
    case standard
    case b2Advanced = "b2_advanced"
}


enum MeaningError: Error {
    case apiRequestFailed(underlyingError: Error)
    case emptyOrInvalinResponse
    case jsonDecodingFailed(underlyingError: Error, json: String)
}

class AI{
    
    
    // Initialize the Gemini Developer API backend service
    let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    
    
    func give_meaning(word: String) async throws -> AnalysisResult{
        let model = ai.generativeModel(modelName: "gemini-2.0-flash")
        let decoder = JSONDecoder()
        
        let response: GenerateContentResponse
        do{
            response = try await model.generateContent(createFirstPromppt(word: word))
        }catch{
            throw MeaningError.apiRequestFailed(underlyingError: error)
        }
        
        
        guard let unwrappedText = response.text, !unwrappedText.isEmpty else{
            throw MeaningError.emptyOrInvalinResponse
        }
        
        guard let cleanJsonString = extractJsonString(from: unwrappedText) else {
                print("--- FAILED TO EXTRACT JSON FROM RAW RESPONSE ---")
                print("Original AI response:\n\(unwrappedText)")
                print("---------------------------------------------")
                throw MeaningError.emptyOrInvalinResponse
            }
        
        do{
            let jsonData = cleanJsonString.data(using: .utf8)!
            let result = try decoder.decode(AnalysisResult.self, from: jsonData)
            return result
        }catch{
            throw MeaningError.jsonDecodingFailed(underlyingError: error, json: cleanJsonString)
        }
    }
    func extractJsonString(from text: String) -> String? {
        // Find the first '{' or '[' which marks the beginning of the JSON
        guard let firstBracket = text.firstIndex(of: "{") ?? text.firstIndex(of: "[") else {
            return nil
        }

        // Find the last '}' or ']' which marks the end of the JSON
        guard let lastBracket = text.lastIndex(of: "}") ?? text.lastIndex(of: "]") else {
            return nil
        }

        // Ensure the start is before the end
        guard firstBracket < lastBracket else {
            return nil
        }

        // Return the substring that contains only the JSON
        return String(text[firstBracket...lastBracket])
    }
    
    func createFirstPromppt(word: String) -> String{
        return """
        You are an expert Polish linguist and language tutor AI. Your task is to generate a detailed analysis of a given Polish word for a language learner with a strong B2 level of proficiency.

        For the word \(word), provide definitions and examples formatted exclusively as a single JSON object.

        The JSON object must follow this exact structure:

        A root object containing a single key named "analysis".
        The value of "analysis" should be an array of objects, where each object represents a distinct definition of the word.
        Each definition object must contain:
        A key "definition" with the Polish definition as a string.
        A key "part_of_speech" with the Polish part of speech (e.g., "rzeczownik", "czasownik") as a string.
        A key "examples" with an array of exactly three example objects.
        Each example object within the "examples" array must contain:
        A key "polish" with a complete and correct Polish example sentence as a string, which includes \(word) in its appropriate grammatical form.
        A key "polish_blured" with a string identical to the "polish" sentence, but with the specific grammatical form of \(word) replaced by "___".
        A key "type" which categorizes the example. Two examples should have the type "standard", and one must have the type "b2_advanced".
        Example Content Instructions:

        The definitions should be distinct and cover different common meanings of the word.
        The two "standard" examples should be clear and common use cases.
        The one "b2_advanced" example is crucial: it must be a more complex, well-thought-out sentence. This sentence should showcase nuance, context, or a slightly more sophisticated grammatical structure that is particularly helpful for a B2 learner aiming to improve their fluency and natural expression. It should not be a simple, short sentence.
        Do not include any commentary, apologies, or introductory text outside of the final JSON output. Your entire response must be the JSON object itself.
        """
    }
}


