


import FirebaseAI
import Foundation


struct SentenceAnalyticsFeedback: Codable {
    let correct: Bool
    let coreCorrection: String
    let deeperDive: String
}

struct WordMeaning: Codable {
    let analysis: [WordAnalysis]
}

struct WordAnalysis: Codable {
    let definition: String
    let partOfSpeech: String
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
    
    
    func give_meaning(word: String) async throws -> WordMeaning{
        let model = ai.generativeModel(modelName: "gemini-2.0-flash")
        let decoder = JSONDecoder()
        
        let response: GenerateContentResponse
        do{
            response = try await model.generateContent(submitWordPrompt(word: word))
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
            let result = try decoder.decode(WordMeaning.self, from: jsonData)
            return result
        }catch{
            throw MeaningError.jsonDecodingFailed(underlyingError: error, json: cleanJsonString)
        }
    }
    
    func analyze_sentence(sentence: String, word: String) async throws -> SentenceAnalyticsFeedback{
        let model = ai.generativeModel(modelName: "gemini-2.5-flash")
        let decoder = JSONDecoder()

        let response: GenerateContentResponse
        
        do{
            response = try await model.generateContent(sentenceAnalysisPrompt(sentence: sentence, word: word))
        }catch{
            throw MeaningError.apiRequestFailed(underlyingError: error)
        }
        
        guard let unwrappedText = response.text, !unwrappedText.isEmpty else {
            throw MeaningError.emptyOrInvalinResponse
        }
        
        guard let cleanJsonString = extractJsonString(from: unwrappedText) else {
                print("--- FAILED TO EXTRACT JSON FROM RAW RESPONSE ---")
                print("Original AI response:\n\(unwrappedText)")
                print("---------------------------------------------")
                throw MeaningError.emptyOrInvalinResponse
            }
        print(sentence,word)
        print(cleanJsonString)
        do{
            let jsonData = cleanJsonString.data(using: .utf8)!
            let result = try decoder.decode(SentenceAnalyticsFeedback.self, from: jsonData)
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
    
    func sentenceAnalysisPrompt(sentence: String, word: String) -> String{
        return """
                The AI Prompt
                You are an expert AI language tutor. Your function is to analyze a sentence written by a user and provide structured feedback in a JSON format. The user is trying to use a specific target word based on its definition.

                A critical rule is that your entire response must be in the targetLanguage provided. All strings within the final JSON object, including explanations and examples, must be in that language.

                You will receive this input:

                targetLanguage: The language the user is learning.
                targetWord: The vocabulary word to use.
                definition: The definition of the target word.
                userSentence: The sentence the user has written.
                Your response MUST be a single, valid JSON object and nothing else. Do not include any text before or after the JSON. The JSON must have this exact structure:

                {
                  "correct": boolean,
                  "coreCorrection": "string",
                  "deeperDive": "string"
                }
        
                Field Instructions:
                correct (Boolean):
                true: If the sentence is grammatically correct and the targetWord is used appropriately.
                false: If there are any grammatical errors or the targetWord is misused.
                coreCorrection (String):
                This is the primary feedback. It must be a short, encouraging message in the targetLanguage.
                If correct is true, provide positive reinforcement (e.g., "Excellent work!").
                If correct is false, identify the single most important error and suggest how to fix it. Keep it simple.
                deeperDive (String):
                This field provides more detailed information in the targetLanguage. Do not use any Markdown formatting.
                If the sentence is incorrect: Briefly explain the rule for the coreCorrection. Then, provide one correct alternative sentence as an example.
                If the sentence is correct: Provide useful collocations (popular words that are frequently used with the targetWord). For each collocation, provide a very short example phrase showing how they are used together.
                Example 1: Incorrect Sentence
                Input:

                targetLanguage: "English"
                targetWord: "elucidate"
                definition: "to make something clear; explain"
                userSentence: "The teacher elucidate the hard concept."
                Your Expected JSON Output:

                {
                  "correct": false,
                  "coreCorrection": "Good attempt! For a singular subject like 'The teacher', the verb needs an '-s'. The correct form is 'elucidates'.",
                  "deeperDive": "This is a subject-verb agreement rule. In the present tense, the verb must match its subject. Another way to say it could be: \"The teacher's lecture helped to elucidate the concept.\""
                }
                
                Example 2: Correct Sentence
                Input:

                targetLanguage: "English"
                targetWord: "ephemeral"
                definition: "lasting for a very short time"
                userSentence: "The artist created an ephemeral installation that only lasted for one day."
                Your Expected JSON Output:

                Generated json
                {
                  "correct": true,
                  "coreCorrection": "Perfect! That's an excellent use of the word 'ephemeral'.",
                  "deeperDive": "Popular combinations include: 'ephemeral beauty' (e.g., the ephemeral beauty of a sunrise), and 'ephemeral nature' (e.g., the ephemeral nature of childhood)."
                }
                
                Your Task
                Now, analyze the following user sentence. Remember, your entire JSON output must be in the specified targetLanguage.

                targetLanguage: "Polish"
                targetWord: \(word)
                definition: "use most common definitions"
                userSentence: \(sentence)
        """
    }
    func submitWordPrompt(word: String) -> String{
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


