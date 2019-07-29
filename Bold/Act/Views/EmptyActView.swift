//
//  EmptyActView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/18/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class EmptyActView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    class func loadFromNib() -> EmptyActView {

        let emptyView: EmptyActView = Bundle.main.loadNibNamed("EmptyActView", owner: self, options: nil)?.first as! EmptyActView
        return emptyView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.text = L10n.Act.hopefullyEmptyText
    }
}
