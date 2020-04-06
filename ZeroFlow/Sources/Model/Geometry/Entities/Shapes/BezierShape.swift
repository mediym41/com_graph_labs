//
//  BezierShape.swift
//  ZeroFlow
//
//  Created by Mediym on 4/4/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

struct BezierShape: Shape2D {
    
    var bezierPathes: [BezierPath]
    
    var pathes: [Path2D] {
        return bezierPathes.map { $0.path }
    }
    
    var skeletonPaths: [Path2D] {
        return bezierPathes.map { $0.skeletonPath }
    }
    
    var code: String {
        var result: String = ""
        
        result += "BezierShape(bezierPathes: ["
        result += bezierPathes.map { $0.code }.joined(separator: ", ")
        result += "])"
        
        return result
    }
    
    init(bezierPathes: [BezierPath]) {
        self.bezierPathes = bezierPathes
    }
    
}

extension BezierShape {
    
    static var empty: BezierShape {
        return BezierShape(bezierPathes: [])
    }
    
    static var ship: BezierShape {
        return BezierShape(bezierPathes: [BezierPath(p0: CGPoint(x: 77.66667175292969, y: 210.66665649414062), p1: CGPoint(x: 60.66667175292969, y: 144.3333282470703), p2: CGPoint(x: 4.6666717529296875, y: -45.66667175292969), p3: CGPoint(x: -17.0, y: -132.6666717529297)), BezierPath(p0: CGPoint(x: -126.0, y: -52.666656494140625), p1: CGPoint(x: -53.66667175292969, y: 50.66667175292969), p2: CGPoint(x: -0.6666717529296875, y: 108.0), p3: CGPoint(x: 79.0, y: 211.0)), BezierPath(p0: CGPoint(x: -125.66667175292969, y: -51.0), p1: CGPoint(x: -97.33334350585938, y: -68.66667175292969), p2: CGPoint(x: -50.0, y: -92.0), p3: CGPoint(x: -11.666656494140625, y: -114.00001525878906)), BezierPath(p0: CGPoint(x: -135.66665649414062, y: -138.33331298828125), p1: CGPoint(x: -104.33332824707031, y: -123.66665649414062), p2: CGPoint(x: -67.66667175292969, y: -109.66665649414062), p3: CGPoint(x: 38.66667175292969, y: -60.333343505859375)), BezierPath(p0: CGPoint(x: 107.0, y: -119.33334350585938), p1: CGPoint(x: 171.0, y: -91.99998474121094), p2: CGPoint(x: 183.66665649414062, y: 121.33334350585938), p3: CGPoint(x: 51.0, y: 110.0)), BezierPath(p0: CGPoint(x: 36.666656494140625, y: -61.0), p1: CGPoint(x: 103.00001525878906, y: -6.0), p2: CGPoint(x: 109.33334350585938, y: 47.99998474121094), p3: CGPoint(x: 52.333343505859375, y: 109.33332824707031)), BezierPath(p0: CGPoint(x: 49.33332824707031, y: 108.66667175292969), p1: CGPoint(x: 42.33332824707031, y: -7.0), p2: CGPoint(x: 35.666656494140625, y: -88.0), p3: CGPoint(x: 32.33332824707031, y: -135.99998474121094)), BezierPath(p0: CGPoint(x: 110.00001525878906, y: -118.33334350585938), p1: CGPoint(x: 82.33331298828125, y: -111.66668701171875), p2: CGPoint(x: 46.66668701171875, y: -101.33334350585938), p3: CGPoint(x: -1.0, y: -77.0)), BezierPath(p0: CGPoint(x: -149.33335876464844, y: -182.00001525878906), p1: CGPoint(x: -91.66665649414062, y: -149.6666717529297), p2: CGPoint(x: -102.33332824707031, y: -178.0), p3: CGPoint(x: -74.66665649414062, y: -173.6666717529297)), BezierPath(p0: CGPoint(x: -74.99998474121094, y: -173.6666717529297), p1: CGPoint(x: -34.0, y: -152.3333282470703), p2: CGPoint(x: -28.666641235351562, y: -185.6666717529297), p3: CGPoint(x: -3.6666412353515625, y: -168.6666717529297)), BezierPath(p0: CGPoint(x: 66.33332824707031, y: -167.66665649414062), p1: CGPoint(x: 34.666656494140625, y: -184.6666717529297), p2: CGPoint(x: 31.666656494140625, y: -152.99998474121094), p3: CGPoint(x: -5.3333282470703125, y: -169.00003051757812)), BezierPath(p0: CGPoint(x: 140.6666717529297, y: -166.66665649414062), p1: CGPoint(x: 97.33331298828125, y: -193.6666717529297), p2: CGPoint(x: 96.66668701171875, y: -147.0), p3: CGPoint(x: 66.0, y: -168.0)), BezierPath(p0: CGPoint(x: -136.3333282470703, y: -137.6666717529297), p1: CGPoint(x: -84.33332824707031, y: -127.66667175292969), p2: CGPoint(x: 41.66667175292969, y: -126.33332824707031), p3: CGPoint(x: 81.0, y: -149.66665649414062)), BezierPath(p0: CGPoint(x: 63.66667175292969, y: -169.33334350585938), p1: CGPoint(x: 70.33334350585938, y: -160.33334350585938), p2: CGPoint(x: 79.33334350585938, y: -157.33334350585938), p3: CGPoint(x: 81.0, y: -149.33334350585938)), BezierPath(p0: CGPoint(x: -118.33334350585938, y: -169.00001525878906), p1: CGPoint(x: -134.6666717529297, y: -163.6666717529297), p2: CGPoint(x: -137.6666717529297, y: -145.6666717529297), p3: CGPoint(x: -135.66665649414062, y: -136.0))])
    }
    
    static var fish: BezierShape {
        return BezierShape(bezierPathes: [BezierPath(p0: CGPoint(x: -14.333328247070312, y: -33.33332824707031), p1: CGPoint(x: 8.333343505859375, y: -90.66667175292969), p2: CGPoint(x: 7.666656494140625, y: -154.66665649414062), p3: CGPoint(x: -49.33332824707031, y: -46.333343505859375)), BezierPath(p0: CGPoint(x: -14.333328247070312, y: -34.0), p1: CGPoint(x: -1.66668701171875, y: -29.333328247070312), p2: CGPoint(x: 19.0, y: -26.000015258789062), p3: CGPoint(x: 29.666656494140625, y: -26.666656494140625)), BezierPath(p0: CGPoint(x: 49.666656494140625, y: -22.666671752929688), p1: CGPoint(x: 57.0, y: -34.666656494140625), p2: CGPoint(x: 41.666656494140625, y: -58.99998474121094), p3: CGPoint(x: 28.666656494140625, y: -25.666656494140625)), BezierPath(p0: CGPoint(x: 73.66665649414062, y: -18.0), p1: CGPoint(x: 56.99998474121094, y: -21.666671752929688), p2: CGPoint(x: 54.66667175292969, y: -23.0), p3: CGPoint(x: 49.0, y: -25.0)), BezierPath(p0: CGPoint(x: -91.33332824707031, y: 41.66667175292969), p1: CGPoint(x: -109.0, y: 79.33334350585938), p2: CGPoint(x: -122.0, y: 173.3333282470703), p3: CGPoint(x: -54.33332824707031, y: 56.33332824707031)), BezierPath(p0: CGPoint(x: 6.6666717529296875, y: 31.0), p1: CGPoint(x: -10.333343505859375, y: 68.66667175292969), p2: CGPoint(x: 89.99998474121094, y: 158.00001525878906), p3: CGPoint(x: -56.333343505859375, y: 56.66667175292969)), BezierPath(p0: CGPoint(x: 20.666671752929688, y: 30.666656494140625), p1: CGPoint(x: 11.000015258789062, y: 28.66668701171875), p2: CGPoint(x: 10.666671752929688, y: 28.333328247070312), p3: CGPoint(x: 6.0, y: 33.333343505859375)), BezierPath(p0: CGPoint(x: 19.333328247070312, y: 29.333328247070312), p1: CGPoint(x: 54.0, y: 78.99998474121094), p2: CGPoint(x: 56.666656494140625, y: 45.00001525878906), p3: CGPoint(x: 43.33335876464844, y: 16.0)), BezierPath(p0: CGPoint(x: 139.3333282470703, y: 79.0), p1: CGPoint(x: 122.33332824707031, y: 25.333343505859375), p2: CGPoint(x: 76.0, y: -7.3333282470703125), p3: CGPoint(x: 42.66667175292969, y: 18.0)), BezierPath(p0: CGPoint(x: 130.99998474121094, y: -77.0), p1: CGPoint(x: 53.33332824707031, y: -15.0), p2: CGPoint(x: 168.0, y: 32.66667175292969), p3: CGPoint(x: 139.3333282470703, y: 79.33334350585938)), BezierPath(p0: CGPoint(x: 72.66667175292969, y: -17.0), p1: CGPoint(x: 90.0, y: -63.33332824707031), p2: CGPoint(x: 117.0, y: -81.66665649414062), p3: CGPoint(x: 131.0, y: -76.00001525878906)), BezierPath(p0: CGPoint(x: -146.0, y: -16.0), p1: CGPoint(x: -125.99996948242188, y: -31.666671752929688), p2: CGPoint(x: -120.66664123535156, y: -30.333328247070312), p3: CGPoint(x: -99.00001525878906, y: -38.99998474121094)), BezierPath(p0: CGPoint(x: -48.33332824707031, y: -46.333343505859375), p1: CGPoint(x: -60.33332824707031, y: -42.66667175292969), p2: CGPoint(x: -74.0, y: -49.33332824707031), p3: CGPoint(x: -107.33334350585938, y: -36.333343505859375)), BezierPath(p0: CGPoint(x: -137.00001525878906, y: 32.0), p1: CGPoint(x: -164.0, y: 14.333343505859375), p2: CGPoint(x: -156.66665649414062, y: -10.333328247070312), p3: CGPoint(x: -145.0, y: -17.000015258789062)), BezierPath(p0: CGPoint(x: -137.6666717529297, y: 31.000015258789062), p1: CGPoint(x: -122.0, y: 42.33332824707031), p2: CGPoint(x: -111.33332824707031, y: 44.333343505859375), p3: CGPoint(x: -91.33334350585938, y: 42.66667175292969))])

    }
    
}
