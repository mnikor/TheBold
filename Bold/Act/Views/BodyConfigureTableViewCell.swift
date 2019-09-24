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
    
    func config(type:ConfigureActionType.BodyType, modelView: ConfigureActionModelType) {
        
        switch modelView {
        case .body(title: let title, value: let value, accessory: let accessory, isSelected: let isSelected, textColor: let textColor):
            checkImageView.image = isSelected == true ? Asset.checkIcon.image : UIImage()
            configureTextLabel.textColor = textColor
            configureTextLabel.text = title
            currentValueLabel.text = value
            accessoryImageView.isHidden = accessory
            
            if type == .daysOfWeek {
                animate(isSelected: isSelected)
            }
        default:
            return
        }
    }
    
    private func animate(isSelected: Bool) {
        if isSelected {
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
