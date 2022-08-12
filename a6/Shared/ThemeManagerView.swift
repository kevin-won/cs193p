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
    
    @State private var games: [Theme: EmojiMemoryGame] = [:]
    
    func destinationView(for theme: Theme) -> EmojiMemoryGameView {
        if let unwrappedGame = games[theme] {
            return EmojiMemoryGameView(game: unwrappedGame)
        }
        let newGame = EmojiMemoryGame(with: theme)
        games[theme] = newGame
        return EmojiMemoryGameView(game: newGame)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: destinationView(for: theme)) {
                        themeRow(for: theme)
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
        store.insertTheme(named: "New", emojis: "", at: chosenThemeIndex, rgbaColor: RGBAColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0))
        themeToEdit = store.theme(at: chosenThemeIndex)
    }
    
    
    
    func tap(for theme: Theme) -> some Gesture {
        return TapGesture().onEnded {
            themeToEdit = store.themes[theme]
        }
    }
    
    func themeRow(for theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(.title)
                .foregroundColor(theme.color)
            Text("All of " + theme.emojis).lineLimit(1)
            Text("Card count: \(theme.numberOfPairsOfCards)")
        }
    }
}

//struct ThemeManagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeManagerView(store: ThemeStore(named: "Default"))
//            .preferredColorScheme(.light)
//    }
//}


