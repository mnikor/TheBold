//
//  OnboardCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum OnboardTypeText {
    case feel
    case think
    case act
}

class OnboardCell: BaseCollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(typeText : OnboardTypeText) {
        switch typeText {
        case .feel:
            setupText(header: L10n.Splash.feel, body: L10n.Splash.feelDescription)
        case .think :
            setupText(header: L10n.Splash.think, body: L10n.Splash.thinkDescription)
        case .act :
            setupText(header: L10n.Splash.act, body: L10n.Splash.actDescription)
        }
    }
    
    private func setupText(header: String, body: String) {
        titleLabel.text = header
        detailLabel.text = body
    }
    
}
