//
//  FirstFlowAfifneTransformInputViewController.swift
//  ZeroFlow
//
//  Created by Mediym on 2/27/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

protocol FirstFlowAfifneTransformInputViewControllerDelegate: class {
    
    func applyAffineTransformData(points: [CGPoint])
    
}

class FirstFlowAfifneTransformInputViewController: UIViewController {

    @IBOutlet weak var xAxisFirstPointTextField: UITextField!
    @IBOutlet weak var yAxisFirstPointTextField: UITextField!
    
    @IBOutlet weak var xAxisSecondPointTextField: UITextField!
    @IBOutlet weak var yAxisSecondPointTextField: UITextField!
    
    @IBOutlet weak var xAxisThirdPointTextField: UITextField!
    @IBOutlet weak var yAxisThirdPointTextField: UITextField!
    
    weak var delegate: FirstFlowAfifneTransformInputViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGestureRecognizers()
    }
    
    func configureGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func applyButtonPresses(_ sender: Any) {
        guard let xAxisFirstPointValue = xAxisFirstPointTextField.cgFloatValue,
            let yAxisFirstPointValue = yAxisFirstPointTextField.cgFloatValue,
            let xAxisSecondPointValue = xAxisSecondPointTextField.cgFloatValue,
            let yAxisSecondPointValue = yAxisSecondPointTextField.cgFloatValue,
            let xAxisThirdPointValue = xAxisThirdPointTextField.cgFloatValue,
            let yAxisThirdPointValue = yAxisThirdPointTextField.cgFloatValue
        else {
            return
        }
        
        delegate?.applyAffineTransformData(points: [
            CGPoint(x: xAxisFirstPointValue, y: yAxisFirstPointValue),
            CGPoint(x: xAxisSecondPointValue, y: yAxisSecondPointValue),
            CGPoint(x: xAxisThirdPointValue, y: yAxisThirdPointValue)
        ])
        
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonPresses(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension FirstFlowAfifneTransformInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
