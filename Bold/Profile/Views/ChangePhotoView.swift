//
//  ChangePhotoView.swift
//  Bold
//
//  Created by Admin on 01.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ChangePhotoViewDelegate: class {
    func changePhotoViewDidTapAtChoosePhotoButton()
    func changePhotoViewDidTapAtMakeAPhotoButton()
}

class ChangePhotoView: UIView {
    weak var delegate: ChangePhotoViewDelegate?
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var makeAPhotoButton: UIButton!
    
    private func configureSubviews() {
        choosePhotoButton.cornerRadius()
        choosePhotoButton.shadow()
        makeAPhotoButton.layer.borderWidth = 0.3
        makeAPhotoButton.layer.borderColor = UIColor(red: 118/255, green: 126/255, blue: 150/255, alpha: 1).cgColor
        makeAPhotoButton.cornerRadius()
        makeAPhotoButton.shadow()
    }
    
    static func loadFromNib() -> ChangePhotoView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! ChangePhotoView
        nibView.configureSubviews()
        return nibView
    }

    @IBAction func didTapAtChoosePhotoButton(_ sender: UIButton) {
        delegate?.changePhotoViewDidTapAtChoosePhotoButton()
    }
    
    @IBAction func didTapAtMakeAPhotoButton(_ sender: UIButton) {
        delegate?.changePhotoViewDidTapAtMakeAPhotoButton()
    }
    
}
