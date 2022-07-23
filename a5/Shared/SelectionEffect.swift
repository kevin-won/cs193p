//
//  SelectionEffect.swift
//  a5
//
//  Created by Kevin Won on 7/22/22.
//

import SwiftUI

struct SelectionEffect: ViewModifier {
    
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        content.overlay(
                isSelected ? RoundedRectangle(cornerRadius: 0).strokeBorder(lineWidth: 1.2).foregroundColor(.blue) : nil
            )
    }
}

extension EmojiArtDocumentView {
    func selectionEffect(isSelected: Bool) -> some View {
        return self.modifier(SelectionEffect(isSelected: isSelected))
    }
}
