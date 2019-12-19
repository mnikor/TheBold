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
    func tapBoldManifest()
}

class UnlockPremiumTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtiltleLabel: UILabel!
    @IBOutlet weak var unlockButton: RoundedButton!
    
    weak var delegate: UnlockPremiumTableViewCellDelegate?
    private var type : HomeActionsTypeCell!
    
    @IBAction func tapUnlockButton(_ sender: UIButton) {
        if type == HomeActionsTypeCell.boldManifest {
            delegate?.tapBoldManifest()
        }else {
            delegate?.tapUnlockPremium()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    func configCell(type: HomeActionsTypeCell) {
        
        self.type = type
        
        switch type {
        case .boldManifest:
            titleLabel.text = L10n.Home.boldManifest
            subtiltleLabel.text = L10n.Home.findOutWhatItMeansToBeBold
            unlockButton.setTitle(L10n.Home.findOut, for: .normal)
        case .unlockPremium:
            titleLabel.text = L10n.Home.unlockPremium
            subtiltleLabel.text = L10n.Home.andGetAccessToAllResources
            unlockButton.setTitle(L10n.Home.unlock, for: .normal)
        default:
            break
        }
    }
    
}
