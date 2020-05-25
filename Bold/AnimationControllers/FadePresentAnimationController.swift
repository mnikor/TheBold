//
//  FadePresentAnimationController.swift
//  Bold
//
//  Created by Admin on 9/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class FadePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
//        let finalFrame = transitionContext.finalFrame(for: toVC)
        let finalFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let frame = containerView.bounds
        
        toVC.view.frame = finalFrame
        toVC.view.layoutIfNeeded()
        toVC.view.alpha = 0
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1
            fromVC.view.alpha = 0
            fromVC.view.frame = frame
            
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        guard let vc = toVC as? OnboardViewController else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            vc.animateContent()
        }
    }
    
}
