//
//  CongratulationsAlertView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CongratulationsAlertView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleILabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func tapOkButton(_ sender: UIButton) {
        activeOkButton?()
    }
    
    var activeOkButton: (() -> Void)?

    class func loadViewFromNib() -> CongratulationsAlertView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! CongratulationsAlertView
        return nibView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configButtons()
    }
    
    func config(type: BoldAlertType) {
        iconImageView.image = type.icon()
        titleILabel.text = type.titleText()
        textLabel.text = type.text()
    }
    
    func configButtons() {
        okButton.setTitle(L10n.get + " 50", for: .normal)
        okButton.setImage(Asset.shapeWhiteButton.image, for: .normal)
        okButton.positionImageAfterText(padding: 3)
    }
    
}
