//
//  GameModel.swift
//  a3
//
//  Created by Kevin Won on 6/25/22.
//

import Foundation

struct GameModel {
    
    private(set) var cards: Array<Card>

    private var indexOfSelectedCards: [Int]? = []
    
    private static var colors = [Color.red, Color.green, Color.purple]
    
    private static var shapes = [Shape.rectangle, Shape.oval, Shape.diamond]
    
    private static var fillings = [Filling.empty, Filling.full, Filling.squiggly]
    
    private static var numbers = [1, 2, 3]
    
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if let unwrappedIndexOfSelectedCards = indexOfSelectedCards {
                cards[chosenIndex].isSelected = true
                if unwrappedIndexOfSelectedCards.count == 0, unwrappedIndexOfSelectedCards.count == 1 {
                    indexOfSelectedCards!.append(chosenIndex)
                }
                else if unwrappedIndexOfSelectedCards.count == 2 {
                    cards[chose]
                }
            }
        }
    }
    
    private func setIsValid(for cards: [Card]) -> Bool {
        return colorsAreValid(for: cards)
    }
    
    private func colorsAreValid(for cards: [Card]) -> Bool {
        var red = 0
        var green = 0
        var blue = 0
        for index in cards.indices {
            switch cards[index].color {
                case Color.red:
                    red += 1
                case Color.green:
                    green += 1
                case Color.purple:
                    blue += 1
            }
        }
        return red == 1 && green == 1 && blue == 1 || red == 3 || green == 3 || blue == 3
    }
    
    
    

    
    init() {
        cards = []
        var counter = 0
        for id1 in GameModel.colors.indices {
            for id2 in GameModel.shapes.indices {
                for id3 in GameModel.fillings.indices {
                    for id4 in GameModel.numbers.indices {
                        cards.append(Card(color: GameModel.colors[id1], shape: GameModel.shapes[id2], filling: GameModel.fillings[id3], number: GameModel.numbers[id4], id: counter))
                        counter += 1
                    }
                }
            }
        }
        cards = cards.shuffled()
    }
    
    enum Color {
        case red
        case green
        case purple
    }
    
    enum Shape {
        case rectangle
        case oval
        case diamond
    }
    
    enum Filling {
        case empty
        case full
        case squiggly
    }
    
    struct Card: Identifiable {
        var color: Color
        var shape: Shape
        var filling: Filling
        var number: Int
        var id: Int
        var isSelected = false
        var isDone = false
    }
}
