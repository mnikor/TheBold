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

    func config(modelView: CreateGoalModel) {
        
        iconImageView.image = modelView.type.iconType()
        titleLabel.text = modelView.type.textType()
        valueLabel.isHidden = modelView.type.hideValue()
        accessoryImageView.isHidden = modelView.type.hideAccessoryIcon()
        
        switch modelView.modelValue {
        case .value(let value):
            valueLabel.text = value
        case .date(let dateString):
            valueLabel.text = dateString
        default:
            return
        }
    }
}
