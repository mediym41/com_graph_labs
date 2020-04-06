//
//  CartesianCoordinateSystemView.swift
//  lab_1
//
//  Created by Mediym on 2/10/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

struct GridShape2D: Shape2D {
    
    var size: CGSize
    var division: CGFloat
    
    init(division: CGFloat, size: CGSize) {
        self.division = division
        self.size = size
    }

    var pathes: [Path2D] {
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        var result: [Path2D] = []
        
        let firstHorizontalGridLine = centerY.truncatingRemainder(dividingBy: division) - centerY
        
        for y in stride(from: firstHorizontalGridLine, to: centerY, by: division) {
            let path = Path2D(points: [
                CGPoint(x: -centerX, y: y),
                CGPoint(x: centerX, y: y)
            ])
            
            result.append(path)
        }
        
        let firstVerticalGridLine = centerX.truncatingRemainder(dividingBy: division) - centerX
        
        for x in stride(from: firstVerticalGridLine, to: centerX, by: division) {
            let path = Path2D(points: [
                CGPoint(x: x, y: -centerY),
                CGPoint(x: x, y: centerY)
            ])
            
            result.append(path)
        }
        
        return result
    }
}

//@IBDesignable
class CartesianCoordinateSystemView: UIView {

    @IBInspectable public var divisionSize: CGFloat = 10
        
    var gridLayer: CAShapeLayer!
    var shapeLayer: CAShapeLayer!
    var notesLayer: CAShapeLayer!
        
    override func awakeFromNib() {
        super.awakeFromNib()
            
        gridLayer = CAShapeLayer()
        gridLayer.strokeColor = UIColor.gray.cgColor
        gridLayer.lineWidth = 1
        gridLayer.fillColor = nil
        layer.addSublayer(gridLayer)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
        layer.addSublayer(shapeLayer)
        
        notesLayer = CAShapeLayer()
        notesLayer.strokeColor = UIColor.blue.cgColor
        notesLayer.lineWidth = 2
        notesLayer.fillColor = UIColor.blue.cgColor
        layer.addSublayer(notesLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = bounds
        notesLayer.frame = bounds
        gridLayer.frame = bounds
    }
    
    func configure(grid: Shape2D) {
        draw(shape: grid, in: gridLayer)
    }
    
    func configure(shape: Shape2D) {
        draw(shape: shape, in: shapeLayer)
    }
    
    func configure(markers: [Shape2D]) {
        draw(shapes: markers, in: notesLayer)
    }
    
    private func drawAxes(in rect: CGRect) {
        let centerPoint = rect.center
        
        let xAxisPath = UIBezierPath()
        xAxisPath.moveTo(x: centerPoint.x, y: rect.minY)
        xAxisPath.lineTo(x: centerPoint.x, y: rect.maxY)
        
        let yAxisPath = UIBezierPath()
        yAxisPath.moveTo(x: rect.minX, y: centerPoint.y)
        yAxisPath.lineTo(x: rect.maxX, y: centerPoint.y)
        
        UIColor.black.set()
        
        xAxisPath.lineWidth = 1
        xAxisPath.stroke()
        
        yAxisPath.lineWidth = 1
        yAxisPath.stroke()
    }
    
    private func drawGrid(in rect: CGRect, division: CGFloat) {
        
        let gridPath = UIBezierPath()
        
        let centerPoint = rect.center
        
        let firstHorizontalGridLine = centerPoint.y.truncatingRemainder(dividingBy: division)
        
        for y in stride(from: firstHorizontalGridLine, to: rect.maxY, by: division) {
            gridPath.moveTo(x: rect.minX, y: y)
            gridPath.lineTo(x: rect.maxY, y: y)
        }
        
        let firstVerticalGridLine = centerPoint.x.truncatingRemainder(dividingBy: division)
        
        for x in stride(from: firstVerticalGridLine, to: rect.maxY, by: division) {
            gridPath.moveTo(x: x, y: rect.minY)
            gridPath.lineTo(x: x, y: rect.maxY)
        }
        
        UIColor.gray.set()
        gridPath.lineWidth = 1
        gridPath.stroke()
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
    
}
