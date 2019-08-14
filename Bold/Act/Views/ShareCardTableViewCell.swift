//
//  ShareCardTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ShareCardTableViewCell: BaseTableViewCell {

    @IBOutlet weak var smallTitleLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        smallTitleLabel.text = L10n.Act.Share.myActionIs
    }

    func config(actionText: String, color: ColorGoalType) {
        
        actionLabel.text = actionText
        cardView.backgroundColor = color.colorGoal()
    }
}
