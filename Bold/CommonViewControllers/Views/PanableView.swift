//
//  PanableView.swift
//  BuduSushiDev
//
//  Created by user on 10/11/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class PanableView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfigure()
    }
    
    private func initConfigure() {
        let lineView = UIView(frame: UIConstants.LineView.frame)
        lineView.backgroundColor = UIConstants.LineView.backgroundColor
        lineView.layer.cornerRadius = UIConstants.LineView.cornerRadius
        addSubview(lineView)
        
        lineView.snp.makeConstraints {
            make in
            make.width.equalTo(UIConstants.LineView.size.width)
            make.height.equalTo(UIConstants.LineView.size.height)
            make.top.equalToSuperview()
                .offset(UIConstants.LineView.top)
            make.center.equalToSuperview().priority(999)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
//    @available(*, unavailable)
//    override func addSubview(_ view: UIView) {
//        fatalError("addSubview(_ view:) has not been implemented")
//    }
    
    private struct UIConstants {
        struct LineView {
            static let size = CGSize(width: 76,
                                     height: 4)
            static let frame = CGRect(origin: .zero,
                                      size: UIConstants.LineView.size)
            static let top = 10
            static let leading = 150
            static let backgroundColor = UIColor.black.withAlphaComponent(0.2)
            static let cornerRadius: CGFloat = 2
        }
    }
}
