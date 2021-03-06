//
//  ContentView.swift
//  a3
//
//  Created by Kevin Won on 6/25/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            Button(action: { viewModel.newGame() }) { Text("New Game")
                .font(.caption) }
            AspectVGrid(items: viewModel.cardsOnScreen, aspectRatio: 2/3) { card in
                CardView(viewModel: viewModel, card: card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                    .foregroundColor(viewModel.borderColor(for: card))
                }
                .padding(.horizontal)
            Button(action: { viewModel.dealCards() }) { Text("Deal 3 More Cards")
                .font(.caption) }.opacity(viewModel.opacityOfDealButton())
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
