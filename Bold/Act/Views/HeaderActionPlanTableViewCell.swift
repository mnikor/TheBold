//
//  HeaderActionPlanTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class HeaderActionPlanTableViewCell: BaseTableViewCell {

    @IBOutlet weak var contentImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var infinityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentImageView.image = nil
        contentImageView.backgroundColor = ColorName.typographyBlack100.color
    }
    
    func config(modelView: CreateGoalActionModel) {
        
        if case .headerContent(let contentModel) = modelView.modelValue, let content = contentModel {
            
            if let imagePath = content.imagePath {
                contentImageView.downloadImageAnimated(path: imagePath)
                //contentImageView.setImageAnimated(path: imagePath)//, placeholder: Asset.addActionHeader.image)
            }
            titleLabel.text = content.title
            subtitleLabel.text = content.subtitle
            pointsLabel.text = content.points
            infinityImageView.image = content.shapeIcon
            }
        
    }
    
}
