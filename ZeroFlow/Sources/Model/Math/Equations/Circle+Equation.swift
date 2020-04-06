//
//  Circle+Equation.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

extension Equation {
    
    static func circle(radius: CGFloat, t: CGFloat) -> CGPoint {
        
        let x = radius * cos(t)
        let y = radius * sin(t)
        
        return CGPoint(x: x, y: y)
    }
    
}
