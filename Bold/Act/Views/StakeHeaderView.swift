//
//  StakeHeaderView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ActHeaderType {
    case calendar
    case list
    case plus
    case none
    
    func imageInButton() -> UIImage {
        switch self {
        case .calendar:
            return Asset.calendarBlueIcon.image
        case .list:
            return Asset.listCalendar.image
        case .plus:
            return Asset.plusTodayActions.image
        default:
            return UIImage()
        }
    }
    
}

protocol StakeHeaderViewDelegate: class {
    func tapRightButton(type: ActHeaderType)
}

class StakeHeaderView: BaseTableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    weak var delegate: StakeHeaderViewDelegate?
    var type: ActHeaderType!
    
    @IBAction func tapPlusButton(_ sender: UIButton) {
        delegate?.tapRightButton(type: type)
    }
    
    func config(type: ActHeaderType) {
        
        self.type = type
        let color = type == .list ? ColorName.tableViewBackground.color : .white
        contentView.backgroundColor = type == .list ? color : .clear
        imageView.image = UIImage.image(size: imageView.bounds.size, fillColors: [color, color.withAlphaComponent(0)])
        plusButton.setImage(type.imageInButton(), for: .normal)
    }
    
}
