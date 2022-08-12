//
//  EmojiMemoryGame.swift
//  a6
//
//  Created by Kevin Won on 7/25/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
        
    var chosenTheme: Theme
    
    init(with chosenTheme: Theme) {
        self.chosenTheme = chosenTheme
        self.model = EmojiMemoryGame.createMemoryGame(with: chosenTheme)
    }
    
    static func createMemoryGame(with chosenTheme: Theme) -> MemoryGame<String> {
        let emojis = convertToList(chosenTheme.emojis)
        let num = emojis.count < chosenTheme.numberOfPairsOfCards ? emojis.count : chosenTheme.numberOfPairsOfCards
        return MemoryGame<String>(numberOfPairsOfCards: num) { pairIndex in
            emojis[pairIndex]
       }
    }
    
    static func convertToList(_ str: String) -> Array<String> {
        var lst: Array<String> = []
        for char in str {
            lst.append(String(char))
        }
        return lst
    }
                
    @Published private var model: MemoryGame<String>
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func color(for theme: Theme) -> Color {
        theme.color
    }
    
    func getScore() -> Int {
        return model.score
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(with: chosenTheme)
    }
}
