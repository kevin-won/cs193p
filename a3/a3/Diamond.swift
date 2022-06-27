//
//  Diamond.swift
//  a3
//
//  Created by Kevin Won on 6/26/22.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let bottom = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: rect.midY)

        var p = Path()
        p.move(to: bottom)
        p.addLine(to: right)
        p.addLine(to: top)
        p.addLine(to: left)
        p.addLine(to: bottom)
        
        return p
    }
}



