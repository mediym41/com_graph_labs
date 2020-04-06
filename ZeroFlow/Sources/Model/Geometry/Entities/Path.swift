//
//  Path.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

public struct Path {
    
    var lines: [Line]
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    init(lines: [Line] = [], startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        self.lines = lines
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var uiBezierPath: UIBezierPath {
        return UIBezierPath(lines: lines)
    }
    
    var mirroredByAxisX: Path {
        let convert = { (point: CGPoint) in
            return CGPoint(x: -point.x, y: point.y)
        }
        
        let mirroredStartPoint = startPoint.map { convert($0) }
        let mirroredEndPoint = endPoint.map { convert($0) }
        let mirroredLines = lines.map { line -> Line in
            let mirroredStart = convert(line.start)
            let mirroredEnd = convert(line.end)
            
            return Line(start: mirroredStart, end: mirroredEnd)
        }
        
        return Path(lines: mirroredLines, startPoint: mirroredStartPoint, endPoint: mirroredEndPoint)
    }
    
    mutating func set(path: Path) {
        self.lines = path.lines
        self.startPoint = path.startPoint
        self.endPoint = path.endPoint
    }
    
    mutating func addLine(to point: CGPoint) {
        guard let endPoint = endPoint else {
            fatalError("Path has no end point")
        }
        
        let line = Line(start: endPoint, end: point)
        self.lines.append(line)
    }
    
    mutating func add(path: Path) {
        self.startPoint = nil
        self.endPoint = nil
        
        self.lines.append(contentsOf: path.lines)
    }
    
    mutating func connect(path: Path) {
        guard let endPoint = endPoint, let startPoint = path.startPoint else {
            fatalError("Pathes have no start or end points")
        }
                
        if endPoint != startPoint {
            let connectionLine = Line(start: endPoint, end: startPoint)
            self.lines.append(connectionLine)
        }
        
        self.endPoint = path.endPoint
        
        
        self.lines.append(contentsOf: path.lines)
    }
    
    mutating func close() {
        guard let startPoint = startPoint, let endPoint = endPoint else {
            print("Error: Can't close path, path have no start or end points")
            return
        }
        
        let connectionLine = Line(start: startPoint, end: endPoint)
        self.lines.append(connectionLine)
    }
    

    
}
