//
//  MissedYouAlertView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class MissedYouOneButtonAlertView: CongratulationsAlertView {

    override class func loadViewFromNib() -> MissedYouOneButtonAlertView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! MissedYouOneButtonAlertView
        return nibView
    }

    override func configButtons() {
        okButton.setTitle(L10n.okay, for: .normal)
    }
}
