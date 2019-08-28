//
//  LevelOfMasteryBottomView.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class LevelOfMasteryFooterView: UIView {

    @IBOutlet weak var descriptionMidLabel: UILabel!
    @IBOutlet weak var descriptionLongLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        setup()
    }
    
    private func setup() {
        descriptionMidLabel?.text = L10n.Profile.LevelOfMastery.midTermGoalsDuration
        descriptionLongLabel?.text = L10n.Profile.LevelOfMastery.longTermGoalsDuration
    }
}
