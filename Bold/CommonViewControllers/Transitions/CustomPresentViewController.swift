//
//  CustomPresentViewController.swift
//  BuduSushiDev
//
//  Created by user on 10/10/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class CustomPresentViewController: UIViewController {

    fileprivate let transitionController = AnimationTransitionController()
    
    // MARK: - Life Cycle
    init(view: (UIView & AnimationTransitionView)) {
        super.init(nibName: nil, bundle: nil)
        initConfigure(with: view)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension CustomPresentViewController {
    func initConfigure(with newView: UIView) {
        newView.frame = view.frame
        view = newView
        transitioningDelegate = transitionController
        modalPresentationStyle = .overCurrentContext
    }
}
