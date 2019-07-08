//
//  RoundedButton.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
        
//        if imageView != nil {
//            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width/2 + 10)
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
//        }
    }
}

//@IBDesignable class CombinationButton: UIButton {
//    
//    var typeState: ButtonCombinationType = .none
//    
//    @IBInspectable var typeButton: Int {
//        get {
//            return self.typeState.rawValue
//        }
//        set (newValue) {
//            self.typeState = ButtonCombinationType(rawValue: newValue) ?? .none
//        }
//    }
//}
