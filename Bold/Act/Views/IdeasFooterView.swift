//
//  IdeasFooterView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol IdeasFooterViewDelegate: class {
    func tapCancelButton()
}

class IdeasFooterView: UIView {

    @IBOutlet weak var cancelButton: UIButton!

    weak var delegate: IdeasFooterViewDelegate?
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        
        delegate?.tapCancelButton()
    }
    
}
