//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Kevin Won on 7/9/22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
