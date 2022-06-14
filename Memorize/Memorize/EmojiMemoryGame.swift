//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kevin Won on 6/13/22.
//  This is the model-view.

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["👻", "🐎", "🦕", "🐊", "🚝", "🚛", "🏍", "😤", "😃", "😇", "🙃", "😂", "😧", "🤥"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
       }
    }
    
    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
}
