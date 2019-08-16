//
//  ImagedTitleView.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ImagedTitleView: ConfigurableView {
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = FontFamily.Montserrat.regular.font(size: 15)
        return label
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        configureLeftImageView()
        configureTitleLabel()
        configureRightImageView()
    }
    
    private func configureLeftImageView() {
        addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureRightImageView() {
        addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
    func configure(with viewModel: ImagedTitleViewModel) {
        leftImageView.image = viewModel.leftImage
        if let title = viewModel.attributedTitle {
            titleLabel.attributedText = title
        } else {
            titleLabel.text = viewModel.title
        }
        
        rightImageView.image = viewModel.rightImage
    }
    
}
