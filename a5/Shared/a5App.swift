//
//  a5App.swift
//  Shared
//
//  Created by Kevin Won on 7/22/22.
//

import SwiftUI

@main
struct a5App: App {
    var body: some Scene {
        let document = EmojiArtDocument()

        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
