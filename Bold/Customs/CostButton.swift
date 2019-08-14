//
//  CostButton.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum CostType : Int {
    case five       = 0
    case ten        = 1
    case fifteen    = 2
    case twenty     = 3
    case twentyFive = 4
    
    var costValue : Float {
        switch self {
        case .five:
            return 5
        case .ten:
            return 10
        case .fifteen:
            return 15
        case .twenty:
            return 20
        case .twentyFive:
            return 25
        }
    }
}

@IBDesignable class CostButton: UIButton {
    
    var cost: CostType! {
        didSet {
            self.setTitle(NumberFormatter.stringForCurrency(cost!.costValue), for: .normal)
        }
    }
    
    @IBInspectable var costType : Int {
        get {
            return self.cost.rawValue
        }
        set(newCost) {
            self.cost = CostType(rawValue: newCost) ?? .five
        }
    }
}
