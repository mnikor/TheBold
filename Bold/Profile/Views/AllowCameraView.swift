//
//  AllowCameraView.swift
//  Bold
//
//  Created by Admin on 04.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol AllowCameraViewDelegate: class {
    func allowCameraViewDidTapAtNoButton()
    func allowCameraViewDidTapAtYesButton()
}

class AllowCameraView: UIView {
    weak var delegate: AllowCameraViewDelegate?

    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    private func configureSubviews() {
        noButton.setTextColor(UIColor(red: 69/255, green: 98/255, blue: 205/255, alpha: 1))
        yesButton.backgroundColor = UIColor(red: 69/255, green: 98/255, blue: 205/255, alpha: 1)
        yesButton.cornerRadius()
        yesButton.shadow()
    }
    
    static func loadFromNib() -> AllowCameraView {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! AllowCameraView
        nibView.configureSubviews()
        return nibView
    }
    
    @IBAction func didTapAtNoButton(_ sender: UIButton) {
        delegate?.allowCameraViewDidTapAtNoButton()
    }
    
    @IBAction func didTapAtYesButton(_ sender: UIButton) {
        delegate?.allowCameraViewDidTapAtYesButton()
    }
    
}
