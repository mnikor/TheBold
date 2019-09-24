//
//  HeaderConfigureTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/30/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class HeaderConfigureTableViewCell: BaseTableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    func config(modelView: ConfigureActionModelType) {

        switch modelView {
        case .header(let titleText):
            headerLabel.text = titleText
        default:
            return
        }
    }
}
