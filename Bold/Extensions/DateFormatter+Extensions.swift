//
//  DateFormatter+Extension.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum DateType : String {
    case createGoalOrAction = "E, d MMM, yyyy"
    case configureAction = "EEEE, d MMMM"
    case select = "EEEE, d MMM"
    case headerGroup = "d MMMM, yyyy"
    case timeAction = "h:mm a"
    case startOrEndDate = "MM/dd/yyyy hh:mm a"
    case goalDueDate = "d MMM, yyyy"
    case compareDateEvent = "dd/MM/yyyy"
    case headerSomeDayEvent = "d MMMM"
    case calendar = "yyyy MM dd"
    case contentUpdateAt = "yyyy-MM-dd HH:mm:ss" //"2020-10-17 07:31:04"
}

extension DateFormatter {
    
    class func formatting(type: DateType, date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
    
    class func formatting(type: DateType, dateString: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: dateString)
    }
}
