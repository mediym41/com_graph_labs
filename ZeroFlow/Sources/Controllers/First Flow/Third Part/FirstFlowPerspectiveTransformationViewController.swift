//
//  FirstFlowPerspectiveTransformationViewController.swift
//  ZeroFlow
//
//  Created by Mediym on 2/27/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

final class FirstFlowPerspectiveTransformationViewController: UIViewController {
    
    @IBOutlet weak var coordinatesSystemView: CartesianCoordinateSystemView!
    @IBOutlet weak var transformButton: UIButton!
    
    let shapeTransformer = ShapeTransformer2D()
    let pointTransformer = PointTransformer2D()
    
    var gridShape: ConvertableShape2D!
    var detailShape: ConvertableShape2D!
    
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
        
    private var basisPoints: [CGPoint] = []
        
    private var mathQueue = DispatchQueue(label: "com.medium.math.perspective", qos: .userInteractive)
    
    var isTransformApplied: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        drawInitialState()
    }
    
    // MARK: - Configuration
    
    private func drawInitialState() {
        detailShape = BezierShape.ship.convertable
        gridShape = GridShape2D(division: 100,
                                size: CGSize(width: 800,
                                             height: 1200)).convertable
            
        redrawGrid()
        redrawShape()
    }
    
    private func configureGestureRecognizers() {
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panPiece))
        coordinatesSystemView.addGestureRecognizer(panRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchPiece))
        coordinatesSystemView.addGestureRecognizer(pinchRecognizer)
    }
        
    func redrawShape() {
        coordinatesSystemView.configure(shape: detailShape)
    }
    
    func redrawGrid() {
        coordinatesSystemView.configure(grid: gridShape)
    }
    
    @objc func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let point = gestureRecognizer.translation(in: coordinatesSystemView)
        let translatedPoint = CGPoint(x: point.x, y: -point.y)
        
        gestureRecognizer.setTranslation(.zero, in: coordinatesSystemView)
        
        mathQueue.async {
            self.shapeTransformer.configure(shape: self.detailShape)
            self.shapeTransformer.translate(by: translatedPoint)
            self.detailShape = self.shapeTransformer.build()
            
            self.shapeTransformer.configure(shape: self.gridShape)
            self.shapeTransformer.translate(by: translatedPoint)
            self.gridShape = self.shapeTransformer.build()
            
            DispatchQueue.main.async {
                self.redrawShape()
                self.redrawGrid()
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
            
            DispatchQueue.main.async {
                self.redrawShape()
                self.redrawGrid()
            }
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let parametersVC: ParametersViewController = .instantiate(from: .first)
        parametersVC.configure(parameters: detailZeroParameters)
        parametersVC.delegate = self
        
        navigationController?.pushViewController(parametersVC, animated: true)
    }
    
    @IBAction func transformButtonPressed(_ sender: UIButton) {

        if isTransformApplied {
            drawInitialState()
            transformButton.setTitle("Perspective transform", for: .normal)
            
            isTransformApplied = false
            
        } else {
            let perspectiveDataInputVC: FirstFlowPerspectiveTransformationDataInputViewController = .instantiate(from: .first)
            perspectiveDataInputVC.delegate = self
            
            present(perspectiveDataInputVC, animated: true)
        }
    }

}

extension FirstFlowPerspectiveTransformationViewController: ParametersViewControllerDelegate {
    
    func update(parameters: DetailZeroShape2D.Parameters) {
        self.detailZeroParameters = parameters
    }
    
}

extension FirstFlowPerspectiveTransformationViewController: FirstFlowPerspectiveTransformationDataInputViewControllerDelegate {
    
    func applyPerspectiveTransformData(points: [CGPoint], weights: [CGFloat]) {
        isTransformApplied = true
        
        transformButton.setTitle("Reset", for: .normal)
           
        mathQueue.async {
            self.shapeTransformer.configure(shape: self.gridShape)
            self.shapeTransformer.perspectiveTransformation(basises: points, weights: weights)
            self.gridShape = self.shapeTransformer.build()
            
            self.shapeTransformer.configure(shape: self.detailShape)
            self.shapeTransformer.perspectiveTransformation(basises: points, weights: weights)
            self.detailShape = self.shapeTransformer.build()
            
            DispatchQueue.main.async {
                self.redrawShape()
                self.redrawGrid()
            }
        }
    }

}
