//
//  PresentAnimationController.swift
//  BuduSushiDev
//
//  Created by user on 10/10/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    static let shared = PresentAnimationController()
    
    private enum Constants {
        static let transitionDuration: TimeInterval = 0.15
    }
    var duration: TimeInterval = Constants.transitionDuration
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view as? (UIView & AnimationTransitionView) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            animations: toView.applyPresentAnimationChanges) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
