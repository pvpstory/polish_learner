func getOptionDefinitions(randomFlashcards: [Flashcard], curFrontside: String, curFlashcard: Flashcard) -> [String] {
    let shuffledFlashcards = randomFlashcards.shuffled()
    var definitions: [String] = []
    var randomIndex: Int = 0
    for i in 0..<3{
        if shuffledFlashcards.count >= i+1 && shuffledFlashcards[i].frontside != curFrontside{
            randomIndex = Int.random(in: 0..<shuffledFlashcards[i].definition.count)
            definitions.append(shuffledFlashcards[i].definition[randomIndex])
        }
        else if shuffledFlashcards.count >= 5 && shuffledFlashcards[i].frontside == curFrontside{
            randomIndex = Int.random(in: 0..<shuffledFlashcards[4].definition.count)
            definitions.append(shuffledFlashcards[4].definition[randomIndex])
            
        }
        else{
            definitions.append("not enough]\(i)") // take other indexes instead
        }
        
    }
    randomIndex = Int.random(in: 0..<curFlashcard.definition.count)
    definitions.append(curFlashcard.definition[randomIndex])
    return definitions
}

func getOptionWords(randomFlashcards: [Flashcard], curFrontside: String, curFlashcard: Flashcard) -> [String] {
    //make this func available to the LearnPhaseMainView
    let shuffledFlashcards = randomFlashcards.shuffled() //is it inefficient?
    var frontSides: [String] = []
    for i in 0..<3{
        if shuffledFlashcards.count >= i+1 && shuffledFlashcards[i].frontside != curFrontside{
            frontSides.append(shuffledFlashcards[i].frontside)
        }
        else if shuffledFlashcards.count >= 5 && shuffledFlashcards[i].frontside == curFrontside{
            frontSides.append(shuffledFlashcards[4].frontside)
        }
        else{
            frontSides.append("supeRandom\(i)" )
            
        }
    }
    print(frontSides)
    

    frontSides.append(curFrontside)
    frontSides = frontSides.shuffled()
    return frontSides
}
