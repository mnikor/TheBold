//
//  SettingActionPlanTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class SettingActionPlanTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!

    func config(item: AddActionEntity) {
        iconImageView.image = item.type.iconType()
        titleLabel.text = item.type.textType()
        valueLabel.isHidden = item.type.hideValue()
        if item.currentValue != nil {
            valueLabel.text = item.currentValue as? String
        }
        accessoryImageView.isHidden = item.type.hideAccessoryIcon()
    }
    
}
