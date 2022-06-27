//
//  Diamond.swift
//  a3
//
//  Created by Kevin Won on 6/26/22.
//

import SwiftUI

struct Diamond: Shape {
    var startAngle: Angle = Angle(degrees: 0-90)
    var endAngle: Angle = Angle(degrees: 0-190)
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
    
        return p
    }
}


