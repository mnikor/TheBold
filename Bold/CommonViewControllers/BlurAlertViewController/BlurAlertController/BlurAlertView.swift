//
//  BlurAlertView.swift
//  BuduSushiDev
//
//  Created by user on 10/10/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit
import SnapKit
import VisualEffectView

class BlurAlertView: BlurTransitionView {
    // MARK: - Fields
    
    var contentView: BaseContentView?
    private let bottomAgileView = UIView()
    private var bottomHideConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var agileBottomConstraint: Constraint?
    
    convenience init(contentView: BaseContentView?) {
        self.init(frame: CGRect.zero)
        self.contentView = contentView
        initConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    override func initConfigure() {
        super.initConfigure()
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        guard let contentView = contentView
            else { return }
        
        addSubview(contentView)
        addSubview(bottomAgileView)
        bottomAgileView.backgroundColor = contentView.backgroundColor
        
        configureContentView()
        configureBottomAgileView()
    }
    
    private func configureBottomAgileView() {
        guard let contentView = contentView
            else { return }
        
        bottomAgileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
            make.bottom.equalToSuperview().priority(1)
        }
    }
    
    private func configureContentView() {
        guard let contentView = contentView
            else { return }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            bottomHideConstraint = make.top.equalTo(blurView.snp.bottom).constraint
            bottomHideConstraint?.deactivate()
            if #available(iOS 11, *) {
                bottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).constraint
            } else {
                bottomConstraint = make.bottom.equalTo(blurView.snp.bottom).constraint
            }
            
        }
    }
    
    func updateContentViewFrame(offset: CGFloat) {
        bottomConstraint?.update(offset: offset)
    }
    
    func finishContentViewMove() {
        updateContentViewFrame(offset: 0)
        UIView.animate(withDuration: UIConstants.Animations.duration, delay: 0, options: [.allowUserInteraction], animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Public
    
    func showContentView() {
        bottomHideConstraint?.deactivate()
        bottomConstraint?.activate()
        updateContentViewFrame(offset: 0)
    }
    
    func hideContentView() {
        guard contentView != nil else {
            return
        }
        bottomConstraint?.deactivate()
        bottomHideConstraint?.activate()
    }
    
    deinit {
        contentView?.gestureRecognizers?.removeAll()
    }
    
    // MARK: - KeyboardAppearingView
    func updateUI(keyboardHeight: CGFloat) {
        updateContentViewFrame(offset: -keyboardHeight)
    }
    
    private struct UIConstants {
        struct BlurView {
            static let blurRadius: CGFloat = 3
            static let clearRadius: CGFloat = 0
        }
        
        struct Animations {
            static let duration = 0.3
        }
    }
}
