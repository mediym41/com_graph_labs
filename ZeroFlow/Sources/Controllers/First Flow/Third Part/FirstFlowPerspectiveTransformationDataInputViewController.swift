//
//  FirstFlowPerspectiveTransformationDataInputViewController.swift
//  ZeroFlow
//
//  Created by Mediym on 2/27/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

protocol FirstFlowPerspectiveTransformationDataInputViewControllerDelegate: class {
    
    func applyPerspectiveTransformData(points: [CGPoint], weights: [CGFloat])
    
}

class FirstFlowPerspectiveTransformationDataInputViewController: UIViewController {

    @IBOutlet weak var xAxisFirstPointTextField: UITextField!
    @IBOutlet weak var yAxisFirstPointTextField: UITextField!
    @IBOutlet weak var weightFirstPointTextField: UITextField!
    
    @IBOutlet weak var xAxisSecondPointTextField: UITextField!
    @IBOutlet weak var yAxisSecondPointTextField: UITextField!
    @IBOutlet weak var weightSecondPointTextField: UITextField!
    
    @IBOutlet weak var xAxisThirdPointTextField: UITextField!
    @IBOutlet weak var yAxisThirdPointTextField: UITextField!
    @IBOutlet weak var weightThirdPointTextField: UITextField!
    
    weak var delegate: FirstFlowPerspectiveTransformationDataInputViewControllerDelegate!
    
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
            let weightFirstPointValue = weightFirstPointTextField.cgFloatValue,
            let xAxisSecondPointValue = xAxisSecondPointTextField.cgFloatValue,
            let yAxisSecondPointValue = yAxisSecondPointTextField.cgFloatValue,
            let weightSecondPointValue = weightSecondPointTextField.cgFloatValue,
            let xAxisThirdPointValue = xAxisThirdPointTextField.cgFloatValue,
            let yAxisThirdPointValue = yAxisThirdPointTextField.cgFloatValue,
            let weightThirdPointValue = weightThirdPointTextField.cgFloatValue
        else {
            return
        }
        
        delegate?.applyPerspectiveTransformData(points: [
            CGPoint(x: xAxisFirstPointValue, y: yAxisFirstPointValue),
            CGPoint(x: xAxisSecondPointValue, y: yAxisSecondPointValue),
            CGPoint(x: xAxisThirdPointValue, y: yAxisThirdPointValue)
        ], weights: [
            weightFirstPointValue,
            weightSecondPointValue,
            weightThirdPointValue
        ])
        
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonPresses(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension FirstFlowPerspectiveTransformationDataInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

