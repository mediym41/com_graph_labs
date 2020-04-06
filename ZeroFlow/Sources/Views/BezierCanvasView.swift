//
//  CanvasView.swift
//  ZeroFlow
//
//  Created by Mediym on 4/4/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    private var shapeLayer: CAShapeLayer!
    private var skeletonLayer: CAShapeLayer!
    
    var shouldDrawSkeleton: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
                    
        shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = nil
        layer.addSublayer(shapeLayer)
        
        skeletonLayer = CAShapeLayer()
        skeletonLayer.strokeColor = UIColor.orange.cgColor
        skeletonLayer.lineWidth = 1
        skeletonLayer.fillColor = nil
        layer.addSublayer(skeletonLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = bounds
        skeletonLayer.frame = bounds
    }
    
    func configure(shape: BezierShape) {
        draw(shape: shape, in: shapeLayer)
        
        skeletonLayer.isHidden = !shouldDrawSkeleton
        if shouldDrawSkeleton {
            draw(pathes: shape.skeletonPaths, in: skeletonLayer)
        }
    }
        
    private func draw(shape: Shape2D, in rect: CGRect) {
        
        let converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: rect)
         
        let shapeBezierPath = UIBezierPath(pathes: shape.pathes.map { path in
            return converter.convert(path: path)
        })
        
        shapeLayer.path = shapeBezierPath.cgPath
//        UIColor.red.set()
//        shapeBezierPath.lineWidth = 2
        
//        shapeBezierPath.stroke()
    }
    
    private func draw(shape: Shape2D, in layer: CAShapeLayer) {
        draw(shapes: [shape], in: layer)
    }
    
    private func draw(shapes: [Shape2D], in layer: CAShapeLayer) {
        
        let converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: layer.bounds)
        
        
        let shapesBezierPath = UIBezierPath(pathes: shapes.flatMap { markers in
            return markers.pathes.map { path in
                return converter.convert(path: path)
            }
        })
        
        layer.path = shapesBezierPath.cgPath
    }
    
    private func draw(pathes: [Path2D], in layer: CAShapeLayer) {
         
         let converter = CartesianToCoreGraphicsSystemCoordinatesConverter(rect: layer.bounds)
         
         let shapesBezierPath = UIBezierPath(pathes: pathes.map { path in
            
             return converter.convert(path: path)
         })
         
         layer.path = shapesBezierPath.cgPath
     }
    
}
