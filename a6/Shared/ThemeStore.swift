//
//  ThemeStore.swift
//  a6
//
//  Created by Kevin Won on 7/25/22.
//

import Foundation

// A struct that defines a theme

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id: Int
    var numberOfPairsOfCards: Int
    var color: String = "Color"
    
    fileprivate init(name: String, emojis: String, id: Int, numberOfPairsOfCards: Int, color: String) {
        self.name = name
        self.emojis = emojis
        self.id = id
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self.color = color
    }
}

// A simple, persistent storage place for Themes. This is our ViewModel.

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]()
//    didSet {
//        storeInUserDefaults()
//    }
    
//    private var userDefaultsKey: String {
//        "PaletteStore:" + name
//    }
//
//    private func storeInUserDefaults() {
//        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
////        UserDefaults.standard.set(palettes.map { [$0.name,$0.emojis,String($0.id)] }, forKey: userDefaultsKey)
//    }
//
//    private func restoreFromUserDefaults() {
//        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
//           let decodedPalettes = try? JSONDecoder().decode(Array<Palette>.self, from: jsonData) {
//            palettes = decodedPalettes
//        }
////        if let palettesAsPropertyList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String]] {
////            for paletteAsArray in palettesAsPropertyList {
////                if paletteAsArray.count == 3, let id = Int(paletteAsArray[2]), !palettes.contains(where: { $0.id == id }) {
////                    let palette = Palette(name: paletteAsArray[0], emojis: paletteAsArray[1], id: id)
////                    palettes.append(palette)
////                }
////            }
////        }
//    }
    
    init(named name: String) {
        self.name = name
//        restoreFromUserDefaults()
        if themes.isEmpty {
            insertTheme(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: "green")
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: "blue")
            insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒", color: "pink")
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: "orange")
            insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: "purple")
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: "yellow")

            insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: "blue")
            insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: "red")
            insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: "green")
        }
    }
    
    // MARK: - Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }

    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, emojis: String? = nil, at index: Int = 0, color: String) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", id: unique, numberOfPairsOfCards: emojis!.count, color: color)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}


