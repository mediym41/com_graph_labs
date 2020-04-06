//
//  ParametersViewController.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

protocol ParametersViewControllerDelegate: class {
    
    func update(parameters: DetailZeroShape2D.Parameters)
    
}

class ParametersViewController: UIViewController {
    
    @IBOutlet weak var r1TextField: UITextField!
    @IBOutlet weak var r2TextField: UITextField!
    
    @IBOutlet weak var h1TextField: UITextField!
    @IBOutlet weak var h2TextField: UITextField!
    @IBOutlet weak var h3TextField: UITextField!
    @IBOutlet weak var h4TextField: UITextField!
    
    @IBOutlet weak var w1TextField: UITextField!
    @IBOutlet weak var w2TextField: UITextField!

    private var initialParameters: DetailZeroShape2D.Parameters?
    
    weak var delegate: ParametersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGestureRecognizers()
        configureInitialState()
    }
    
    public func configure(parameters: DetailZeroShape2D.Parameters) {
        self.initialParameters = parameters
    }
    
    private func configureInitialState() {
        guard let parameters = initialParameters else {
            return
        }
        
        r1TextField.cgFloatValue = parameters.r1
        r2TextField.cgFloatValue = parameters.r2
        h1TextField.cgFloatValue = parameters.h1
        h2TextField.cgFloatValue = parameters.h2
        h3TextField.cgFloatValue = parameters.h3
        h4TextField.cgFloatValue = parameters.h4
        w1TextField.cgFloatValue = parameters.w1
        w2TextField.cgFloatValue = parameters.w2
    }
    
    private func configureGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
        
        present(alertVC, animated: true)
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        guard
            let r1 = r1TextField.cgFloatValue,
            let r2 = r2TextField.cgFloatValue,
            let h1 = h1TextField.cgFloatValue,
            let h2 = h2TextField.cgFloatValue,
            let h3 = h3TextField.cgFloatValue,
            let h4 = h4TextField.cgFloatValue,
            let w1 = w1TextField.cgFloatValue,
            let w2 = w2TextField.cgFloatValue
        else {
            showError(title: "Ошибка", message: "Введены не все данные")
            return
        }
        
        let parameters = DetailZeroShape2D.Parameters(r1: r1, r2: r2, h1: h1, h2: h2, h3: h3, h4: h4, w1: w1, w2: w2)
        
        delegate?.update(parameters: parameters)
        
        navigationController?.popViewController(animated: true)
    }

}

extension ParametersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
