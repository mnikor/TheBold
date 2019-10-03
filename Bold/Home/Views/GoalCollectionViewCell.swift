//
//  ActProgressCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

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

    func configCell(viewModel: GoalCollectionViewModel) {
        
        goalProgressView.trackTintColor = viewModel.backgroundColor
        goalProgressView.progressTintColor = viewModel.progressTintColor
        goalProgressView.progress = viewModel.progress
        goalImageView.renderImageWithColor(image: viewModel.icon, color: viewModel.iconColor)
        goalView.backgroundColor = viewModel.backgroundColor
        titleLabel.textColor = viewModel.titleTextColor
        dueDateLabel.textColor = viewModel.dueDateTextColor
        goalProgressLabel.textColor = viewModel.progressTextColor
        titleLabel.text = viewModel.title
        dueDateLabel.text = viewModel.dueDate
        goalProgressLabel.text = viewModel.progressText
        isDoneImageView.image = viewModel.completedIcon
        isDoneImageView.isHidden = viewModel.isHiddenCompletedIcon
    }
    
}
