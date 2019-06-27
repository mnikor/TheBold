//
//  ActProgressCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var goalProgressLabel: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goalProgressView.progressTintColor = .blue
        goalProgressView.trackTintColor = .white
    }

    func configCell() {
        
        goalProgressView.progressTintColor = ColorName.goalGreen.color
        goalImageView.image = Asset.menuAct.image.withRenderingMode(.alwaysTemplate)
        goalImageView.tintColor = ColorName.goalGreen.color
        
    }
    
}
