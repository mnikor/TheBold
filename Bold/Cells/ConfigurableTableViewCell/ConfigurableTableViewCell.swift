//
//  ConfigurableTableViewCell.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ConfigurableTableViewCell<ViewType>: UITableViewCell, Reusable, ViewModelConfigurable where ViewType: ConfigurableView {
    // MARK: - Private variables
    
    private var createViewBlock: (() -> ViewType)?
    private(set) var containerView: ViewType?
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
    // MARK: - Init configure
    
    func initConfigure() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    // MARK: - Public
    
    func setCellCreateViewBlock(_ block: @escaping () -> ViewType) {
        createViewBlock = block
    }
    
    func setupUI(insets: UIEdgeInsets = .zero, height: CGFloat? = nil) {
        initContainerViewIfNeeded()
        placeContainerView(insets: insets, height: height)
    }
    
    func configure(with viewModel: ViewType.ViewModel) {
        setupUIIfNeeded()
        containerView?.configure(with: viewModel)
    }
    
    // MARK: - Private
    
    private func initContainerViewIfNeeded() {
        if containerView == nil {
            guard let createViewBlock = createViewBlock else { return }
            let createdContainerView = createViewBlock()
            containerView = createdContainerView
            contentView.addSubview(createdContainerView)
        }
    }
    
    private func placeContainerView(insets: UIEdgeInsets, height: CGFloat?) {
        containerView?.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(insets.left)
            make.top.equalToSuperview().offset(insets.top)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
            if let height = height {
                make.height.equalTo(height)
            }
        }
    }
    
    private func needSetupUI() -> Bool {
        return containerView == nil
    }
    
    private func setupUIIfNeeded() {
        if needSetupUI() {
            setupUI()
        }
    }
    
}
