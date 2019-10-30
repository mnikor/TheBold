//
//  UIApplication+Extension.swift
//  Bold
//
//  Created by Admin on 30.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

extension UIApplication {
    
    public static func setRootView(_ viewController: UIViewController,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            return
        }
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: duration, options: .transitionFlipFromRight, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
