//
//  ActSectionViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 10/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActSectionModelType: Equatable {
    static func == (lhs: ActSectionModelType, rhs: ActSectionModelType) -> Bool {
        
        switch (lhs, rhs) {
            case (.goal, .goal):
                return true
            case let (.calendar(v0), .calendar(v1)):
                return v0.title == v1.title
            case let (.stake(v0), .stake(v1)):
                return v0.title == v1.title
            default:
                return false
        }
    }
    
    case goal
    case calendar(viewModel: CalendarActionSectionViewModel)
    case stake(viewModel: CalendarActionSectionViewModel)
}

enum CalendarModelType {
    case calendar(dates: Set<Date>)
    case event(viewModel: StakeActionViewModel)
    case goals(viewModel: ActivityViewModel)
}

struct ActDataSourceViewModel: Equatable {
    static func == (lhs: ActDataSourceViewModel, rhs: ActDataSourceViewModel) -> Bool {
        lhs.section == rhs.section
    }
    
    var section : ActSectionModelType
    var items : [CalendarModelType]
}
