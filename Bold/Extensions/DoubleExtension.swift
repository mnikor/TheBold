//
//  DoubleExtension.swift
//  Bold
//
//  Created by Denis Grishchenko on 8/12/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

extension Double {
    
    func removeZerosFromEnd() -> String {
        let number = NSNumber(floatLiteral: self)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number)!
    }
    
}
