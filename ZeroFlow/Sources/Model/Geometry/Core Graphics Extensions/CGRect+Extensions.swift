//
//  CGRect+Extensions.swift
//  lab_1
//
//  Created by Mediym on 2/10/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    var center: CGPoint {
        let x = minX + width / 2
        let y = minY + height / 2
        
        return CGPoint(x: x, y: y)
    }
    
}
