//
//  UniformPoint2D.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

struct UniformPoint2D {
    
    let x: CGFloat
    let y: CGFloat
    let w: CGFloat
    
    init(x: CGFloat, y: CGFloat, w: CGFloat = 1) {
        self.x = x
        self.y = y
        self.w = w
    }
}
