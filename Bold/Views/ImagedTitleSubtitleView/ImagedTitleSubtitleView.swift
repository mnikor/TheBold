//
//  ImagedTitleSubtitleView.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import SnapKit

class ImagedTitleSubtitleView: ConfigurableView {
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = FontFamily.Montserrat.regular.font(size: 15)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = FontFamily.Montserrat.regular.font(size: 13)
        label.textColor = #colorLiteral(red: 0.4196078431, green: 0.4509803922, blue: 0.5450980392, alpha: 1)
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
        configureContainerView()
        configureTitleLabel()
        configureSubtitleLabel()
        configureRightImageView()
    }
    
    private func configureLeftImageView() {
        addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(39)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftImageView.snp.trailing).offset(15)
        }
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureSubtitleLabel() {
        containerView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    private func configureRightImageView() {
        addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
    func configure(with viewModel: ImagedTitleSubtitleViewModel) {
        leftImageView.image = viewModel.leftImage
        if let title = viewModel.attributedTitle {
            titleLabel.attributedText = title
        } else {
            titleLabel.text = viewModel.title
        }
        
        if let subtitle = viewModel.attributedSubtitle {
            subtitleLabel.attributedText = subtitle
        } else {
            subtitleLabel.text = viewModel.subtitle
        }
        
        rightImageView.image = viewModel.rightImage
    }
    
}
