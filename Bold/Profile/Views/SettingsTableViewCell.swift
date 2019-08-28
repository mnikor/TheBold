//
//  SettingsTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class SettingsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(type: ElementsAlertType) {
        
        if type == .addToPlan {
            arrowImageView.isHidden = false
            titleLabel.text = L10n.Act.addToActionPlan
            titleLabel.textColor = ColorName.typographyBlack100.color
        }else {
            arrowImageView.isHidden = true
            titleLabel.text = L10n.delete
            titleLabel.textColor = Color(red: 68/255, green: 97/255, blue: 205/255, alpha: 1)
        }
    }
    
}
