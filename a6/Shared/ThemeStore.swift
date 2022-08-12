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
    var rgbaColor: RGBAColor
    
    fileprivate init(name: String, emojis: String, id: Int, numberOfPairsOfCards: Int, rgbaColor: RGBAColor) {
        self.name = name
        self.emojis = emojis
        self.id = id
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self.rgbaColor = rgbaColor
    }
}

// A simple, persistent storage place for Themes. This is our ViewModel.

class ThemeStore: ObservableObject {
    let name: String
            
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }

    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }

    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }

    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            print("Hello")
            insertTheme(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", rgbaColor: RGBAColor(255,0,0,1))
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", rgbaColor: RGBAColor(0,255,0,1))
            insertTheme(named: "COVID", emojis: "💉🦠😷🤧🤒", rgbaColor: RGBAColor(0,0,255,1))
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", rgbaColor: RGBAColor(196,96,96,1))
            insertTheme(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", rgbaColor: RGBAColor(10,10,10,1))
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", rgbaColor: RGBAColor(20,196,196,1))
            insertTheme(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", rgbaColor: RGBAColor(1,96,255,1))
            insertTheme(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", rgbaColor: RGBAColor(82,9,233,1))
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
    
    func insertTheme(named name: String, emojis: String? = nil, at index: Int = 0, rgbaColor: RGBAColor) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", id: unique, numberOfPairsOfCards: emojis!.count, rgbaColor: rgbaColor)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}


