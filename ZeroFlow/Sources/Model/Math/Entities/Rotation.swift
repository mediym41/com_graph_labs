//
//  Rotation.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

public enum Angle {
    case radians(CGFloat)
    case degrees(Int)
    
    var radians: CGFloat {
        switch self {
        case .radians(let value):
            return value
        
        case .degrees(let value):
            return Angle.radians(degrees: value)
        }
    }
    
    var degrees: Int {
        switch self {
        case .radians(let value):
            return Angle.degrees(radians: value)
        
        case .degrees(let value):
            return value
        }
    }
    
    static func radians(degrees: Int) -> CGFloat {
        return CGFloat(degrees) * .pi / 180
    }
    
    static func degrees(radians: CGFloat) -> Int {
        return Int(round(radians * 180 / .pi))
    }
}


