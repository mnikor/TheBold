//
//  ActProgressCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum GoalCellType {
    case active
    case locked
    case completed
    case failed
}

class GoalCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var goalProgressLabel: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var isDoneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goalProgressView.progressTintColor = .blue
        goalProgressView.trackTintColor = .white
    }

    func configCell(type: GoalEntity) {
        
        switch type.active {
        case .active:
            goalProgressView.progressTintColor = ColorName.goalGreen.color
            goalImageView.renderImageWithColor(image: Asset.menuAct.image, color: ColorName.goalGreen.color)
            isDoneImageView.isHidden = true
        case .locked:
            goalProgressView.progressTintColor = ColorName.goalGreen.color
            goalImageView.renderImageWithColor(image: Asset.menuAct.image, color: UIColor.white)
            goalView.backgroundColor = ColorName.goalGreen.color
            goalProgressView.progress = 1
            titleLabel.textColor = .white
            dueDateLabel.textColor = .white
            goalProgressLabel.textColor = .white
            goalProgressLabel.text = L10n.Act.goalIsLocked
            isDoneImageView.isHidden = true
        case .completed:
            isDoneImageView.isHidden = false
            isDoneImageView.image = Asset.completedIcon.image
            goalProgressLabel.text = L10n.Profile.ArchivedGoals.completed
        case .failed:
            isDoneImageView.isHidden = false
            isDoneImageView.image = Asset.failedIcon.image
            goalProgressLabel.text = L10n.Profile.ArchivedGoals.failed
        }
    }
    
}
