//
//  Drawable.swift
//  lab_1
//
//  Created by Mediym on 2/10/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

public protocol Drawable {
    func draw()
}

public protocol Shape {
    var path: Path { get }
}

enum Axis {
    case x
    case y
}

struct ConvertableShape: Shape {
    var path: Path
    
    var center: CGPoint {
        let points = path.lines.map { CGPoint(x: ($0.start.x + $0.end.x) / 2,
                                              y: ($0.end.y + $0.end.y) / 2 ) }
        
        let point = points.reduce(.zero) { result, current in
            return CGPoint(x: result.x + current.x, y: result.y + current.y)
        }
        
        return CGPoint(x: point.x / CGFloat(points.count), y: point.y / CGFloat(points.count))
    }
    
    init(origin: Shape) {
        self.path = origin.path
    }
    
    mutating func translate(by point: CGPoint) {
        
        let points = path.lines.flatMap { [$0.start, $0.end] }.map { (point: CGPoint) -> [CGFloat] in
            let uniformPoint2D = UniformPoint2D(x: point.x, y: point.y)
            return [uniformPoint2D.x, uniformPoint2D.y, uniformPoint2D.w]
        }
        
        let pointsMatrix = Matrix<CGFloat>(rows: points)
        let translateMatrix = Matrix<CGFloat>(rows: [
            [1, 0, 0],
            [0, 1, 0],
            [point.x, point.y, 1]
        ])
        
        path.lines = pointsMatrix.matrixMultiply(by: translateMatrix).mapRows { row in
            return CGPoint(x: row[0], y: row[1])
            
        }.chunked(into: 2).map { points in
            return Line(start: points[0], end: points[1])
        }
    }
    
    mutating func rotate(by angle: Angle) {
        rotate(by: angle, realativeTo: center)
    }
    
    mutating func rotate(by angle: Angle, realativeTo point: CGPoint) {
        let radians = angle.radians
        
        let points = path.lines.flatMap { [$0.start, $0.end] }.map { (point: CGPoint) -> [CGFloat] in
            let uniformPoint2D = UniformPoint2D(x: point.x, y: point.y)
            return [uniformPoint2D.x, uniformPoint2D.y, uniformPoint2D.w]
        }
        
        let m = -point.x * (cos(radians) - 1) + point.y * sin(radians)
        let n = -point.y * (cos(radians) - 1) - point.x * sin(radians)
        
        let pointsMatrix = Matrix<CGFloat>(rows: points)
        let translateMatrix = Matrix<CGFloat>(rows: [
            [cos(radians), sin(radians), 0],
            [-sin(radians), cos(radians), 0],
            [m, n, 1]
        ])
        
        path.lines = pointsMatrix.matrixMultiply(by: translateMatrix).mapRows { row in
            return CGPoint(x: row[0], y: row[1])
            
        }.chunked(into: 2).map { points in
            return Line(start: points[0], end: points[1])
        }
    }
}

struct Line2D {
    let start: CGPoint
    let end: CGPoint
}

struct Path2D {
    var points: [CGPoint]
    
    var start: CGPoint? {
        return points.first
    }
    
    var end: CGPoint? {
        return points.last
    }
    
    var lines: [Line2D] {
        guard points.count > 1 else {
            return []
        }
        
        var result: [Line2D] = []
        
        var cursorPoint = points[0]
        
        for i in 1 ..< points.count {
            let line = Line2D(start: cursorPoint, end: points[i])
            result.append(line)
            
            cursorPoint = points[i]
        }
        
        return result
    }
    
    init(points: [CGPoint] = []) {
        self.points = points
    }
    
    mutating func append(pathes: [Path2D]) {
        pathes.forEach { append(path: $0) }
    }
    
    mutating func append(path: Path2D) {
        if let end = end, let start = path.start, end == start {
            self.points.append(contentsOf: path.points.dropFirst())
        } else {
            self.points.append(contentsOf: path.points)
        }
    }
    
    mutating func append(point: CGPoint) {
        self.points.append(point)
    }
    
    mutating func append(points: [CGPoint]) {
        if let end = end, let start = points.first, end == start {
            self.points.append(contentsOf: points.dropFirst())
        } else {
            self.points.append(contentsOf: points)
        }
    }
 
    mutating func reverse() {
        self.points.reverse()
    }
}

protocol Shape2D {
    var pathes: [Path2D] { get }
}

extension Shape2D {
    var convertable: ConvertableShape2D {
        return ConvertableShape2D(shape: self)
    }
}

extension Array where Element == Shape2D {
    var convertable: ConvertableShape2D {
        return ConvertableShape2D(pathes: flatMap { $0.pathes })
    }
}

struct ConvertableShape2D: Shape2D {

    var pathes: [Path2D]
    
    init(pathes: [Path2D] = []) {
        self.pathes = pathes
    }
    
    init(shape: Shape2D) {
        self.pathes = shape.pathes
    }
    
    mutating func append(path: Path2D) {
        pathes.append(path)
    }
    
    mutating func append(contentsOf pathes: [Path2D]) {
        pathes.forEach { self.pathes.append($0) }
    }
    
    func map(_ transform: (CGPoint) -> CGPoint) -> ConvertableShape2D {
        var mappedShape = ConvertableShape2D()
        
        for path in pathes {
            
            var mappedPath = Path2D()
            
            for point in path.points {
                
                let mappedPoint = transform(point)
                mappedPath.append(point: mappedPoint)
            }
            
            mappedShape.append(path: mappedPath)
        }
        
        return mappedShape
    }
    
    func map(_ transform: (Path2D) -> Path2D) -> ConvertableShape2D {
        
        var mappedShape = ConvertableShape2D()
        
        for path in pathes {
            mappedShape.append(path: transform(path))
        }
        
        return mappedShape
    }
}


final class ShapeTransformer2D {
    
    private let pointTransformer2D = PointTransformer2D()
    
    // MARK: - State
    
    private var shape: ConvertableShape2D!
    
    // MARK: - Configuration
    
    init(shape: Shape2D? = nil) {
        self.shape = shape.map { ConvertableShape2D(shape: $0) }
    }
    
    func configure(shape: Shape2D) {
        self.shape = ConvertableShape2D(shape: shape)
    }
    
    // MARK: - Transforms
    
    func translate(by translatePoint: CGPoint) {
        
        self.shape = shape.map { path -> Path2D in
                        
            pointTransformer2D.configure(points: path.points)
            pointTransformer2D.translate(by: translatePoint)
            
            return Path2D(points: pointTransformer2D.build())
        }
    }
        
    func rotate(by angle: Angle, relativeTo point: CGPoint) {
        
        self.shape = shape.map { path -> Path2D in
                
            pointTransformer2D.configure(points: path.points)
            pointTransformer2D.rotate(by: angle, relativeTo: point)
            
            return Path2D(points: pointTransformer2D.build())
        }
    }
    
    func scale(by value: CGFloat) {
        
        self.shape = shape.map { path -> Path2D in
            
            pointTransformer2D.configure(points: path.points)
            pointTransformer2D.scale(by: value)
            
            return Path2D(points: pointTransformer2D.build())
        }
    }
    
    func affineTransformation(basises: [CGPoint]) {
        assert(basises.count == 3)
        
        self.shape = shape.map { path -> Path2D in
            
            pointTransformer2D.configure(points: path.points)
            pointTransformer2D.affineTransformation(basises: basises)
            
            return Path2D(points: pointTransformer2D.build())
        }
    }
    
    func perspectiveTransformation(basises: [CGPoint], weights: [CGFloat]) {
        assert(basises.count == 3)
        assert(weights.count == 3)
        
        self.shape = shape.map { path -> Path2D in
            
            pointTransformer2D.configure(points: path.points)
            pointTransformer2D.perspectiveTransformation(basises: basises, weights: weights)
            
            return Path2D(points: pointTransformer2D.build())
        }
    }
    
    // MARK: - Build
    
    func build() -> ConvertableShape2D {
        return shape
    }
    
}

final class PointTransformer2D {
    
    // MARK: - State
    
    var uniformedPointsMatrix: Matrix<CGFloat>
    
    // MARK: - Configuration
    
    init() {
        self.uniformedPointsMatrix = Matrix<CGFloat>(size: 0)
    }
        
    init(points: [CGPoint]) {
        let rows = points.map { [$0.x, $0.y, 1] }
        self.uniformedPointsMatrix = Matrix<CGFloat>(rows: rows)
    }
    
    convenience init(point: CGPoint) {
        self.init(points: [point])
    }
    
    func configure(points: [CGPoint]) {
        let rows = points.map { [$0.x, $0.y, 1] }
        self.uniformedPointsMatrix = Matrix<CGFloat>(rows: rows)
    }
    
    func configure(point: CGPoint) {
        configure(points: [point])
    }
    
    // MARK: - Transforms
    
    func translate(by point: CGPoint) {
        
        let translateMatrix = Matrix<CGFloat>(rows: [
            [1, 0, 0],
            [0, 1, 0],
            [point.x, point.y, 1]
        ])
        
        uniformedPointsMatrix = uniformedPointsMatrix * translateMatrix
    }
    
    func rotate(by angle: Angle, relativeTo point: CGPoint) {
        
        let radians = angle.radians
        
        let m = -point.x * (cos(radians) - 1) + point.y * sin(radians)
        let n = -point.y * (cos(radians) - 1) - point.x * sin(radians)
        
        let rotateMatrix = Matrix<CGFloat>(rows: [
            [cos(radians), sin(radians), 0],
            [-sin(radians), cos(radians), 0],
            [m, n, 1]
        ])
        
        uniformedPointsMatrix = uniformedPointsMatrix * rotateMatrix
    }
    
    func scale(by value: CGFloat) {
        
        let rotateMatrix = Matrix<CGFloat>(rows: [
            [value, 0, 0],
            [0, value, 0],
            [0, 0, 1]
        ])
        
        uniformedPointsMatrix = uniformedPointsMatrix * rotateMatrix
    }
    
    func mirror(by axis: Axis) {
        
        let xMirrorAxisValue: CGFloat = axis == .x ? -1 : 1
        let yMirrorAxisValue: CGFloat = axis == .y ? -1 : 1
        
        let mirrorMatrix = Matrix<CGFloat>(rows: [
            [xMirrorAxisValue, 0, 0],
            [0, yMirrorAxisValue, 0],
            [0, 0, 1]
        ])
        
        uniformedPointsMatrix = uniformedPointsMatrix * mirrorMatrix
    }
    
    // MARK: Affine
    
    func affineTransformation(basises: [CGPoint]) {
        assert(basises.count == 3)
        
        let affineMatrix = Matrix<CGFloat>(rows: [
            [basises[0].x, basises[2].x, 0],
            [basises[0].y, basises[2].y, 0],
            [basises[1].x, basises[1].y, 1]
        ])
        
        uniformedPointsMatrix = uniformedPointsMatrix * affineMatrix
    }
    
    func perspectiveTransformation(basises: [CGPoint], weights: [CGFloat]) {
        assert(basises.count == 3)
        assert(weights.count == 3)
        
        // 1
        
//        let affineMatrix = Matrix<CGFloat>(rows: [
//            [basises[0].x * weights[0], basises[2].x * weights[0], weights[0]],
//            [basises[0].y * weights[2], basises[2].y * weights[2], weights[2]],
//            [basises[1].x * weights[1], basises[1].y * weights[1], weights[1]]
//        ])
//
//        uniformedPointsMatrix = uniformedPointsMatrix * affineMatrix
        
        
        // 2

//        let affineMatrix = Matrix<CGFloat>(rows: [
//            [basises[0].x * weights[0], basises[2].x * weights[2], basises[1].x * weights[1]],
//            [basises[0].y * weights[0], basises[2].y * weights[2], basises[1].y * weights[1]],
//            [weights[0], weights[2], weights[1]]
//        ])
//
//        uniformedPointsMatrix = uniformedPointsMatrix * affineMatrix
        
        // 3
        
        uniformedPointsMatrix = Matrix(rows: uniformedPointsMatrix.mapRows { row -> [CGFloat] in
            let xTop = (basises[1].x * weights[1]) + (basises[0].x * weights[0] * row[0]) + (basises[2].x * weights[2] * row[1])
            let xBottom = weights[1] + (weights[0] * row[0]) + (weights[2] * row[1])
            let x = xTop / xBottom

            let yTop = (basises[1].y * weights[1]) + (basises[0].y * weights[0] * row[0]) + (basises[2].y * weights[2] * row[1])
            let yBottom = weights[1] + (weights[0] * row[0]) + (weights[2] * row[1])
            let y = yTop / yBottom

            return [x, y, 1]
        })
    }
    
    // MARK: - Builder
    
    func build() -> [CGPoint] {
        return uniformedPointsMatrix.mapRows { convertToPoint(pointArray: $0) }
    }
    
    // MARK: - Helpers
    
    func convertToPoint(pointArray: [CGFloat]) -> CGPoint {
        return CGPoint(x: pointArray[0], y: pointArray[1])
    }
    
}
