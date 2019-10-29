//
//  CalendarCustomError.swift
//  Bold
//
//  Created by Admin on 9/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarCustomError {
    case calendarAccessDeniedOrRestricted
    case eventAlreadyExistsInCalendar
    case eventDoesntExistsInCalendar
    case eventNotAddedToCalendar
    case eventNotRemovedFromCalendar
}
