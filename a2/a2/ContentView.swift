//
//  ContentView.swift
//  a2
//
//  Created by Kevin Won on 6/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        ScrollView {
            Text(viewModel.theme.name)
                .font(.largeTitle)
                .foregroundColor(viewModel.color(for: viewModel.theme))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.cards) { card in CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            Text(String(viewModel.getScore()))
                .font(.largeTitle)
            Button(action: viewModel.newGame, label: {
                Text("New Game")
                    .font(.largeTitle)
            })
        }
        .foregroundColor(.red)
        .padding(.horizontal)
        
    }
}


struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body : some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
}
