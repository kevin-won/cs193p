//
//  ContentView.swift
//  a4
//
//  Created by Kevin Won on 7/6/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            newGameButton
            gameBody
            deckBody
            dealThreeCardsButton
            shuffleButton
        }
    }
    
    var newGameButton: some View {
        Button(action: { viewModel.newGame() }) { Text("New Game")
            .font(.caption) }
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.cardsOnScreen, aspectRatio: 2/3) { card in
            CardView(viewModel: viewModel, card: card)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
                .foregroundColor(viewModel.borderColor(for: card))
            }
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.undealtCards) { card in
                CardView(viewModel: viewModel, card: card)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .scale))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 3)) {
                viewModel.dealInitialCards()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
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
    
    var dealThreeCardsButton: some View {
        Button(action: { viewModel.dealCards() }) { Text("Deal 3 More Cards")
            .font(.caption) }.opacity(viewModel.opacityOfDealButton())
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
