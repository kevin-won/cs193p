//
//  ThemeManagerView.swift
//  a6
//
//  Created by Kevin Won on 7/25/22.
//

import SwiftUI

// A View which manages all the Themes in a ThemeStore

struct ThemeManagerView: View {
    @ObservedObject var store: ThemeStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
    @Environment(\.presentationMode) var presentationMode
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    @State private var themeToEdit: Theme?
    
    @State private var chosenThemeIndex = 0
    
    @State private var game: EmojiMemoryGame?
    
    func destinationGame(with theme: Theme) -> EmojiMemoryGame {
        if let unwrappedGame = game {
            if unwrappedGame.chosenTheme == theme {
                return game!
            }
        }
        return EmojiMemoryGame(with: theme)
    }

    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    let new_game = destinationGame(with: theme)
                    NavigationLink(destination: EmojiMemoryGameView(game: new_game)) {
                        themeRow(for: theme, in: new_game)
                    }
                    .gesture(editMode == .active ? tap(for: theme) : nil)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Memorize!")
            .sheet(item: $themeToEdit) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addTheme) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    if presentationMode.wrappedValue.isPresented {
//                        Button("Close") {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }
            
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
        }
    }
    
    func addTheme() {
        store.insertTheme(named: "New", emojis: "", at: chosenThemeIndex, color: "Black")
        themeToEdit = store.theme(at: chosenThemeIndex)
    }
    
    
    
    func tap(for theme: Theme) -> some Gesture {
        return TapGesture().onEnded {
            themeToEdit = store.themes[theme]
        }
    }
    
    func themeRow(for theme: Theme, in game: EmojiMemoryGame) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(.title)
                .foregroundColor(game.color(for: theme))
            Text("All of " + theme.emojis).lineLimit(1)
            Text("Number of pairs of cards is \(theme.numberOfPairsOfCards)")
        }
    }
}

struct ThemeManagerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManagerView(store: ThemeStore(named: "Default"))
            .preferredColorScheme(.light)
    }
}


