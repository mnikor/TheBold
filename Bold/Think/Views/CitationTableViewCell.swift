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
    func animateState(status: @escaping Callback<Bool>)
}

class CitationTableViewCell: BaseTableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var authorImageView: CustomImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationTextLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var contentAnimationView: UIView!
    
    weak var delegate : CitationTableViewCellDelegate?
    
    private var animationContent: AnimationContentView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baseView.cornerRadius = 10
        authorImageView.cornerRadius = authorImageView.bounds.size.height / 2
        authorImageView.image = nil
        authorNameLabel.text = nil
        citationTextLabel.text = nil
        authorImageView.backgroundColor = .clear
        baseView.backgroundColor = ColorName.goalYellow.color
    }
    
    @IBAction func tapMoreButton(_ sender: UIButton) {
        delegate?.tapMoreInfoButton()
    }
    
    func config(content: ActivityContent) {
        
        authorNameLabel.text = content.authorName
        citationTextLabel.text = content.body
        citationTextLabel.isHidden = false
        
        if let authorPhotoURL = content.authorPhotoURL {
            authorImageView.downloadImageAnimated(path: authorPhotoURL)
        }else {
            authorImageView.image = nil
        }
        
        if let colorHex = content.color{
            baseView.backgroundColor = UIColor.hexStringToUIColor(hex: colorHex)
        }
        
        if let animationName = content.animationKey {
            citationTextLabel.isHidden = true
            animationContent = AnimationContentView.setupAnimation(view: contentAnimationView, name: animationName)
        }
        
        animationContent?.play()
        
        delegate?.animateState(status: {[weak self] (isPlay) in
            if isPlay == true {
                self?.animationContent?.play()
            }else {
                self?.animationContent?.stop()
            }
        })
    }
}
