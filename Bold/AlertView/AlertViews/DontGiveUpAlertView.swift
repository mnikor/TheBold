//
//  DontGiveUpAlertView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/10/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class DontGiveUpAlertView: MissedYouTwoButtonAlertView {

    override class func loadViewFromNib() -> DontGiveUpAlertView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! DontGiveUpAlertView
        return nibView
    }
    
    override func configButtons(points: Int) {
        okButton.setTitle(L10n.yes + ", \(points)", for: .normal)
        okButton.setImage(Asset.shapeBlueButton.image, for: .normal)
        okButton.positionImageAfterText(padding: 3)
        cancelButton.setTitle(L10n.no, for: .normal)
    }
}
