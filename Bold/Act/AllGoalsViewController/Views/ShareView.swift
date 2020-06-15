//
//  ShareView.swift
//  Bold
//
//  Created by Admin on 14.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ShareViewDelegate: class {
    func shareWithFacebook(goal: Action)
    func shareWithEmail(goal: Action)
    func download(goal: Action)
}

class ShareView: UIView {
    weak var delegate: ShareViewDelegate?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var downloadView: UIView!
    
    private var entity: Goal?
    private var action: Action?
    
    private func configureSubviews() {
        
        backgroundImageView.layer.cornerRadius = 30
        
        facebookView.layer.borderWidth = 0.3
        emailView.layer.borderWidth = 0.3
        downloadView.layer.borderWidth = 0.3
        
        facebookView.layer.borderColor = UIColor.lightGray.cgColor
        emailView.layer.borderColor = UIColor.lightGray.cgColor
        downloadView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    func configure(with action: Action) {
        self.action = action
        titleLabel.text = action.name
        backgroundImageView.backgroundColor = ColorGoalType(rawValue: action.goal!.color)?.colorGoal()
    }
 
    @IBAction private func shareWithFacebook() {
        guard let action = action else { return }
        delegate?.shareWithFacebook(goal: action)
    }
    
    @IBAction private func shareWithEmail() {
        guard let action = action else { return }
        delegate?.shareWithEmail(goal: action)
    }
    
    @IBAction private func download() {
        guard let action = action else { return }
        delegate?.download(goal: action)
    }
    
}
