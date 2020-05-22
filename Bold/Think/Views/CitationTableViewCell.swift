//
//  CitationTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol CitationTableViewCellDelegate : class {
    func tapMoreInfoButton()
}

class CitationTableViewCell: BaseTableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationTextLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate : CitationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.cornerRadius = authorImageView.bounds.size.height / 2
        authorImageView.image = nil
        authorNameLabel.text = nil
        citationTextLabel.text = nil
        authorImageView.backgroundColor = .white
    }
    
    @IBAction func tapMoreButton(_ sender: UIButton) {
        delegate?.tapMoreInfoButton()
    }
    
    func config(content: ActivityContent) {
        authorImageView.setImageAnimated(path: content.authorPhotoURL ?? "")
        authorNameLabel.text = content.authorName
        citationTextLabel.text = content.body
    }
}
