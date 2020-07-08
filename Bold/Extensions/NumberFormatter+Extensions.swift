//
//  Formatter+Extension.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    class func stringForCurrency(_ currency: Float) -> String{
        //guard let currency = currency else { return String() }
/*        let currencyFormatter = NumberFormatter()
        let number = NSNumber(value: currency)
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 0
        return currencyFormatter.string(from: number) ?? String() */
        let stake = Int(currency)
        return "$\(stake)"
    }
    
}
