//
//  FirstFlowIsomorphyViewController.swift
//  ZeroFlow
//
//  Created by Mediym on 2/24/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

class Throttler {

    private var previousRun: Date?
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval

    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    func throttle(_ block: @escaping () -> Void) {
        
        let shouldHandle = previousRun.map { -$0.timeIntervalSinceNow > self.minimumDelay } ?? true
        
        guard shouldHandle else {
            return
        }
        
        previousRun = Date()

        queue.sync(execute: block)
    }
}

final class FirstFlowIsomorphyViewController: UIViewController {
    
    @IBOutlet weak var coordinatesSystemView: CartesianCoordinateSystemView!
    
    let shapeTransformer = ShapeTransformer2D()
    let pointTransformer = PointTransformer2D()
    
    var gridShape: ConvertableShape2D!
    var detailShape: ConvertableShape2D!
    var markersLayer: ConvertableShape2D!
    
    // MARK: State
    
    private lazy var detailZeroParameters: DetailZeroShape2D.Parameters = {
       
        return DetailZeroShape2D.Parameters(r1: 50,
                                            r2: 40,
                                            h1: 100,
                                            h2: 200,
                                            h3: 150,
                                            h4: 100,
                                            w1: 120,
                                            w2: 60)
    }()
    
    private var currentRelativePoint: CGPoint?
        
    private var mathQueue = DispatchQueue(label: "com.medium.math.isomorphy", qos: .userInteractive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailShape = BezierShape.ship.convertable
        gridShape = GridShape2D(division: 10,
                                size: CGSize(width: 500,
                                             height: 1000)).convertable
        markersLayer = ConvertableShape2D()
            
        redrawGrid()
        redrawShape()
    }
    
    // MARK: - Configuration
    
    private func configureGestureRecognizers() {
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panPiece))
        coordinatesSystemView.addGestureRecognizer(panRecognizer)
        
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece))
        coordinatesSystemView.addGestureRecognizer(rotateRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        coordinatesSystemView.addGestureRecognizer(doubleTapRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchPiece))
        coordinatesSystemView.addGestureRecognizer(pinchRecognizer)
    }
        
    func redrawShape() {
        coordinatesSystemView.configure(shape: detailShape)
    }
    
    func redrawGrid() {
        coordinatesSystemView.configure(grid: gridShape)
    }
    
    func redrawMarkers() {
        coordinatesSystemView.configure(markers: [markersLayer])
    }
    
    @objc func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let point = gestureRecognizer.translation(in: coordinatesSystemView)
        let translatedPoint = CGPoint(x: point.x, y: -point.y)
        
        gestureRecognizer.setTranslation(.zero, in: coordinatesSystemView)
        
        mathQueue.async {
            self.shapeTransformer.configure(shape: self.detailShape)
            self.shapeTransformer.translate(by: translatedPoint)
            self.detailShape = self.shapeTransformer.build()
            
            DispatchQueue.main.async {
                self.redrawShape()
            }
        }
    }
    
    @objc func rotatePiece(_ gestureRecognizer: UIRotationGestureRecognizer) {
        
        guard let relativePoint = currentRelativePoint else {
            return
        }
        
        let angle: Angle = .radians(-gestureRecognizer.rotation)
        
        gestureRecognizer.rotation = 0
        
        mathQueue.async {
            self.shapeTransformer.configure(shape: self.detailShape)
            self.shapeTransformer.rotate(by: angle, relativeTo: relativePoint)
            self.detailShape = self.shapeTransformer.build()
            
            DispatchQueue.main.async {
                self.redrawShape()
            }
        }
    }
    
    @objc func pinchPiece(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        let scale = gestureRecognizer.scale
        gestureRecognizer.scale = 1.0
        
        mathQueue.async {
            self.shapeTransformer.configure(shape: self.detailShape)
            self.shapeTransformer.scale(by: scale)
            self.detailShape = self.shapeTransformer.build()
            
            self.shapeTransformer.configure(shape: self.gridShape)
            self.shapeTransformer.scale(by: scale)
            self.gridShape = self.shapeTransformer.build()
            
            self.shapeTransformer.configure(shape: self.markersLayer)
            self.shapeTransformer.scale(by: scale)
            self.markersLayer = self.shapeTransformer.build()
            
            self.currentRelativePoint = self.currentRelativePoint.map { point in
                self.pointTransformer.configure(point: point)
                self.pointTransformer.scale(by: scale)
                
                return self.pointTransformer.build()[0]
            }
            
            DispatchQueue.main.async {
                self.redrawShape()
                self.redrawGrid()
                self.redrawMarkers()
            }
        }
    }
    
    @objc func doubleTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point2 = gestureRecognizer.location(in: coordinatesSystemView)
        let point = CGPoint(x: point2.x - coordinatesSystemView.bounds.center.x,
                            y: coordinatesSystemView.bounds.center.y - point2.y)
        
        self.currentRelativePoint = point
        
        markersLayer = ArcShape2D(center: point, radius: 1).convertable
        
        redrawMarkers()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let parametersVC: ParametersViewController = .instantiate(from: .first)
        parametersVC.configure(parameters: detailZeroParameters)
        parametersVC.delegate = self
        
        navigationController?.pushViewController(parametersVC, animated: true)
    }

}

extension FirstFlowIsomorphyViewController: ParametersViewControllerDelegate {
    
    func update(parameters: DetailZeroShape2D.Parameters) {
        self.detailZeroParameters = parameters
    }
    
}

