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
    
    lazy var animationImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imageView)
        NSLayoutConstraint.activate([
            authorImageView.bottomAnchor.constraint(equalTo: imageView.topAnchor),
            moreButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            baseView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            ])
        imageView.isHidden = false
        return imageView
    }()
    
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
    
    private func readFile(name: String) -> URL? {
        let file = FileLoader.findFile(name: name)
        return file.first
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
            
            let fileName = DataSource.shared.searchFile(forKey: animationName, type: .anim_json)?.path
            let fileImage = DataSource.shared.searchFile(forKey: animationName, type: .anim_image)?.path
            
            if fileName == nil && fileImage != nil {
                if let filePath = readFile(name: fileImage!) {
                    animationImageView.isHidden = false
                    animationImageView.image = UIImage(contentsOfFile: filePath.path)
                }
            }
            
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
