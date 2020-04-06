//
//  CGPoint+Extensions.swift
//  lab_1
//
//  Created by Mediym on 2/10/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    func length(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    func tang(with point: CGPoint) -> CGFloat {
        return point.x - x / point.y / y
    }
    
    var weight: CGFloat {
        return abs(x) + abs(y)
    }
    
    var uniformedPointArray: [CGFloat] {
        return [x, y, 1]
    }
    
    var uniformedPointMatrix: Matrix<CGFloat> {
        return Matrix<CGFloat>(rows: [uniformedPointArray])
    }
    
    var code: String {
        return "CGPoint(x: \(x), y: \(y))"
    }
    
}
