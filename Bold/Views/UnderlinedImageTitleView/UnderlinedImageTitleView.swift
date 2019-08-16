//
//  UnderlinedImageTitleView.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class UnderlinedImageTitleView: ConfigurableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = FontFamily.Montserrat.regular.font(size: 15)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let underlineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .white
        configureTitleLabel()
        configureImageView()
        configureUnderlineView()
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(26)
        }
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
    private func configureUnderlineView() {
        addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(0.5)
        }
    }
    
    func configure(with viewModel: UnderlinedImageTitleViewModel) {
        if let title = viewModel.attributedTitle {
            titleLabel.attributedText = title
        } else {
            titleLabel.text = viewModel.title
        }
        
        imageView.image = viewModel.image
        
        underlineView.backgroundColor = viewModel.underlineColor ?? #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    }
    
}
