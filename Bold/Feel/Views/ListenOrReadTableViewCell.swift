//
//  ListenOrReadTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ButtonCombinationType {
    case start
    case unlock
    case addToPlan
    case listenPreview
    case readPreview
    case none
}

class ListenOrReadTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var addPlanButton: UIButton!
    @IBOutlet weak var listenPreviewButton: UIButton!
    @IBOutlet weak var readPreviewButton: UIButton!
    
    @IBAction func tapStartButton(_ sender: UIButton) {
    }
    
    @IBAction func tapUnlockButton(_ sender: UIButton) {
    }
    
    @IBAction func tapAddPlanButton(_ sender: UIButton) {
    }
    
    @IBAction func tapListenPreviewButton(_ sender: UIButton) {
    }
    
    @IBAction func tapReadPreviewButton(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startButton.isHidden = true
        unlockButton.isHidden = true
        addPlanButton.isHidden = true
        listenPreviewButton.isHidden = true
        readPreviewButton.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(combinationButtonArray: [ButtonCombinationType]) {
    
    }
    
}
