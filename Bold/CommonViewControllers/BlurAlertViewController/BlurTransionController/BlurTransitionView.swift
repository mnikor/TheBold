//
//  BlurTransitionView.swift
//  BuduSushi
//
//  Created by branderstudio on 12/20/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import Foundation
import VisualEffectView

protocol BlurTransitionViewDelegate: class {
    func didTapOnBlurView(_ view: BlurTransitionView)
}

protocol BlurTransition: AnimationTransitionView {
    var blurDelegate: BlurTransitionViewDelegate? { set get }
}

class BlurTransitionView: InitView, AnimationTransitionView, BlurTransition {
    
    // MARK: - Public variables
    
    weak var blurDelegate: BlurTransitionViewDelegate?
    
    // MARK: - UI elements
    
    let blurView = VisualEffectView()
    
    private let backgroundTapRecognizer = UITapGestureRecognizer()
    
    // MARK: - Init configure
    
    override func initConfigure() {
        super.initConfigure()
        configureSelf()
        configureBlurView()
        configureTapRecognizer()
    }
    
    private func configureSelf() {
        backgroundColor = .clear
    }
    
    private func configureBlurView() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTapRecognizer() {
        backgroundTapRecognizer.addTarget(self, action: #selector(didTapOnBlurView))
        blurView.addGestureRecognizer(backgroundTapRecognizer)
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnBlurView() {
        blurDelegate?.didTapOnBlurView(self)
    }
    
    // MARK: - AnimationTransitionView
    
    func applyPresentAnimationChanges() {
        blurView.blurRadius = 3
    }
    
    func applyDismissAnimationChanges() {
        blurView.blurRadius = 0
    }
    
}
