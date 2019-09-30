//
//  BlurTransitionController.swift
//  BuduSushi
//
//  Created by branderstudio on 12/20/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class BlurTransitionController: CustomPresentViewController, BlurTransitionViewDelegate {
    
    // MARK: - Life cycle
    
    @available(*, unavailable, message: "user init(blurTransitionView: BlurTransitionView) instead")
    override init(view: (UIView & AnimationTransitionView)) {
        super.init(view: view)
    }
    
    init(blurTransitionView: (UIView & BlurTransition)) {
        super.init(view: blurTransitionView)
        blurTransitionView.blurDelegate = self
    }
    
    // MARK: - BlurTransitionViewDelegate
    
    func didTapOnBlurView(_ view: BlurTransitionView) {
        closeSelf()
    }
    
    func closeSelf(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: {
            completion?()
        })
    }
}
