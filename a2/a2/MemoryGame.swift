//
//  MemoryGame.swift
//  a2
//
//  Created by Kevin Won on 6/15/22.

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard : Int?
    
    var score = 0
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where : { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    if cards[chosenIndex].wasFaceUp {
                        score -= 1
                    }
                    if cards[potentialMatchIndex].wasFaceUp {
                        score -= 1
                    }
                    cards[chosenIndex].wasFaceUp = true
                    cards[potentialMatchIndex].wasFaceUp = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards = cards.shuffled()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        var wasFaceUp: Bool = false
    }
}

struct Theme {
    var name: String
    var emojis: Array<String>
    var numberOfPairsOfCards: Int
    var color: String
}

let themes = [
    Theme(name: "Vehicles", emojis: ["🚝", "🚛", "🏍", "🛩", "✈️", "🚒", "🛴", "🚑", "🚂"], numberOfPairsOfCards: 9, color: "blue"),
    Theme(name: "Animals", emojis: ["🐎", "🦕", "🐊", "🐳", "🦖", "🐿", "🦙", "🐃", "🐶"], numberOfPairsOfCards: 7, color: "red"),
    Theme(name: "Faces", emojis: ["😤", "😃", "😇", "🙃", "😂", "😧", "🤥", "🥹", "🥰", "🥸"], numberOfPairsOfCards: 5, color: "green"),
    Theme(name: "Food", emojis: ["🍏", "🫐", "🍑", "🍌", "🍉", "🍐", "🍔", "🥨", "🍠", "🍇", "🫑", "🍓", "🌭" ], numberOfPairsOfCards: 12, color: "orange"),
    Theme(name: "Hearts", emojis: ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤎", "💖", "❣️", "❤️‍🩹"], numberOfPairsOfCards: 9, color: "purple"),
    Theme(name: "Numbers", emojis: ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣"], numberOfPairsOfCards: 43, color: "yellow")
    ]
