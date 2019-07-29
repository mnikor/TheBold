//
//  IconCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class IconCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        selectView.layer.cornerRadius = selectView.bounds.size.height / 2
    }
    
    func config(iconType: IdeasType, selectIcon: IdeasType, color: ColorGoalType) {
        
        guard let imageIcon = iconType.iconImage() else {
            return
        }
        
        if iconType == selectIcon {
            imageView.renderImageWithColor(image: imageIcon, color: color.colorGoal())
            selectView.backgroundColor = color.colorGoal()
            selectView.alpha = 0.1
        } else {
            imageView.renderImageWithColor(image: imageIcon, color: ColorName.typographyBlack100.color)
            selectView.backgroundColor = .white
            selectView.alpha = 1
        }
    }
    
}
