//
//  UITextField+Extensions.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

extension UITextField {
    
    var intValue: Int? {
        guard let text = text else {
            return nil
        }
        
        return Int(text)
    }
    
    var cgFloatValue: CGFloat? {
        get {
            return text.flatMap { Double($0) }.map { CGFloat($0) }
        }
        set {
            text = newValue.map { Double($0) }.map { String($0) } ?? ""
        }
    }
    
}
