//
//  a2App.swift
//  a2
//
//  Created by Kevin Won on 6/15/22.
//

import SwiftUI

@main
struct a2App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
