//
//  EmojiMemoryGame.swift
//  a2
//
//  Created by Kevin Won on 6/15/22.

import SwiftUI

class EmojiMemoryGame: ObservableObject {
//    static let vehicleEmojis = ["🚝", "🚛", "🏍", "🛩", "✈️", "🚒", "🛴", "🚑", "🚂"]
//    static let animalEmojis = ["🐎", "🦕", "🐊", "🐳", "🦖", "🐿", "🦙", "🐃", "🐶"]
//    static let faceEmojis = ["😤", "😃", "😇", "🙃", "😂", "😧", "🤥", "🥹", "🥰", "🥸"]
//    static let foodEmojis = ["🍏", "🫐", "🍑", "🍌", "🍉", "🍐", "🍔", "🥨", "🍠", "🍇", "🫑", "🍓", "🌭" ]
//    static let heartEmojis = ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤎", "💖", "❣️", "❤️‍🩹"]
//    static let numberEmojis = ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣"]
        
    var theme = themes.randomElement()!
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            emojis[pairIndex]
       }
    }
        
    @Published private var model: MemoryGame<String> = createMemoryGame(theme: themes.randomElement()!)
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func color(for theme: Theme) -> Color {
        switch theme.color {
        case "red":
           return Color.red
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "purple":
            return Color.purple
        case "yellow":
            return Color.purple
        case "orange":
            return Color.orange
        default:
            return Color.white
        }
    }
    
    func newGame() {
        theme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
