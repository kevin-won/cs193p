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
            ForEach(0..<card.number) { _ in
                self.createSymbol(for: card)
            }
        }
    }
    
    @ViewBuilder
    func createSymbol(for card: Card) -> some View {
        switch card.shape {
        case .rectangle:
            Rectangle()
        case .circle:
            Circle()
        case .diamond:
            Diamond()
        }
    }
//
//    @ViewBuilder
//    private func createSymbolHelper(for card: Card, with shape: Shape) -> some View {
//        switch card.filling {
//        case .empty:
//            shape.fill().foregroundColor(.white)
//            shape.stroke(lineWidth: 10.0)
//        case .full:
//            shape.fill().foregroundColor(.white)
//            shape.stroke(lineWidth: 10.0)
//        case .squiggly:
//            shape.fill().foregroundColor(.white)
//            shape.stroke(lineWidth: 10.0)
//
//        }
//    }
    

    
}
