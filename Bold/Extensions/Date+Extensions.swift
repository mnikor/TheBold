//
//  Date+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

extension Date {
    
    func baseTime() -> Date {
        return customTime(hour: 12, minute: 00)
    }
    
    func customTime(hour:Int, minute:Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 00, of: self)!
    }
    
    func beforeTheDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!.baseTime()
    }
    
    func tommorowDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!.baseTime()
    }
    
    func afterOneWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!.baseTime()
    }
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
    
    func convertIntToDate(time: Int) -> Date {
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = Date(timeIntervalSince1970: TimeInterval(time)).timeIntervalSince1970
        let timezoneEpochOffset = (epochDate - Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    
    func convertDateToInt() -> Int {
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = self.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Int(timezoneEpochOffset)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func monthOfYear() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: self)
        return calendar.date(from: components)!
    }
    
    func dayOfMonthOfYear() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        return calendar.date(from: components)!
    }
}
