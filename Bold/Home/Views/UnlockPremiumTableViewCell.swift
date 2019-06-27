//
//  UnlockPremiumTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol UnlockPremiumTableViewCellDelegate: class {
    func tapUnlockPremium()
}

class UnlockPremiumTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtiltleLabel: UILabel!
    @IBOutlet weak var unlockButton: RoundedButton!
    
    weak var delegate: UnlockPremiumTableViewCellDelegate?
    
    @IBAction func tapUnlockButton(_ sender: UIButton) {
        delegate?.tapUnlockPremium()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
