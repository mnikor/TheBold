//
//  NavigationView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

@objc protocol NavigationBottomViewDelegate : class {
    func tapLeftButton()
    @objc optional func tapRightButton()
}

enum NavigationBarType {
    case none
    case showMenu
    case back
    case callendar
}

enum NavigationTitleImageType {
    case none
    case info
    
    func image() -> UIImage {
        switch self {
        case .info:
            return Asset.infoIcon.image
        default:
            return UIImage()
        }
    }
}

class NavigationBottomView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationItem: UINavigationItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    weak var deleagte : NavigationBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NavigationView", owner: self)
        contentView.fixInView(self)
        backgroundColor = .clear
        navigationBar.shadowImage = UIImage()
        titleImageView.isHidden = true
    }

    func configItem(title: String, titleImage: NavigationTitleImageType, leftButton: NavigationBarType, rightButton: NavigationBarType) {
        
        titleLabel.text = title
        
        navigationItem.leftBarButtonItem = createBarButtonItem(type: leftButton, right: false)
        
        if rightButton != .none {
            navigationItem.rightBarButtonItem = createBarButtonItem(type: rightButton, right: true)
        }
        
        if titleImage != .none {
            titleImageView.isHidden = false
            titleImageView.image = titleImage.image()
        }
        
    }
    
    func createBarButtonItem(type: NavigationBarType, right: Bool = false) -> UIBarButtonItem {
        
        var image : UIImage
        
        switch type {
        case .showMenu:
            image = Asset.menuIcon.image
        case .callendar:
            image = Asset.calendarBlueIcon.image
        case .back:
            image = Asset.arrowBack.image
        default:
            image = UIImage()
        }
        
        return UIBarButtonItem(image: image, style: .plain, target: self, action: right ? #selector(tapLeftItem(_:)) : #selector(tapLeftItem(_:)))
        
    }
    
    @objc func tapRightItem(_ sender: UIBarButtonItem) {
        deleagte?.tapRightButton!()
    }
    
    @objc func tapLeftItem(_ sender: UIBarButtonItem) {
        deleagte?.tapLeftButton()
    }
    
}
