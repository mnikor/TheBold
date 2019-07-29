//
//  StakeHeaderView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol StakeHeaderViewDelegate: class {
    func tapRightButton()
}

class StakeHeaderView: BaseTableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    weak var delegate: StakeHeaderViewDelegate?
    
    @IBAction func tapPlusButton(_ sender: UIButton) {
        delegate?.tapRightButton()
    }
    
    func config() {
        
        imageView.image = UIImage.image(size: imageView.bounds.size, fillColors: [UIColor.white, UIColor.white.withAlphaComponent(0)])
    }
    
}
