//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//  Modified by Jiayang Miao on 24/10/2016 to support Swift 3
//  Modified by David Luque on 24/01/2018 to get default date
//

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [String]!
    var years: [Int]!
    var selectDate: Date!
    
    let formatter = DateFormatter()
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.firstIndex(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    typealias block = ((_ date: Date) -> Void)
    
    var onDateSelected: block?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func dateSelected(currentDate: Date, dateSelected: @escaping block) {
        selectDate = currentDate
        onDateSelected = dateSelected
        
        let year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: currentDate)
        let month = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: currentDate)
        let monthStr = formatter.monthSymbols[month].capitalized
        
        guard let yearIndex = self.years.firstIndex(of: year) else {
            return
        }
        guard let monthIndex = self.months.firstIndex(of: monthStr) else {
            return
        }
        
        self.selectRow(monthIndex - 1, inComponent: 0, animated: false)
        self.selectRow(yearIndex, inComponent: 1, animated: false)
    }
    
    func commonSetup() {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2000 01 01")!
        //let endDate = formatter.date(from: "2030 02 01")!
        
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: startDate)
            for _ in 1...30 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(formatter.monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: Date())
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // MARK:- UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let dateString : String
        
        switch component {
        case 0:
            dateString = months[row]
        case 1:
            dateString = String(years[row])
        default:
            return nil
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let myTitle = NSAttributedString(string: dateString, attributes:
            [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 23.0)!,
             NSAttributedString.Key.paragraphStyle: paragraph])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 150
        case 1:
            return 80
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            
            let dateString = "\(year) \(month)"
            formatter.dateFormat = "yyyy MM"
            let date = formatter.date(from: dateString) ?? Date()
            block(date)
        }
        
        self.month = month
        self.year = year
    }
    
}
