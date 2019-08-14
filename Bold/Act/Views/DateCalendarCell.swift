//
//  DateCalendarCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCalendarCell: JTACDayCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectView.layer.cornerRadius = 12
        dotView.layer.cornerRadius = dotView.bounds.size.height / 2
    }
    
    class func Identifier() -> String {
        return String(describing: self)
    }
    
}
