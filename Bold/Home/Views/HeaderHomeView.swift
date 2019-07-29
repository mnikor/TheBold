//
//  HeaderHomeView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class HeaderHomeView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var yourProgressLabel: UILabel!
    @IBOutlet weak var apprenticeLabel: UILabel!
    @IBOutlet weak var masteryLabel: UILabel!
    @IBOutlet weak var currentPointsLabel: UILabel!
    @IBOutlet weak var iconPointImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var boldnessLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("HeaderHomeView", owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.frame;
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //contentView.fixInView(self)
    }
    
//    class func loadFromNib() -> HeaderHomeView {
//        let headerView: HeaderHomeView = Bundle.main.loadNibNamed("HeaderHomeView", owner: self, options: nil)?.first as! HeaderHomeView
//        return headerView
//    }
}
