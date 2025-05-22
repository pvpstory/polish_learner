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
    case reviewed =  "reviewed"
}

@Model
class flashcard {
    @Attribute(.unique) var id: UUID
     var frontside: String
     var backside: String
     var definition: String
     var examples: [String] = []
     var createdAt: Date
     var nextReview: Date?
     var lastReview: Date?
     var easeFactor: Double
     var stage: String
    
    
    init(id: Int, frontside: String, backside: String, definition: String, examples: [String] = []){
        self.id =   UUID()
        self.frontside = frontside
        self.backside = backside
        self.definition = definition
        self.examples = examples
        self.easeFactor = 2.5
        self.createdAt = Date.now
        self.stage = "new"
    }
}
