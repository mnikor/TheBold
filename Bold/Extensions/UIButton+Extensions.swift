//
//  UIButton+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func positionImageBegginingButton() {
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width/2 + 10)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
    
    func positionImageAfterText(padding: CGFloat) {
        if let imageView = imageView, let titleLabel = titleLabel {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: titleLabel.frame.size.width+padding, bottom: 5, right: -titleLabel.frame.size.width-padding)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView.frame.width, bottom: 0, right: imageView.frame.width)
        }
    }
    
    func positionImageBeforeText(padding: CGFloat) {
        if let _ = imageView, let _ = titleLabel {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: -padding/2, bottom: 5, right: padding/2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: padding/2, bottom: 0, right: -padding/2)
        }
    }
    
    func cornerRadius() {
        layer.cornerRadius = bounds.size.height / 2
    }
    
    func borderWidth() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 241/255, green: 241/255, blue: 244/255, alpha: 1.0).cgColor //hex color F1F1F4
    }
    
    func shadow() {
        self.layer.shadowPath = nil
        self.layer.shadowOpacity = 0
        layer.shadowColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.33).cgColor //hex color BEBEBE
        layer.shadowRadius = bounds.size.height / 2
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 2)

        layer.masksToBounds = false
    }
    
    func rightImageInButton() {
        guard let imageInButton = imageView else {
            return
        }
        imageEdgeInsets = UIEdgeInsets(top: 0, left: bounds.size.width - imageInButton.bounds.size.width, bottom: 0, right: 0)
    }
    
    func leftTitleInButton() {
        guard let _ = titleLabel else {
            return
        }
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
