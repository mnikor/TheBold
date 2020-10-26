//
//  RateAndShareView.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/16/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol RateAndShareViewDelegate: class {
    func rateUs()
    func share(with image: UIImage, actionType: String)
}

class RateAndShareView: UIView {
    weak var delegate: RateAndShareViewDelegate?
    
    @IBOutlet weak var sharableView: UIView!
    @IBOutlet weak var actionImageView: CustomImageView!
    @IBOutlet weak var myActionIsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateUsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // CITATION
    
    @IBOutlet weak var citationView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationLabel: UILabel!

    private var action: ActionEntity?
    private var activityContent: ActivityContent?
    private var descriptionViewModel: DescriptionViewModel?
    private var actionType: String?
    private var isFoodForThoughts = false
    
    private func configureSubviews() {
        rateUsButton.layer.borderWidth = 1
        rateUsButton.layer.borderColor = ColorName.typographyBlack25.color.withAlphaComponent(0.25).cgColor
        
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = ColorName.typographyBlack25.color.withAlphaComponent(0.25).cgColor
    }
    
    static func loadFromNib() -> RateAndShareView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! RateAndShareView
        nibView.configureSubviews()
        return nibView
    }
    
    func configure(with action: ActionEntity) {
        self.action = action
        titleLabel.text = action.data?.title
        
        if let activityContent = action.data, let imageURL = activityContent.imageURL {
            actionType = activityContent.type.rawValue.capitalizingFirstLetter()
            myActionIsLabel.text = actionType
            actionImageView.downloadImageAnimated(path: imageURL)
        }
    }
    
    func configure(with action: ActivityContent) {
        self.activityContent = action
        titleLabel.text = action.title
        
        if let activityContent = activityContent, let imageURL = activityContent.imageURL {
            actionType = activityContent.type.rawValue.capitalizingFirstLetter()
            myActionIsLabel.text = actionType
            actionImageView.downloadImageAnimated(path: imageURL)
        }
    }
    
    func configure(with action: DescriptionViewModel) {
        self.descriptionViewModel = action
        titleLabel.text = descriptionViewModel?.title
        actionType = action.category?.rawValue.capitalizingFirstLetter()
        myActionIsLabel.text = actionType
        
        switch action.image {
        case .image(let image):
            actionImageView.image = image
        case .path(let path):
            actionImageView.downloadImageAnimated(path: path!)
        }
    }
    
    func configureCitation(authorImage: UIImage?, authorName: String?, citation: String?, imagePath: String? = nil, color: UIColor) {
        isFoodForThoughts = true
        if let path = imagePath {
            actionImageView.downloadImageAnimated(path: path)
        }
        backgroundImageView.backgroundColor = color
        if let imagePath = imagePath {
            backgroundImageView.contentMode = .scaleToFill
            backgroundImageView.image = UIImage(contentsOfFile: imagePath)
        }
        authorImageView.backgroundColor = .clear
        authorImageView.image = authorImage
        authorNameLabel.text = authorName
        citationLabel.text = citation
        citationView.isHidden = false
    }
    
    @IBAction private func rateUsAction() {
        delegate?.rateUs()
    }
    
    @IBAction private func shareAction() {
        let image = isFoodForThoughts ? citationView.asImage() : sharableView.asImage()
        delegate?.share(with: image, actionType: actionType ?? "")
    }
    
}

