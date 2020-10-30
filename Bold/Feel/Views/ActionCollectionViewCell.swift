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

    @IBOutlet weak var backgroundImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topLeftButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundImageView.image = nil
        backgroundImageView.backgroundColor = ColorName.typographyBlack100.color
    }

    func config(model: ActivityContent) {
        let typeCell = getType(by: model.contentStatus)
        topLeftButton.setImage(typeCell.image(), for: .normal)
        topLeftButton.isHidden = typeCell.hidden()
        titleLabel.text = model.title
        if let imageURL = model.largeImageURL {
            backgroundImageView.downloadImageAnimated(path: imageURL)
//            backgroundImageView.setImageAnimated(path: imageURL)//, placeholder: Asset.actionImage.image)
        } else {
            backgroundImageView.image = nil//Asset.actionImage.image
        }
    }
    
    private func getType(by status: ContentStatus) -> actionSmallCellType {
        switch status {
        case .locked:
            return .lock
        case .lockedPoints:
            return .shape
        case .unlocked:
            return .none
        default:
            return .none
        }
    }
    
}
