//
//  ActSectionViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 10/7/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActSectionModelType {
    case goal
    case calendar(viewModel: CalendarActionSectionViewModel)
    case stake(viewModel: CalendarActionSectionViewModel)
}

enum CalendarModelType {
    case calendar(dates: Set<Date>)
    case event(viewModel: StakeActionViewModel)
    case goals(viewModel: ActivityViewModel)
}

struct ActDataSourceViewModel {
    var section : ActSectionModelType
    var items : [CalendarModelType]
}
