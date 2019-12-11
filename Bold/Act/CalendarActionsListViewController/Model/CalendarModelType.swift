//
//  CalendarModelType.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CalendarModelType213 {
    case calendar(dates: Set<Date>)
    case event(viewModel: StakeActionViewModel)
    case goals(viewModel: ActivityViewModel)
}
