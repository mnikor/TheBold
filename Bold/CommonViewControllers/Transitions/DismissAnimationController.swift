//
//  DismissAnimationController.swift
//  BuduSushiDev
//
//  Created by user on 10/10/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    static let shared = DismissAnimationController()
    
    private enum Constants {
        static let transitionDuration: TimeInterval = 0.15
    }
    var duration: TimeInterval = Constants.transitionDuration
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view as? (UIView & AnimationTransitionView) else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            animations: fromView.applyDismissAnimationChanges) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
