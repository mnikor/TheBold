//
//  HeaderCalendarView.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol HeaderCalendarViewDelegate: class {
    func tapMonthTitleButton(date: Date)
}

class HeaderCalendarView: JTACMonthReusableView {
    
    @IBOutlet weak var monthTitleButton: UIButton!
    
    weak var delegate: HeaderCalendarViewDelegate?
    private var date : Date!
    
    @IBAction func tapMonthTitleButton(_ sender: UIButton) {
        delegate?.tapMonthTitleButton(date: date)
    }
    
    func config(date: Date, formatter: DateFormatter) {
    
        self.date = date
        formatter.dateFormat = "MMMM "
        let month = formatter.string(from: date)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        let titleAttr = NSMutableAttributedString()
        
        guard let monthFont = FontFamily.MontserratSemiBold.regular.font(size: 24) else { return }
        guard let yearFont = FontFamily.Montserrat.regular.font(size: 24) else { return }
        
        titleAttr.append(NSAttributedString(string: month, attributes: [NSAttributedString.Key.font : monthFont]))
        titleAttr.append(NSAttributedString(string: year, attributes: [NSAttributedString.Key.font : yearFont]))
        
        monthTitleButton.setAttributedTitle(titleAttr, for: .normal)
        monthTitleButton.positionImageAfterText(padding: 15)
    }
    
    class func Identifier() -> String {
        return String(describing: self)
    }
}
