//
//  DetailZeroShape.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

class DetailZeroShape2D: Shape2D {
    
    public struct Parameters {
        public let h1: CGFloat
        public let h2: CGFloat
        public let h3: CGFloat
        public let h4: CGFloat
        
        public let w1: CGFloat
        public let w2: CGFloat
        
        public let r1: CGFloat
        public let r2: CGFloat
        
        public init(r1: CGFloat = 0,
             r2: CGFloat = 0,
             h1: CGFloat = 0,
             h2: CGFloat = 0,
             h3: CGFloat = 0,
             h4: CGFloat = 0,
             w1: CGFloat = 0,
             w2: CGFloat = 0) {
            
            self.r1 = r1
            self.r2 = r2
            
            self.h1 = h1
            self.h2 = h2
            self.h3 = h3
            self.h4 = h4
            
            self.w1 = w1
            self.w2 = w2
        }
    }
    
    var center: CGPoint
    var params: Parameters

    init(center: CGPoint, params: Parameters) {
       self.center = center
       self.params = params
    }
    
    var pathes: [Path2D] {
        
        var result: [Path2D] = []
        
        let innerCircle = ArcShape2D(center: center, radius: params.r1)
        result.append(contentsOf: innerCircle.pathes)
        
        var outterPath = Path2D()
        
        let topCircleCenter = center + CGPoint(x: 0, y: params.h1)
        let topCircle = ArcShape2D(center: topCircleCenter,
                                   radius: params.r1,
                                   start: .degrees(90),
                                   end: .degrees(0),
                                   clockwise: true)
        outterPath.append(pathes: topCircle.pathes)
                
        let outterRightCircleCenter = center + CGPoint(x: params.w1, y: -params.h3)
        let outterRightCircle = ArcShape2D(center: outterRightCircleCenter,
                                         radius: params.r2,
                                         start: .degrees(45),
                                         end: .degrees(-135),
                                         clockwise: true)
        outterPath.append(pathes: outterRightCircle.pathes)
        
        let innerRightCircleCenter = center + CGPoint(x: params.w2, y: -params.h4)
        let innerRightCircle = ArcShape2D(center: innerRightCircleCenter,
                                        radius: params.r2,
                                        start: .degrees(45),
                                        end: .degrees(225),
                                        clockwise: false)
        outterPath.append(pathes: innerRightCircle.pathes)
        
        let bottomPoint = center + CGPoint(x: 0, y: -params.h2)
        outterPath.append(point: bottomPoint)
        
        let pointsTransformer = PointTransformer2D(points: outterPath.points)
        pointsTransformer.mirror(by: .x)
        outterPath.append(points: pointsTransformer.build().reversed())
        
        result.append(outterPath)
        
        return result
    }
    
}

//public struct DetailZeroShape: Shape {
//    
//    public struct Parameters {
//        public let h1: CGFloat
//        public let h2: CGFloat
//        public let h3: CGFloat
//        public let h4: CGFloat
//        
//        public let w1: CGFloat
//        public let w2: CGFloat
//        
//        public let r1: CGFloat
//        public let r2: CGFloat
//        
//        public init(r1: CGFloat = 0,
//             r2: CGFloat = 0,
//             h1: CGFloat = 0,
//             h2: CGFloat = 0,
//             h3: CGFloat = 0,
//             h4: CGFloat = 0,
//             w1: CGFloat = 0,
//             w2: CGFloat = 0) {
//            
//            self.r1 = r1
//            self.r2 = r2
//            
//            self.h1 = h1
//            self.h2 = h2
//            self.h3 = h3
//            self.h4 = h4
//            
//            self.w1 = w1
//            self.w2 = w2
//        }
//    }
//    
//    let center: CGPoint
//    let params: Parameters
//    
//    public var path: Path {
//        return Path(lines: lines)
//    }
//    
//    public init(center: CGPoint, params: Parameters) {
//        self.center = center
//        self.params = params
//    }
//    
//    var lines: [Line] {
//        
//        var resultPath = Path()
//        
//        let innerCircle = ArcShape(center: center, radius: params.r1)
//        resultPath.add(path: innerCircle.path)
//        
//        var outterPath = Path()
//        
//        let topCircleCenter = center + CGPoint(x: 0, y: params.h1)
//        let topCircle = ArcShape(center: topCircleCenter,
//                                 radius: params.r1,
//                                 start: .degrees(90),
//                                 end: .degrees(0),
//                                 clockwise: true)
//        outterPath.set(path: topCircle.path)
//        
//        let outterRightCircleCenter = center + CGPoint(x: params.w1, y: -params.h3)
//        let outterRightCircle = ArcShape(center: outterRightCircleCenter,
//                                         radius: params.r2,
//                                         start: .degrees(45),
//                                         end: .degrees(-135),
//                                         clockwise: true)
//        outterPath.connect(path: outterRightCircle.path)
//        
//        let innerRightCircleCenter = center + CGPoint(x: params.w2, y: -params.h4)
//        let innerRightCircle = ArcShape(center: innerRightCircleCenter,
//                                        radius: params.r2,
//                                        start: .degrees(45),
//                                        end: .degrees(225),
//                                        clockwise: false)
//        outterPath.connect(path: innerRightCircle.path)
//        
//        let bottomPoint = center + CGPoint(x: 0, y: -params.h2)
//        outterPath.addLine(to: bottomPoint)
//        
//        let mirroredOutterPath = outterPath.mirroredByAxisX
//        
//        resultPath.add(path: outterPath)
//        resultPath.add(path: mirroredOutterPath)
//        
//        return resultPath.lines
//    }
//
//}
