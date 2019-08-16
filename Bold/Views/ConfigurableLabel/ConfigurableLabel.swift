//
//  ConfigurableLabel.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import  UIKit

class ConfigurableLabel: ConfigurableView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Montserrat.regular.font(size: 15)
        label.textColor = #colorLiteral(red: 0.9215686275, green: 0.3568627451, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .center
        return label
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
        configureLabel()
    }
    
    private func configureLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: String) {
        label.text = viewModel
    }
    
}
