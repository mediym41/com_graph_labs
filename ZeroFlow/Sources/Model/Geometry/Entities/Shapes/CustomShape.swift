//
//  CustomShape.swift
//  ZeroFlow
//
//  Created by Mediym on 4/4/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

import UIKit

struct CustomShape: Shape2D {
    var pathes: [Path2D]
    
    init(pathes: [Path2D]) {
        self.pathes = pathes
    }
    
}
