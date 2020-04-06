//
//  Storyboard.swift
//  lab_1
//
//  Created by Mediym on 2/11/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

enum Storyboard: String {
    
    case zero = "ZeroFlow"
    case first = "FirstFlow"
    case second = "SecondFlow"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(name: String) -> T {
        return instance.instantiateViewController(withIdentifier: name) as! T
    }
    
}


extension UIViewController {
    
    static func instantiate<T: UIViewController>(from storyboard: Storyboard) -> T {
        let name = String(describing: T.self)
        
        return storyboard.viewController(name: name)
    }
    
}
