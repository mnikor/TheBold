//
//  CalendarDecorationView.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDecorationView: JTACMonthReusableView {

    override func layoutSubviews() {
                backgroundColor = .white
                layer.cornerRadius = 32
    }
    
    class func Identifier() -> String {
        return String(describing: self)
    }
}
