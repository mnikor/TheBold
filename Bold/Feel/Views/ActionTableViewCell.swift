//
//  ActionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/25/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActionTableViewCellDelegate: class {
    func tapLeftHeaderButton()
    func tapThreeDotsButton(item: ActionEntity)
    func tapDownloadButton(cell: ActionTableViewCell)
    func tapLikeButton(cell: ActionTableViewCell)
    func tapAddActionPlanButton()
}

enum HeaderType : UInt {
    case duration
    case points
    case unlock
    
    func topConstraint() -> CGFloat {
        switch self {
        case .duration, .points:
            return 12
        case .unlock:
            return 20
        }
    }
    
}

class ActionTableViewCell: BaseTableViewCell {

    weak var delegate: ActionTableViewCellDelegate?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftHeaderButton: UIButton!
    @IBOutlet weak var rightHeaderLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var threeDotsButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var addActionPlanButton: UIButton!
    @IBOutlet weak var topHeaderButtonConstraint: NSLayoutConstraint!
    
    var item : ActionEntity!
    
    @IBAction func tapLeftHeaderButton(_ sender: UIButton) {
        delegate?.tapLeftHeaderButton()
    }
    
    @IBAction func tapThreeDotsButton(_ sender: UIButton) {
        delegate?.tapThreeDotsButton(item: item)
    }
    
    @IBAction func tapDownloadButton(_ sender: UIButton) {
        delegate?.tapDownloadButton(cell: self)
    }
    
    @IBAction func tapLikeButton(_ sender: UIButton) {
        delegate?.tapLikeButton(cell: self)
    }
    
    @IBAction func tapAddActionPlanButton(_ sender: UIButton) {
        delegate?.tapAddActionPlanButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(item: ActionEntity) {
        
        self.item = item
        configHeader(type: item.header!)
        configButton(item: item)
        
        //guard let tempHeaderType = HeaderType(rawValue: UInt(arc4random_uniform(3))) else { return }
//        configHeader(type: headerType)
//        configButton(item: item)
    }
    
    func configButton(item: ActionEntity) {
        downloadButton.setImage(item.download == false ? Asset.actionDownload.image : Asset.actionDownloaded.image, for: .normal)
        likeButton.setImage(item.like == false ? Asset.actionLike.image : Asset.actionLiked.image, for: .normal)
    }
    
    func configHeader(type: HeaderType) {
        
        topHeaderButtonConstraint.constant = type.topConstraint()
        
        switch type {
        case .duration:
            leftHeaderButton.setImage(Asset.actionClock.image, for: .normal)
            leftHeaderButton.setBackgroundImage(nil, for: .normal)
            leftHeaderButton.setTitle(nil, for: .normal)
            leftHeaderButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            leftHeaderButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightHeaderLabel.isHidden = false
            rightHeaderLabel.text = "5min"
        case .points:
            leftHeaderButton.setImage(Asset.actionShape.image, for: .normal)
            leftHeaderButton.setBackgroundImage(nil, for: .normal)
            leftHeaderButton.setTitle(nil, for: .normal)
            leftHeaderButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            leftHeaderButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightHeaderLabel.isHidden = false
            rightHeaderLabel.text = "20 points to unlock"
        case .unlock:
            leftHeaderButton.setImage(Asset.actionUnlockIcon.image, for: .normal)
            leftHeaderButton.setBackgroundImage(Asset.actionUnlockBackground.image, for: .normal)
            leftHeaderButton.setTitle(L10n.unlock, for: .normal)
            leftHeaderButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            leftHeaderButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            rightHeaderLabel.isHidden = true
            rightHeaderLabel.text = ""
        }
    }
    
}
