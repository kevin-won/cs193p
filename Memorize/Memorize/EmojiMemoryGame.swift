//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kevin Won on 6/13/22.
//  This is the model-view.

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["👻", "🐎", "🦕", "🐊", "🚝", "🚛", "🏍", "😤", "😃", "😇", "🙃", "😂", "😧", "🤥"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 5) { pairIndex in
            emojis[pairIndex]
       }
    }
        
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
}
