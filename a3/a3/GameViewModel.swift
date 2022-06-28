//
//  GameViewModel.swift
//  a3
//
//  Created by Kevin Won on 6/25/22.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = GameModel.Card
        
    @Published private var model: GameModel = GameModel()
    
    func newGame() {
        model = GameModel()
    }
    
    var cardsOnScreen: Array<Card> {
        model.cardsOnScreen
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func borderColor(for card: Card) -> Color {
        switch card.isSelected {
        case true:
            print("he")
            return Color.red
        case false:
            print("jjj")
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
        case .rectangle:
            createSymbolHelper(for: card, with: Rectangle())
        case .circle:
            createSymbolHelper(for: card, with: Circle())
        case .diamond:
            createSymbolHelper(for: card, with: Diamond())
        }
    }

    @ViewBuilder
    private func createSymbolHelper<SymbolShape>(for card: Card, with shape: SymbolShape) -> some View where SymbolShape: Shape {
        switch card.filling {
            case .empty:
                ZStack {
                    shape.fill().foregroundColor(.white).padding()
                    shape.stroke(lineWidth: 3.0)
                }
            case .full:
                shape.fill().foregroundColor(color(for: card))
            case .squiggly:
                shape.opacity(0.3)
        }
    }
}
