//
//  Array+Extension.swift
//  ZeroFlow
//
//  Created by Mediym on 2/24/20.
//  Copyright © 2020 NSMedium. All rights reserved.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
