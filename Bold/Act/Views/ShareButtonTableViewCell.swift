//
//  ShareButtonTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ShareButtonTableViewCellDelegate: class {
    func tapButton(shareType: ShareTypeButton)
}

class ShareButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: ShareButtonTableViewCellDelegate?
    var shareType : ShareTypeButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configCell()
    }
    
    override func layoutSubviews() {
        shareButton.positionImageFirstInButton()
    }
    
    private func configCell() {
        shareButton.backgroundColor = .white
        shareButton.cornerRadius()
        shareButton.borderWidth(color: Color(red: 235/255, green: 236/255, blue: 240/255, alpha: 1))
    }
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        delegate?.tapButton(shareType: shareType)
    }
    
    func config(type: ShareTypeButton) {
        shareType = type
        shareButton.setTitle(type.title(), for: .normal)
        shareButton.setImage(type.icon(), for: .normal)
    }

}
