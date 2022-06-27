//
//  GameModel.swift
//  a3
//
//  Created by Kevin Won on 6/25/22.
//

import Foundation

struct GameModel {
    
    private(set) var cards: Array<Card>
    
    private(set) var cardsOnScreen: Array<Card>
    
    private var numberOfCardsOnScreen = 12

    private var arrayOfIndicesOfSelectedCards: [Int] = []
    
    private static var colors = [ContentColor.red, ContentColor.green, ContentColor.purple]
    
    private static var shapes = [ContentShape.rectangle, ContentShape.circle, ContentShape.diamond]
    
    private static var fillings = [ContentFilling.empty, ContentFilling.full, ContentFilling.squiggly]
    
    private static var numbers = [1, 2, 3]
        
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenIndex].isSelected = true
            arrayOfIndicesOfSelectedCards.append(chosenIndex)
            if arrayOfIndicesOfSelectedCards.count == 3 {
                var cardsInPotentialSet = [Card]()
                for index in cards.indices {
                    if arrayOfIndicesOfSelectedCards.contains(index) {
                        cardsInPotentialSet.append(cards[index])
                    }
                }
                if setIsValid(for: cardsInPotentialSet) {
                    var count = 0
                    cardsOnScreen = []
                    for index in cards.indices {
                        if arrayOfIndicesOfSelectedCards.contains(index) {
                            cards[index].isDone = true
                            cards[index].isSelected = false
                        }
                        if !cards[index].isDone && count != numberOfCardsOnScreen {
                            count += 1
                            cardsOnScreen.append(cards[index])
                        }
                    }
                } else {
                    for index in cards.indices {
                        if arrayOfIndicesOfSelectedCards.contains(index) {
                            cards[index].isSelected = false
                        }
                    }
                }
                cardsInPotentialSet = []
                arrayOfIndicesOfSelectedCards = []
            }
        }
    }
    
    private func setIsValid(for cards: [Card]) -> Bool {
        return colorIsValid(for: cards) && quantityIsValid(for: cards) && shapeIsValid(for: cards) && fillingIsValid(for: cards)
    }
    
    private func colorIsValid(for cards: [Card]) -> Bool {
        var red = 0
        var green = 0
        var blue = 0
        for index in cards.indices {
            switch cards[index].color {
                case ContentColor.red:
                    red += 1
                case ContentColor.green:
                    green += 1
                case ContentColor.purple:
                    blue += 1
            }
        }
        return red == 1 && green == 1 && blue == 1 || red == 3 || green == 3 || blue == 3
    }
    
    private func quantityIsValid(for cards: [Card]) -> Bool {
        var red = 0
        var green = 0
        var blue = 0
        for index in cards.indices {
            switch cards[index].number {
                case 1:
                    red += 1
                case 2:
                    green += 1
                case 3:
                    blue += 1
                default:
                    blue += 0
            }
        }
        return red == 1 && green == 1 && blue == 1 || red == 3 || green == 3 || blue == 3
    }
    
    private func shapeIsValid(for cards: [Card]) -> Bool {
        var red = 0
        var green = 0
        var blue = 0
        for index in cards.indices {
            switch cards[index].shape {
                case ContentShape.circle:
                    red += 1
                case ContentShape.rectangle:
                    green += 1
                case ContentShape.diamond:
                    blue += 1
            }
        }
        return red == 1 && green == 1 && blue == 1 || red == 3 || green == 3 || blue == 3
    }
    
    private func fillingIsValid(for cards: [Card]) -> Bool {
        var red = 0
        var green = 0
        var blue = 0
        for index in cards.indices {
            switch cards[index].filling {
                case ContentFilling.empty:
                    red += 1
                case ContentFilling.full:
                    green += 1
                case ContentFilling.squiggly:
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
        cardsOnScreen = Array(cards.prefix(numberOfCardsOnScreen))
    }
    
    enum ContentColor {
        case red
        case green
        case purple
    }
    
    enum ContentShape {
        case rectangle
        case circle
        case diamond
    }
    
    enum ContentFilling {
        case empty
        case full
        case squiggly
    }
    
    struct Card: Identifiable {
        var color: ContentColor
        var shape: ContentShape
        var filling: ContentFilling
        var number: Int
        var id: Int
        var isSelected = false
        var isDone = false
    }
}
