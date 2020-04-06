//
//  Accuracy.swift
//  ZeroFlow
//
//  Created by Mediym on 2/24/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    func isLess(than value: CGFloat, accuracy: CGFloat = 1e-7) -> Bool {
        let distanceToValue = distance(to: value)
        return abs(distanceToValue) < accuracy || distanceToValue > 0
    }
    
    func isEqual(with value: CGFloat, accuracy: CGFloat = 1e-7) -> Bool {
        let distanceToValue = distance(to: value)
        return abs(distanceToValue) < accuracy
    }
    
}
