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
}

//struct ActSectionViewModel {
//    let section : ActSectionModelType
    //let items : [CalendarActionItemModel]
//}

typealias ActDataSourceItem = (section: ActSectionModelType, items: [CalendarModelType])
