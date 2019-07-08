//
//  ActionCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum actionSmallCellType: Int {
    case none
    case shape
    case lock
    
    func image() -> UIImage {
        switch self {
        case .none:
            return UIImage()
        case .shape:
            return Asset.actionShape.image
        case .lock:
            return Asset.actionLock.image
        }
    }
    
    func hidden() -> Bool {
        switch self {
        case .lock, .shape:
            return false
        case .none:
            return true
        }
    }
}

class ActionCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topLeftButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config() {
        
        guard let typeCell = actionSmallCellType(rawValue: Int(arc4random_uniform(3))) else { return }
        topLeftButton.setImage(typeCell.image(), for: .normal)
        topLeftButton.isHidden = typeCell.hidden()
    }
    
}
