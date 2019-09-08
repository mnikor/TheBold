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
    case paramsAction = "EEEE, d MMMM"
    case select = "EEEE, d MMM"
    case headerGroup = "d MMMM, yyyy"
}

extension DateFormatter {
    
    class func formatting(type: DateType, date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
    
}
