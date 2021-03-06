//
//  StakeActionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol StakeActionTableViewCellDelegate: class {
    func tapLongPress()
}

class StakeActionTableViewCell: BaseTableViewCell {

    @IBOutlet weak var contentActionView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var stakeLabel: UILabel!
    @IBOutlet weak var pointsActivityLabel: UILabel!
    @IBOutlet weak var shapeImageView: UIImageView!
    
    @IBOutlet weak var stakeStackView: UIStackView!
    
    weak var delegate: StakeActionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addLongTapRecognizer()
    }
    
    func addLongTapRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(activeLongPress(gesture:)))
        longPress.minimumPressDuration = 1.0
        //longPress.delegate = self
        contentActionView.addGestureRecognizer(longPress)
    }
    
    @objc func activeLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("Long press")
            delegate?.tapLongPress()
        }
    }
    
    func config() {
        
        titleLabel.strikethrough(text: "Marathon")
    }
    
}

