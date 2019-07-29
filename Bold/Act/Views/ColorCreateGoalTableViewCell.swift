//
//  ColorCreateGoalTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ColorCreateGoalTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = colorView.bounds.size.height / 2
    }
    
    func config(item: AddActionEntity, colorType: ColorGoalType) {
        
        iconImageView.image = item.type.iconType()
        titleLabel.text = item.type.textType()
        colorView.backgroundColor = colorType.colorGoal()
    }
    
}
