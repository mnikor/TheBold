//
//  IdeasTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class IdeasTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameIdeaLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(type: IdeasType, selectIdea: IdeasType) {
        
        iconImageView.image = type.iconImage()
        nameIdeaLabel.text = type.titleText()
        checkImageView.isHidden = type != selectIdea
    }
    
}
