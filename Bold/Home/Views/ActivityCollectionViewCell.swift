//
//  ActivityListCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(with type: FeelTypeCell) {
        titleLabel.text = type.titleText()
    }
    
    func config(with viewModel: ContentViewModel) {
        titleLabel.text = viewModel.title
        if let backgroundImage = viewModel.backgroundImage {
            backgroundImageView.image = backgroundImage
        } else {
            backgroundImageView.image = Asset.feelBackground.image
        }
    }

}
