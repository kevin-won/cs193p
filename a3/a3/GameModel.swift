//
//  GameModel.swift
//  a3
//
//  Created by Kevin Won on 6/25/22.
//

import Foundation
import SwiftUI

struct GameModel {
    
    private(set) var cards: Array<Card>
    
    private(set) var playingCards: Array<Card>
            
    private var numberOfCardsOnScreen = 12
    
    private var indexOfNextCardToDeal = 12
    
    private var numberOfUnmatchedCardsAvailable = 81
        
    private var selectedCards: Array<Card> = []
    
    private static var colors = [ContentColor.red, ContentColor.green, ContentColor.purple]
    
    private static var shapes = [ContentShape.squiggly, ContentShape.circle, ContentShape.diamond]
    
    private static var fillings = [ContentFilling.empty, ContentFilling.full, ContentFilling.striped]
    
    private static var numbers = [1, 2, 3]
    
    func getIndexOfNextCardToDeal() -> Int {
        indexOfNextCardToDeal
    }
    
    mutating func resetCards() {
        if !playingCards.first(where: { $0 == selectedCards.first })!.isMatched! {
            selectedCards.forEach { card in
                let unmatchedIndex = playingCards.firstIndex(of: card)!
                playingCards[unmatchedIndex].isMatched = nil
            }
        } else {
            if indexOfNextCardToDeal < 81 {
                selectedCards.forEach { card in
                    let matchedIndex = playingCards.firstIndex(of: card)!
                    dealOneCard(at: matchedIndex)
                }
            }
        }
        selectedCards = []
    }
    
    mutating func dealOneCard(at matchedIndex: Int) {
        playingCards[matchedIndex] = cards[indexOfNextCardToDeal]
        indexOfNextCardToDeal += 1
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = playingCards.firstIndex(where: { $0.id == card.id }) {
            
            if selectedCards.count < 3 || selectedCards.count == 3 && !selectedCards.contains(playingCards[chosenIndex]) {

                if selectedCards.count == 3 { resetCards() }

                if !playingCards[chosenIndex].isSelected {
                    playingCards[chosenIndex].isSelected = true
                    selectedCards.append(playingCards[chosenIndex])
                    
                    if selectedCards.count == 4 {
                        let chosenCard = playingCards[chosenIndex]
                        for card in selectedCards {
                            if card != chosenCard {
                                let matchedIndex = playingCards.firstIndex(of: card)!
                                playingCards.remove(at: matchedIndex)
                            }
                        }
                        selectedCards = [chosenCard]
                    }
                    
                    if selectedCards.count == 3 {
                        if formSet(by: selectedCards) {
                            selectedCards.forEach { card in
                                let index = playingCards.firstIndex(of: card)!
                                playingCards[index].isMatched = true
                                playingCards[index].isSelected = false
                            }
                        } else {
                            selectedCards.forEach { card in
                                let index = playingCards.firstIndex(of: card)!
                                playingCards[index].isMatched = false
                                playingCards[index].isSelected = false
                            }
                        }
                    }
                }
                else {
                    playingCards[chosenIndex].isSelected = false
                    selectedCards.removeAll(where: { $0 == playingCards[chosenIndex] })
                }
            }
        }
    }

    mutating func dealCards() {
        if indexOfNextCardToDeal < 81 {
            if selectedCards.count == 3 && playingCards.first(where: { $0 == selectedCards.first })!.isMatched! { resetCards() }
            else {
                playingCards.append(cards[indexOfNextCardToDeal])
                playingCards.append(cards[indexOfNextCardToDeal+1])
                playingCards.append(cards[indexOfNextCardToDeal+2])
                numberOfCardsOnScreen += 3
                indexOfNextCardToDeal += 3
            }
        }
    }
    
    private func formSet(by cards: [Card]) -> Bool {
        return feature(\Card.color, isValidFor: cards) && feature(\Card.shape, isValidFor: cards) && feature(\Card.filling, isValidFor: cards) && feature(\Card.number, isValidFor: cards)
    }

    private func feature<F: Hashable>(_ keyPath: KeyPath<Card, F>, isValidFor cards: [Card]) -> Bool {
        let count = cards.reduce(into: Set<F>()) { $0.insert($1[keyPath: keyPath]) }.count
        return count == 1 || count == 3
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
        playingCards = Array(cards.prefix(numberOfCardsOnScreen))
    }
    
    enum ContentColor {
        case red
        case green
        case purple
    }
    
    enum ContentShape {
        case squiggly
        case circle
        case diamond
    }
    
    enum ContentFilling {
        case empty
        case full
        case striped
    }
    
    struct Card: Identifiable, Equatable {
        var color: ContentColor
        var shape: ContentShape
        var filling: ContentFilling
        var number: Int
        var id: Int
        var isSelected = false
        var isMatched: Bool?
        
        static func == (lhs: Card, rhs: Card) -> Bool {
                return lhs.id == rhs.id
            }
    }
}
