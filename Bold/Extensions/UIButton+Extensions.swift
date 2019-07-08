//
//  UIButton+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func positionImage() {
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width/2 + 10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
    
}
