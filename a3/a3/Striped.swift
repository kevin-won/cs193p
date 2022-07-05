//
//  Striped.swift
//  a3
//
//  Created by Kevin Won on 7/4/22.
//

import SwiftUI

struct StripeView<SymbolShape>: View where SymbolShape: Shape {
    
    private(set) var shape: SymbolShape
    
    private(set) var stripeColor: Color
    
    let spacingColor = Color.white
    
    let numberOfStripes: Int = 5

    let lineWidth: CGFloat = 2
    
    var body: some View {
        
        HStack(spacing: 0.5) {
            ForEach(0..<numberOfStripes, id: \.self) { _ in
                spacingColor
                stripeColor
            }
            
        }.mask(shape)
        .overlay(shape.stroke(stripeColor, lineWidth: lineWidth))
        
    }
}
