//
//  CalendarActionSectionModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarActionSectionModel: NSObject, Comparable {
    
    static func < (lhs: CalendarActionSectionModel, rhs: CalendarActionSectionModel) -> Bool {
        return lhs.section.date < rhs.section.date
    }
    
    var section: CalendarActionSectionViewModel
    var items: [CalendarActionItemModel] 
    
//    init(type:ActHeaderType = .none, date: Date, title: String?, subtitle: String?, backgroundColor:Color = .white, imageButton:UIImage? = nil, rightButtonIsHidden:Bool = false, items:[CalendarActionItemModel]) {
//
//        self.type = type
//        self.date = date
//        self.title = title
//        self.subtitle = subtitle
//        self.backgroundColor = backgroundColor
//        self.imageButton = imageButton
//        self.rightButtonIsHidden = rightButtonIsHidden
//        self.items = items
//    }
    
    init(section: CalendarActionSectionViewModel, items: [CalendarActionItemModel]) {
        self.section = section
        self.items = items
    }
    
}

struct CalendarActionSectionViewModel {
    
    var type: ActHeaderType!
    let date: Date!
    let title: String?
    let subtitle: String?
    let backgroundColor: Color
    let imageButton: UIImage?
    var rightButtonIsHidden : Bool
    //let items: [CalendarActionItemModel]
}

struct RangeDatePeriod {
    var start: Date!
    var end: Date!
    
    static func initRange(date: Date) -> RangeDatePeriod {
        
        let startDate = date.customTime(hour: 0, minute: 0)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: startDate)
        let firstDayMonthDate = calendar.date(from: components)!
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: firstDayMonthDate)!
        return RangeDatePeriod(start: startDate, end: endDate)
    }
    
    func addOneMonthToRange() -> RangeDatePeriod {
        
        let startDate = self.end
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: self.end)!
        return RangeDatePeriod(start: startDate, end: endDate)
    }
    
}
