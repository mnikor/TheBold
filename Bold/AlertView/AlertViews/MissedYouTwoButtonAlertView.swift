//
//  MissedYouTwoButtonAlertView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class MissedYouTwoButtonAlertView: CongratulationsAlertView {

    @IBOutlet weak var cancelButton: UIButton!

    var activeCancelButton: (() -> Void)?
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        activeCancelButton?()
    }
    
    override class func loadViewFromNib() -> MissedYouTwoButtonAlertView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! MissedYouTwoButtonAlertView
        return nibView
    }

    override func configButtons() {
        okButton.setTitle(L10n.unlock, for: .normal)
        cancelButton.setTitle(L10n.cancel, for: .normal)
    }
}
