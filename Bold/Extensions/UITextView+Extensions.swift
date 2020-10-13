//
//  UITextView+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 08.10.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func removeInsets() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
}
