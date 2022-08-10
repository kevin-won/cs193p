//
//  a6App.swift
//  a6
//
//  Created by Kevin Won on 7/25/2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    // Mark these as @StateObject since they are "sources of truth"
    @StateObject var themeStore = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
//            EmojiMemoryGameView(game: game)
//            // "Inject" our ThemeStore ViewModel into our View hierarchy
//                .environmentObject(themeStore)
            ThemeManagerView(store: themeStore)
        }
    }
    
    // Basically, we have a main GameView, and we pass in our Game ViewModel, as well as inject our ThemeStore ViewModel so that we can do operations through the view models
}
