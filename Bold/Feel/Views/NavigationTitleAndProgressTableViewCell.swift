//
//  NavigationTitleAndProgressTableViewCell.swift
//  Bold
//
//  Created by Denis Grishchenko on 5/29/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import UIKit

class NavigationTitleAndProgressTableViewCell: BaseTableViewCell {
    
    // MARK: - IBOUTLETS -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var progressView: ProgressHeaderView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    
    // MARK: - INIT -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        
    }
    
    // MARK: - SETUP VIEW -
    
    private func setupView() {
        infoButton.isHidden = true
    }
}
