//
//  AlertContentView.swift
//  BuduSushiDev
//
//  Created by user on 10/12/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class AlertContentView: BaseContentView {
    
    var containerView: UIView? {
        didSet {
            guard let containerView = containerView else { return }
            configureContainerView()
            updateScrollViewConstraints()
        }
    }
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var panableView = PanableView()
    private var scrollView = UIScrollView()
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfigure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 14)
    }
    
    private func initConfigure() {
        backgroundColor = .white
        layout()
    }
    
    private func layout() {
        super.addSubview(backgroundImageView)
        super.addSubview(panableView)
        super.addSubview(scrollView)
        scrollView.addSubview(contentView)
        makeConstraints()
    }
    
    private func makeConstraints() {
        configBackgroundImageView()
        configPanableView()
        configureScrollView()
        configureContentView()
    }
    
    private func configBackgroundImageView() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configPanableView() {
        panableView.snp.makeConstraints {
            make in
            make.height.equalTo(UIConstants.PanableView.height)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureScrollView() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(panableView).offset(UIConstants.ScrollView.top)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(UIConstants.ScrollView.minHeight)
        }
    }
    
    private func configureContentView() {
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIConstants.ScrollView.minHeight)
            make.width.equalToSuperview()
        }
    }
    
    private func configureContainerView() {
        guard let containerView = containerView else { return }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateScrollViewConstraints() {
        guard let containerView = containerView else { return }
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let contentHeight = containerView.sizeThatFits(constraintRect).height
        
        if contentHeight <= UIConstants.ScrollView.maxHeight {
            scrollView.snp.updateConstraints { update in
                update.height.equalTo(contentHeight)
            }
        } else {
            scrollView.snp.updateConstraints { update in
                update.height.equalTo(UIConstants.ScrollView.maxHeight)
            }
        }
        contentView.snp.updateConstraints { update in
            update.height.equalTo(contentHeight)
        }
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private struct UIConstants {
        
        struct SelfView {
            static let color: UIColor = .white
            static let cornerRadius: CGFloat = 6
        }
        
        struct PanableView {
            static let height: CGFloat = 24
        }
        
        struct ScrollView {
            static let top: CGFloat = 20
            static let maxHeight: CGFloat = (UIScreen.main.bounds.height * 9 / 10) - 44
            static let minHeight: CGFloat = 50
        }
        
        struct TitleLabel {
            static let top: CGFloat = 34
            static let leading: CGFloat = 71
            static let alignment: NSTextAlignment = .center
        }
        
        struct MessageLabel {
            static let leading: CGFloat = 40
            static let top: CGFloat = 26
            static let bottom: CGFloat = 35
            static let lineHeight: CGFloat = 16
            static let alignment: NSTextAlignment = .center
        }
    }
}
