//
//  UIButton+Extension.swift
//  BuduSushiDev
//
//  Created by branderstudio on 9/4/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }
    
    func setFont(_ font: UIFont) {
        titleLabel?.font = font
    }
    
    func setTextColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
    
    func addAction(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        addTarget(target, action: action, for: event)
    }
}
