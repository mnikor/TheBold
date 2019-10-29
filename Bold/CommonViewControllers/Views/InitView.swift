//
//  InitView.swift
//  BuduSushiDev
//
//  Created by branderstudio on 9/4/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit
import SnapKit

class InitView: UIView {
    
    // MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        initConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfigure()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
    // MARK: - Init configure
    
    func initConfigure() {
        backgroundColor = .white
    }
}
