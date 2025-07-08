//
//  flashcard.swift
//  polish_learner
//
//  Created by Микола Ясінський on 18/05/2025.
//

import Foundation
import SwiftData

enum Stage: String {
    case new = "new"
    case learning = "learning"
    case reviewed =  "review"
}

@Model
class Flashcard {
    @Attribute(.unique) var id: UUID
     var frontside: String
     var backside: String
     var backside_blured: String
     var definition: String
     var examples: [String] = []
     var createdAt: Date
     var nextReview: Date?
     var lastReview: Date?
     var easeFactor: Double
     var stage: String
    
    
    init(frontside: String, backside: String, definition: String, examples: [String] = [],backside_blured: String){
        self.id = UUID()
        self.frontside = frontside
        self.backside = backside
        self.definition = definition
        self.examples = examples
        self.easeFactor = 2.5
        self.createdAt = Date.now
        self.stage = "new"
        self.backside_blured = backside_blured
    }
}
