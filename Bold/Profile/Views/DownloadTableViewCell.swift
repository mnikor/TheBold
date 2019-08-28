//
//  DownloadTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol DownloadTableViewCellDelegate: class {
    func tapThreeDots(item: DownloadsEntity)
}

class DownloadTableViewCell: BaseTableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var tiltleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var treeDotsButton: UIButton!
    
    @IBOutlet weak var leftImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var paddingImageTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    weak var delegate: DownloadTableViewCellDelegate?
    
    var item: DownloadsEntity!
    
    @IBAction func actionTreeDotsLabel(_ sender: UIButton) {
        delegate?.tapThreeDots(item: item)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(downloads: DownloadsEntity, action:Bool) {
        item = downloads
        coverImageView.image = downloads.image
        tiltleLabel.text = downloads.title
        groupLabel.text = downloads.group
        treeDotsButton.isHidden = action
        
        if action {
            leftImageConstraint.constant = 24
            paddingImageTextConstraint.constant = 16
            heightConstraint.constant = 110
        }
    }
    
}
