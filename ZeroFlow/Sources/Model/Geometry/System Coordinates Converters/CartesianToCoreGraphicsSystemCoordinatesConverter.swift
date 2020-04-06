//
//  CartesianToCoreGraphicsSystemCoordinatesConverter.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import CoreGraphics

class CartesianToCoreGraphicsSystemCoordinatesConverter: SystemCoordinatesConverter {
    
    var coreGraphicsRect: CGRect
    var coreGraphicsRectCenter: CGPoint
    
    init(rect: CGRect = .zero) {
        self.coreGraphicsRect = rect
        self.coreGraphicsRectCenter = rect.center
    }
    
    /**
     - Parameters:
        - point: Cartesian Coordinate
     
     - Return:
        CoreGraphics Coordinate
     */
    func convert(point: CGPoint) -> CGPoint {
        
        let x = coreGraphicsRectCenter.x + point.x
        let y = coreGraphicsRectCenter.y - point.y
        
        return CGPoint(x: x, y: y)
    }
    
}

class CoreGraphicsToCartesianSystemCoordinatesConverter: SystemCoordinatesConverter {
    
    var coreGraphicsRect: CGRect
    var coreGraphicsRectCenter: CGPoint
    
    init(rect: CGRect = .zero) {
        self.coreGraphicsRect = rect
        self.coreGraphicsRectCenter = rect.center
    }
    
    /**
     - Parameters:
        - point: Cartesian Coordinate
     
     - Return:
        CoreGraphics Coordinate
     */
    func convert(point: CGPoint) -> CGPoint {
        
        let x = point.x - coreGraphicsRectCenter.x
        let y = coreGraphicsRectCenter.y - point.y
        
        return CGPoint(x: x, y: y)
    }
    
}
