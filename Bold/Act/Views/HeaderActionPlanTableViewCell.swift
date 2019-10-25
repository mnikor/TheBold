//
//  HeaderActionPlanTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class HeaderActionPlanTableViewCell: BaseTableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var infinityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(modelView: CreateGoalActionModel) {
        
        if case .headerContent(let contentModel) = modelView.modelValue, let content = contentModel {
            
            contentImageView.image = content.image
            titleLabel.text = content.title
            subtitleLabel.text = content.subtitle
            pointsLabel.text = content.points
            infinityImageView.image = content.shapeIcon
            }
        
    }
    
}
