//
//  CustomDotsPageControl.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/10/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CustomDotsPageControl: UIPageControl {

    var currentPageImage: UIImage?
    var otherPagesImage: UIImage?
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
        currentPageImage = Asset.activePageControl.image
        otherPagesImage = Asset.inactivePageControl.image
    }
    
    private func updateDots() {
        
        for (index, subview) in subviews.enumerated() {
            let imageView: UIImageView
            if let existingImageview = getImageView(forSubview: subview) {
                imageView = existingImageview
            } else {
                imageView = UIImageView(image: otherPagesImage)
                
                imageView.center = subview.center
                subview.addSubview(imageView)
                subview.clipsToBounds = false
            }
            imageView.image = currentPage == index ? currentPageImage : otherPagesImage
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
                } as? UIImageView
            
            return view
        }
    }

}
