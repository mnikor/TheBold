//
//  MenuTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum MenuItemType {
    case home
    case feel
    case think
    case act
    case settings
    
    func image(imageView: UIImageView, label: UILabel, counter: UILabel) {
        switch self {
        case .home:
            imageView.image = Asset.menuHome.image
            label.text = L10n.Menu.home
            counter.isHidden = true
        case .feel:
            imageView.image = Asset.menuFeel.image
            label.text = L10n.Menu.feel
            counter.isHidden = true
        case .think:
            imageView.image = Asset.menuThink.image
            label.text = L10n.Menu.think
            counter.isHidden = true
        case .act:
            imageView.image = Asset.menuAct.image
            label.text = L10n.Menu.act
            counter.isHidden = true
        case .settings:
            imageView.image = Asset.menuSettings.image
            label.text = L10n.Menu.settings
            counter.isHidden = true
        }
    }
}

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(typeCell: MenuItemType) {
        self.backgroundColor = .clear
        typeCell.image(imageView: iconImageView, label: titleLabel, counter: counterLabel)
    }
}
