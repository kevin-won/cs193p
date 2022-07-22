//
//  GameViewModel.swift
//  a4
//
//  Created by Kevin Won on 7/6/22.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = GameModel.Card
        
    @Published private var model: GameModel = GameModel()
    
    var cards: Array<Card> {
        model.cards
    }
    
    var undealtCards: Array<Card> {
        model.undealtCards
    }
    
    func newGame() {
        model = GameModel()
    }
    
    var playingCards: Array<Card> {
        model.playingCards
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
        
    func borderColor(for card: Card) -> Color {
        switch card.isSelected {
        case true:
            return Color.red
        case false:
            return Color.black
        }
    }
    
    func color(for card: Card) -> Color {
        switch card.color {
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .purple:
            return Color.purple
        }
    }
    
    func symbol(for card: Card) -> some View {
        VStack {
            ForEach(0..<card.number, id: \.self) { _ in
                self.createSymbol(for: card).foregroundColor(self.color(for: card))
            }
        }
    }
    
    @ViewBuilder
    func createSymbol(for card: Card) -> some View {
        switch card.shape {
            case .squiggly:
                createSymbolHelper(for: card, with: Squiggly())
            case .circle:
                createSymbolHelper(for: card, with: Circle())
            case .diamond:
                createSymbolHelper(for: card, with: Diamond())
        }
    }

    @ViewBuilder
    private func createSymbolHelper<SymbolShape: Shape>(for card: Card, with shape: SymbolShape) -> some View {
        switch card.filling {
            case .empty:
                ZStack {
                    shape.fill().foregroundColor(.white)
                    shape.stroke(lineWidth: DrawingConstants.lineWidth)
                }
            case .full:
                shape.fill().foregroundColor(color(for: card))
            case .striped:
                StripeView(shape: shape, stripeColor: color(for: card))
        }
    }
    
    func discardedCards() -> Array<Card> {
        return model.discardedCards
    }
    
    func cover(for card: Card) -> Color {
        if let unwrappedBoolean = card.isMatched {
            if unwrappedBoolean {
                return Color.green
            } else {
                return Color.black
            }
        }
        return Color.white.opacity(0)
    }
    
    func deal() {
        model.deal()
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func numberOfCardsToDeal() -> Int {
        model.numberOfCardsToDeal()
    }
    
}
