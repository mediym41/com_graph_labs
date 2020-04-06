//
//  UIBezierPath+Extensions.swift
//  lab_1
//
//  Created by Mediym on 2/10/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    func moveTo(x: CGFloat, y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }
    
    func lineTo(x: CGFloat, y: CGFloat) {
        self.addLine(to: CGPoint(x: x, y: y))
    }
    
    convenience init(lines: [Line]) {
        self.init()
        
        lines.forEach { line in
            move(to: line.start)
            addLine(to: line.end)
        }
    }
    
    convenience init(pathes: [Path2D]) {
        self.init()
        
        for path in pathes where path.points.count > 0 {
            
            move(to: path.points[0])
            
            for i in 1 ..< path.points.count {
                addLine(to: path.points[i])
            }
        }
    }
    
    convenience init(path: Path2D) {
        self.init(pathes: [path])
    }
    
}
