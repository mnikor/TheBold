//
//  ProgressHeaderView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ProgressHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProgressHeaderView", owner: self)
        contentView.fixInView(self)
        backgroundColor = .clear
        config()
    }
    
    func config() {
        progressView.progress = 0.75
        titleLabel.text = L10n.Feel.apprentice
        pointsLabel.text = "345"
        pointsImageView.image = Asset.feelShape.image
    }

}
