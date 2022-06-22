//
//  EmojiMemoryGame.swift
//  a2
//
//  Created by Kevin Won on 6/15/22.

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    var theme = themes.randomElement()!
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let num = emojis.count < theme.numberOfPairsOfCards ? emojis.count : theme.numberOfPairsOfCards
        return MemoryGame<String>(numberOfPairsOfCards: num) { pairIndex in
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
    
    func getScore() -> Int {
        return model.score
    }
    
    func newGame() {
        theme = themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
