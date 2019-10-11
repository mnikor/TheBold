//
//  CalendarActionSectionModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CalendarActionSectionModel: NSObject, Comparable {
    
    var section: CalendarActionSectionViewModel
    var items: [CalendarActionItemModel]
    
    init(section: CalendarActionSectionViewModel, items: [CalendarActionItemModel]) {
        self.section = section
        self.items = items
    }
    
    static func < (lhs: CalendarActionSectionModel, rhs: CalendarActionSectionModel) -> Bool {
        return lhs.section.date < rhs.section.date
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
    
    func checkEndDates(endGoalDate: Date?) -> Bool {
        if endGoalDate == nil {
            return self.start > GlobalConstants.LimitDate.maxDate!
        }
        return self.start > endGoalDate!
    }
    
}
