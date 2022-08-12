//
//  ThemeEditor.swift
//  a6 (iOS)
//
//  Created by Kevin Won on 8/9/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                removeEmojiSection
                addEmojisSection
                cardCountSection
                colorSection
            }
            .navigationTitle("Edit \(theme.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var nameSection: some View {
        Section(header: Text("Theme Name")) {
            TextField("Name", text: $theme.name)
        }
    }
    
    var removeEmojiSection: some View {
        Section(header:
            HStack {
                Text("Emojis")
                Spacer()
                Text("Tap Emoji to Exclude")
        }) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if theme.emojis.count > 2 {
                                    theme.emojis.removeAll(where: { String($0) == emoji })
                                }
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emoji")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    
    
    func incrementStep() {
        if theme.numberOfPairsOfCards < theme.emojis.count {
            theme.numberOfPairsOfCards += 1
        }
    }

    func decrementStep() {
        if theme.numberOfPairsOfCards > 2 {
            theme.numberOfPairsOfCards -= 1
        }
    }
    
    var cardCountSection: some View {
        Section(header: Text("Card Count")) {
            Stepper {
                Text("\(theme.numberOfPairsOfCards) Pairs")
            } onIncrement: {
                incrementStep()
            } onDecrement: {
                decrementStep()
            }
        }
    }
    
    var color: Binding<Color> {     // << here !!
        Binding {
            return Color(rgbaColor: theme.rgbaColor)
        } set: { newRGBAColor in
            theme.rgbaColor = RGBAColor(color: newRGBAColor)
        }
    }
        
    var colorSection: some View {
        Section(header: Text("Colors")) {
            VStack {
                ColorPicker("Selection", selection: self.color)
            }
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 4)))
            .previewLayout(.fixed(width: 300, height: 350))
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 2)))
            .previewLayout(.fixed(width: 300, height: 600))
    }
}
