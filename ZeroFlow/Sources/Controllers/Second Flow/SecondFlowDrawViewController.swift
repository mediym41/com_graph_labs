//
//  SecondFlowDrawViewController.swift
//  ZeroFlow
//
//  Created by Mediym on 4/4/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

enum SelectedPointIndex: Int {
    case zero
    case one
    case two
    case three
}

enum ShapeType {
    case ship
    case fish
    
    var imageName: String {
        switch self {
        case .ship:
            return "sketch_one"
            
        case .fish:
            return "sketch_two"
        }
    }
    
    var shape: BezierShape {
        switch self {
        case .ship:
            return .ship
            
        case .fish:
            return .fish
        }
    }
    
    mutating func toggle() {
        switch self {
        case .ship:
            self = .fish
            
        case .fish:
            self = .ship
        }
    }
    
}

final class SecondFlowDrawViewController: UIViewController {
    
    @IBOutlet weak var patternImageView: UIImageView!
    @IBOutlet weak var imageSwitchButton: UIButton!
    @IBOutlet weak var controlsSwitchButton: UIButton!
    
    @IBOutlet weak var canvasView: CanvasView!
    private var panGesture: UIPanGestureRecognizer!
    
    let pointTransformer = PointTransformer2D()
    var cartesianConverter: CoreGraphicsToCartesianSystemCoordinatesConverter!
    
    var selectedPointIndex: SelectedPointIndex?
    var selectedBezierPath: BezierPath?
        
    var bezierShape: BezierShape!
    
    var shouldShowImage = false
    var shouldShowControlPoints = false
    
    var patternImageName: String {
        return currentShapeType.imageName
    }
    
    var currentShapeType: ShapeType = .ship
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureControls()
        configureGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        bezierShape = currentShapeType.shape
        cartesianConverter = CoreGraphicsToCartesianSystemCoordinatesConverter(rect: canvasView.bounds)
        canvasView.configure(shape: bezierShape)
    }
    
    private func configureControls() {
        patternImageView.image = shouldShowImage ? UIImage(named: patternImageName) : nil
        canvasView.shouldDrawSkeleton = shouldShowControlPoints
        var title = shouldShowImage ? "Hide image" : "Show Image"
        imageSwitchButton.setTitle(title, for: .normal)
        title = shouldShowControlPoints ? "Hide control points" : "Show control points"
        controlsSwitchButton.setTitle(title, for: .normal)
    }
    
    func redraw() {
        canvasView.configure(shape: bezierShape)
    }
    
    private func configureGestureRecognizers() {
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panPiece))
        canvasView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
                
        switch gestureRecognizer.state {
        case .began:
            
            let touchPoint = cartesianConverter.convert(point: gestureRecognizer.location(in: canvasView))
            
            var nearestDistance: CGFloat = .greatestFiniteMagnitude
            var nearestPoint: CGPoint = .zero
            var nearestBezier: BezierPath?
            
            for bezierPath in bezierShape.bezierPathes {
                
                for point in bezierPath.points {
                    
                    let length = point.length(to: touchPoint)
                    
                    if length < nearestDistance {
                        nearestDistance = length
                        nearestPoint = point
                        nearestBezier = bezierPath
                    }
                }
            }
            
            if nearestDistance > 50 { // not valid
                gestureRecognizer.cancel()
                selectedBezierPath = nil
                selectedPointIndex = nil
                
            } else {
                selectedBezierPath = nearestBezier
                
                if let index = nearestBezier?.points.firstIndex(where: { nearestPoint == $0 }) {
                    selectedPointIndex = SelectedPointIndex(rawValue: index)
                }
            }

        case .changed:
            guard let selectedIndex = selectedPointIndex, let selectedBezierPath = selectedBezierPath else {
                print("Changed error")
                return
            }
            
            let point = gestureRecognizer.translation(in: canvasView)
            let translatedPoint = CGPoint(x: point.x, y: -point.y)

            gestureRecognizer.setTranslation(.zero, in: canvasView)
            
            let selectedPoint = selectedBezierPath.points[selectedIndex.rawValue]
            
            pointTransformer.configure(point: selectedPoint)
            pointTransformer.translate(by: translatedPoint)
            let result = pointTransformer.build()
            
            selectedBezierPath.update(selectedPoint: selectedIndex, point: result[0])
            
            redraw()
            
        case .ended:
            selectedBezierPath = nil
            selectedPointIndex = nil
        case .cancelled:
            
            selectedBezierPath = nil
            selectedPointIndex = nil
            
        default:
            break
        }

    }
    
    @IBAction func showImageButtonPressed(_ sender: Any) {
        shouldShowImage.toggle()
        patternImageView.image = shouldShowImage ? UIImage(named: patternImageName) : nil
        let title = shouldShowImage ? "Hide image" : "Show Image"
        imageSwitchButton.setTitle(title, for: .normal)
        
    }
    
    @IBAction func showControlsButtonPressed(_ sender: Any) {
        shouldShowControlPoints.toggle()
        canvasView.shouldDrawSkeleton = shouldShowControlPoints
        redraw()
        let title = shouldShowControlPoints ? "Hide control points" : "Show control points"
        controlsSwitchButton.setTitle(title, for: .normal)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let bezierPath = BezierPath(p0: CGPoint(x: -150, y: -250), p1: CGPoint(x: -150, y: -230), p2: CGPoint(x: -130, y: -230), p3: CGPoint(x: -130, y: -250))
        
        bezierShape.bezierPathes.append(bezierPath)
        redraw()
    }
    
    @IBAction func printButtonPressed(_ sender: Any) {
        print("---- Code ----")
        print(bezierShape.code)
    }
    
    @IBAction func animateButtonPressed(_ sender: Any) {
        
        currentShapeType.toggle()
        
        let shapeTransition = ShapeTransition()
        let snapshots = shapeTransition.makeTransitionShapes(from: bezierShape, to: currentShapeType.shape)

        let queue: DispatchQueue = .main
        
        for i in 0 ..< snapshots.count {
            let offset = Double(i) * (1.0 / 100.0)
            
            let dispathTime: DispatchTimeInterval = .milliseconds(Int(offset * 1000))
            
            queue.asyncAfter(deadline: .now() + dispathTime) {
                self.bezierShape = snapshots[i]
                self.redraw()
            }
        }
        
    }
    
}


extension UIGestureRecognizer {
    
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
    
}

class ShapeTransition {
    
    var step = 1.0 / 60.0
    
    func makeTransitionShapes(from shapeFrom: BezierShape, to shapeTo: BezierShape) -> [BezierShape] {
        
        assert(shapeFrom.bezierPathes.count == shapeTo.bezierPathes.count)
        let bezierPathesCount = shapeFrom.bezierPathes.count
        
        
        var result: [BezierShape] = []
        
        for t in stride(from: 0, through: 1, by: step) {
            
            var bezierShape = BezierShape(bezierPathes: [])
            let t = CGFloat(t)
            
            for i in 0 ..< bezierPathesCount {
                
                let bezierPath = BezierPath(p0: convert(from: shapeFrom.bezierPathes[i].points[0],
                                                        to: shapeTo.bezierPathes[i].points[0],
                                                        progress: t),
                                            p1: convert(from: shapeFrom.bezierPathes[i].points[1],
                                                        to: shapeTo.bezierPathes[i].points[1],
                                                        progress: t),
                                            p2: convert(from: shapeFrom.bezierPathes[i].points[2],
                                                        to: shapeTo.bezierPathes[i].points[2],
                                                        progress: t),
                                            p3: convert(from: shapeFrom.bezierPathes[i].points[3],
                                                        to: shapeTo.bezierPathes[i].points[3],
                                                        progress: t))
                bezierShape.bezierPathes.append(bezierPath)
            }
            
            result.append(bezierShape)
        }
        
        return result
    }
    
    func convert(from pointFrom: CGPoint, to pointTo: CGPoint, progress t: CGFloat) -> CGPoint {
        return CGPoint(x: pointFrom.x * (1 - t) + pointTo.x * t,
                       y: pointFrom.y * (1 - t) + pointTo.y * t)
    }
}
