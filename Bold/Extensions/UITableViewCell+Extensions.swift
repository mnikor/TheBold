//
//  UITableViewCell+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func cellBackground(indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            self.backgroundColor = ColorName.cellEvenColor.color
        }else {
            self.backgroundColor = .white
        }
    }
}
