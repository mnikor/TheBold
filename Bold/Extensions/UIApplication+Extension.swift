//
//  UIApplication+Extension.swift
//  Bold
//
//  Created by Admin on 30.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var topViewController: UIViewController? {
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return topViewController
        }
        
        return nil
    }
    
    public static func setRootView(_ viewController: UIViewController,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
            
            let previousViewController = window.rootViewController
            let subviews = window.subviews
            
            if #available(iOS 13.0, *) {
                // In iOS 13 we don't want to remove the transition view as it'll create a blank screen
            } else {
                // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
                if let transitionViewClass = NSClassFromString("UITransitionView") {
                    for subview in subviews where subview.isKind(of: transitionViewClass) {
                        subview.removeFromSuperview()
                    }
                }
            }
            if let previousViewController = previousViewController {
                // Allow the view controller to be deallocated
                previousViewController.dismiss(animated: false) {
                    // Remove the root view in case its still showing
                    previousViewController.view.removeFromSuperview()
                }
            }
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
