//
//  a4App.swift
//  a4
//
//  Created by Kevin Won on 7/6/22.
//

import SwiftUI

@main
struct a4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: GameViewModel())
        }
    }
}
