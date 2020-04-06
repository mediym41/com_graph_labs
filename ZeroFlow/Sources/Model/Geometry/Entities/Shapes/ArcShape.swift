//
//  ArcShape.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

struct ArcShape2D: Shape2D {
    private let step: CGFloat = Angle.degrees(10).radians
    
    let center: CGPoint
    let radius: CGFloat
    let startRadians: CGFloat
    let endRadians: CGFloat
    let clockwise: Bool
    
    init(center: CGPoint = .zero,
         radius: CGFloat,
         start startAngle: Angle = .degrees(0),
         end endAngle: Angle = .degrees(360),
         clockwise: Bool = false) {
        
        self.center = center
        self.radius = radius
        self.startRadians = startAngle.radians
        self.endRadians = endAngle.radians
        self.clockwise = clockwise
    }
    
    var pathes: [Path2D] {
            
        var start, end: CGFloat
        
        if abs(endRadians - startRadians) >= 2 * .pi {
            start = 0
            end = 2 * .pi
        } else {
            
            if clockwise {
                start = endRadians
                end = startRadians
            } else {
                start = startRadians
                end = endRadians
            }
            
            if start > end {
                end += 2 * .pi
            }
        }
        
        var result = Path2D()
        var current = start
        
        while current.isLess(than: end, accuracy: 1e-7) {
            let point = center + Equation.circle(radius: radius, t: current)
            result.append(point: point)
            
            current += step
        }
        
        if !current.isEqual(to: end) {
            let point = center + Equation.circle(radius: radius, t: end)
            result.append(point: point)
        }
        
        if clockwise {
            result.points.reverse()
        }
        
        return [result]
        
    }

}

struct ArcShape: Shape {

    private let step: CGFloat = Angle.degrees(10).radians
    
    let center: CGPoint
    let radius: CGFloat
    let startRadians: CGFloat
    let endRadians: CGFloat
    let clockwise: Bool
    
    init(center: CGPoint = .zero,
         radius: CGFloat,
         start startAngle: Angle = .degrees(0),
         end endAngle: Angle = .degrees(360),
         clockwise: Bool = false) {
        
        self.center = center
        self.radius = radius
        self.startRadians = startAngle.radians
        self.endRadians = endAngle.radians
        self.clockwise = clockwise
    }
    
    var path: Path {
        return Path(lines: lines, startPoint: startPoint, endPoint: endPoint)
    }
    
    var startPoint: CGPoint {
        return center + Equation.circle(radius: radius, t: startRadians)
    }
    
    var endPoint: CGPoint {
        return center + Equation.circle(radius: radius, t: endRadians)
    }
    
    var lines: [Line] {
        
        var start, end: CGFloat
        
        if abs(endRadians - startRadians) >= 2 * .pi {
            start = 0
            end = 2 * .pi
        } else {
            
            if clockwise {
                start = endRadians
                end = startRadians
            } else {
                start = startRadians
                end = endRadians
            }
            
            if start > end {
                end += 2 * .pi
            }
        }
        
        var result: [Line] = []
        var current = start
        
        while current.isLess(than: end, accuracy: 1e-7) {
            let startPoint = center + Equation.circle(radius: radius, t: current)
            let tNext = current + step < end ? current + step : end
            let endPoint = center + Equation.circle(radius: radius, t: tNext)
            
            let line = Line(start: startPoint, end: endPoint)
            
            result.append(line)
            
            current += step
            print(current)
        }
                
        return result
    }
    
}
