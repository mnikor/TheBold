//
//  RangeDatePeriod.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

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
