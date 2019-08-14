//
//  BodyConfigureTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/30/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class BodyConfigureTableViewCell: BaseTableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var configureTextLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(type: ConfigureActionType.BodyType, model: ConfigureActionModel) {
        
        checkImageView.image = type == model.isSelected ? Asset.checkIcon.image : UIImage()
        configureTextLabel.textColor = type == model.isSelected ? ColorName.typographyBlack100.color : ColorName.typographyBlack50.color
        configureTextLabel.text = type.titleText()
        accessoryImageView.isHidden = type.accesoryIsHidden()
        currentValueLabel.isHidden = type.currentValueIsHidden()
        
        if type == .daysOfWeek {
            if type == model.isSelected {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.accessoryImageView.transform = self.transform.rotated(by: CGFloat.pi / 2)
                }, completion: nil)
            }else {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.accessoryImageView.transform = self.transform.rotated(by: CGFloat.zero)
                }, completion: nil)
            }
        }
    }
    
}
