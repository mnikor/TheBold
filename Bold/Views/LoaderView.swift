//
//  LoaderView.swift
//  Bold
//
//  Created by Admin on 08.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class LoaderView: UIImageView {
    private let images: [UIImage] = {
        let fillColor = UIColor(red: 69/255, green: 98/255, blue: 205/255, alpha: 1)
        return (1 ... 120).compactMap {UIImage(named: "loader\($0)")?.withColor(fillColor) }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentMode = .scaleAspectFit
        self.tintColor = UIColor(red: 69/255, green: 98/255, blue: 205/255, alpha: 1)
        self.animationImages = images
        self.animationRepeatCount = Int.max
        self.animationDuration = 1.2
    }
    
    func start(in containerView: UIView) {
        containerView.addSubview(self)
        self.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(self.snp.width)
            make.center.equalToSuperview()
        }
        self.startAnimating()
    }
    
    func stop() {
        self.stopAnimating()
        self.removeFromSuperview()
    }
    
}
