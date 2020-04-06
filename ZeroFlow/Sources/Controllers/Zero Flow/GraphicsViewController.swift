//
//  ViewController.swift
//  lab_1
//
//  Created by Mediym on 2/5/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController {

    @IBOutlet weak var coordinatesSystemView: CartesianCoordinateSystemView!
    
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
    
    var shouldDrawMarkers: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let shape = DetailZeroShape2D(center: .zero, params: detailZeroParameters)
        coordinatesSystemView.configure(shape: shape)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let parametersVC: ParametersViewController = .instantiate(from: .zero)
        parametersVC.configure(parameters: detailZeroParameters)
        parametersVC.delegate = self
        
        navigationController?.pushViewController(parametersVC, animated: true)
    }


}

extension GraphicsViewController: ParametersViewControllerDelegate {
    
    func update(parameters: DetailZeroShape2D.Parameters) {
        self.detailZeroParameters = parameters
    }
    
}

// r1 centered
// r2 side

// h1 r1 center to r2
// h2

// w1
// w2
