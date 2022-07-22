//
//  ContentView.swift
//  a4
//
//  Created by Kevin Won on 7/6/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel
    
    @Namespace private var dealingNamespace

    var body: some View {
        VStack {
            newGameButton
            gameBody
            HStack {
                deckBody
                discardedDeckBody
            }
            shuffleButton
        }
    }
    
    var newGameButton: some View {
        Button(action: { viewModel.newGame() }) { Text("New Game")
            .font(.caption) }
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.playingCards, aspectRatio: 2/3) { card in
            CardView(viewModel: viewModel, card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
//                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
                .foregroundColor(viewModel.borderColor(for: card))
            }
        .padding(.horizontal)
    }
    
    private func dealAnimation(for cardNumber: Int, _ totalCardsToDeal: Int) -> Animation {
        let delay = Double(cardNumber) * (CardConstants.totalDealDuration / Double(totalCardsToDeal))
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.undealtCards) { card in
                CardView(viewModel: viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for cardNumber in Array(0..<viewModel.numberOfCardsToDeal()) {
                withAnimation(dealAnimation(for: cardNumber, viewModel.numberOfCardsToDeal())) {
                    viewModel.deal()
                }
            }
        }
    }
    
    var discardedDeckBody: some View {
        ZStack {
            ForEach(viewModel.discardedCards()) { card in
                CardView(viewModel: viewModel, card: card)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 0.7
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
}

struct CardView: View {
    @ObservedObject var viewModel: GameViewModel

    let card: GameModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: DrawingConstants.lineWidth)
                viewModel.symbol(for: card)
                .padding(.all)
                shape.foregroundColor(viewModel.cover(for: card))
            }
        }
    }
}

struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
    static let fontScale: CGFloat = 0.7
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        ContentView(viewModel: game)
            .previewInterfaceOrientation(.portrait)
    }
}
