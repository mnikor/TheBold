//
//  CreateGoalCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 22.04.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

class CreateGoalCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.text = L10n.Act.Cell.createGoal
        descriptionLabel.text = L10n.Act.Cell.asWeProgressWeBecomeDifferent
    }
}
