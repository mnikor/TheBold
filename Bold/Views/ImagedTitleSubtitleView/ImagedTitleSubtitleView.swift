//
//  ImagedTitleSubtitleView.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import SnapKit

protocol ImagedTitleSubtitleViewDelegate: class {
    func imagedTitleSubtitleViewDidTapAtLeftImage()
}

class ImagedTitleSubtitleView: ConfigurableView {
    weak var delegate: ImagedTitleSubtitleViewDelegate?
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_icon")
        imageView.layer.cornerRadius = 27
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.cornerRadius = 10
        imageView.image = Asset.cameraGrayscale.image
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
        configureIconImageView()
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
            make.width.height.equalTo(54)
            make.centerY.equalToSuperview()
        }
        leftImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtLeftImageView))
        leftImageView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureIconImageView() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView).offset(36)
            make.top.equalTo(leftImageView).offset(36)
            make.width.height.equalTo(20)
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
        
        if let image = SessionManager.shared.profile?.image {
            leftImageView.image = image
        } else if let imagePath = viewModel.leftImagePath {
            leftImageView.setImageAnimated(path: imagePath, completion: viewModel.imageLoadingCompletion)
        }
        
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
    
    @objc private func didTapAtLeftImageView() {
        delegate?.imagedTitleSubtitleViewDidTapAtLeftImage()
    }
    
}
