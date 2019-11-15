//
//  ShareView.swift
//  Bold
//
//  Created by Admin on 14.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ShareViewDelegate: class {
    func shareWithFacebook(goal: Goal)
    func shareWithEmail(goal: Goal)
    func download(goal: Goal)
}

class ShareView: UIView {
    weak var delegate: ShareViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var downloadView: UIView!
    
    private var entity: Goal?
    
    private func configureSubviews() {
        facebookView.layer.borderWidth = 0.3
        emailView.layer.borderWidth = 0.3
        downloadView.layer.borderWidth = 0.3
        
        facebookView.layer.borderColor = UIColor.lightGray.cgColor
        emailView.layer.borderColor = UIColor.lightGray.cgColor
        downloadView.layer.borderColor = UIColor.lightGray.cgColor
        
        let facebookTapRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(shareWithFacebook))
        let emailTapRecognizer = UITapGestureRecognizer(target: self,
                                                        action: #selector(shareWithEmail))
        let downloadTapRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(download))
        
        facebookView.addGestureRecognizer(facebookTapRecognizer)
        emailView.addGestureRecognizer(emailTapRecognizer)
        downloadView.addGestureRecognizer(downloadTapRecognizer)
    }
    
    
    
    static func loadFromNib() -> ShareView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! ShareView
        nibView.configureSubviews()
        return nibView
    }
    
    func configure(with entity: Goal) {
        self.entity = entity
        titleLabel.text = entity.name
    }
 
    @objc private func shareWithFacebook() {
        guard let entity = entity else { return }
        delegate?.shareWithFacebook(goal: entity)
    }
    
    @objc private func shareWithEmail() {
        guard let entity = entity else { return }
        delegate?.shareWithEmail(goal: entity)
    }
    
    @objc private func download() {
        guard let entity = entity else { return }
        delegate?.download(goal: entity)
    }
    
}
