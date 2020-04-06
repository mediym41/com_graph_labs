//
//  BezierPath.swift
//  ZeroFlow
//
//  Created by Mediym on 4/4/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

class BezierPath {
    
    var p0, p1, p2, p3: CGPoint
    
    func update(selectedPoint: SelectedPointIndex, point: CGPoint) {
        switch selectedPoint {
        case .zero:
            p0 = point
            
        case .one:
            p1 = point
            
        case .two:
            p2 = point
            
        case .three:
            p3 = point
        }
    }
    
    var points: [CGPoint] {
        return [p0, p1, p2, p3]
    }
    
    var path: Path2D {
        let step: CGFloat = 0.1
        
        let points = stride(from: 0, through: 1, by: step).map { t in
            return point(t: t)
        }
        
        return Path2D(points: points)
    }
    
    var skeletonPath: Path2D {
        return Path2D(points: [p0, p1, p2, p3])
    }
    
    var code: String {
        
        var result: String = ""
        
        result += "BezierPath"
        result += "("
        
        var params: [String] = []
        for i in 0 ..< points.count {
            params.append("p\(i): \(points[i].code)")
        }
        
        result += params.joined(separator: ", ")
        
        result += ")"
        
        return result
    }
    
    init(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }
    
    private func point(t dirtyT: CGFloat) -> CGPoint {
        let t = min(1, max(0, dirtyT))
        
        return [
            pow((1 - t), 3) * p0,
            3 * t * pow((1 - t), 2) * p1,
            3 * pow(t, 2) * (1 - t) * p2,
            pow(t, 3) * p3
        ].reduce(.zero, +)
    }
    
}
