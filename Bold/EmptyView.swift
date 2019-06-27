//
//  EmptyView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/10/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class EmptyView: UIView, Localizable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeContent()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //localizeContent()
    }
    
    func localizeContent() {
        
    }

}
