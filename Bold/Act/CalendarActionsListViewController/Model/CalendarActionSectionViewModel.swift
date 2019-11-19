//
//  CalendarActionSectionViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

struct CalendarActionSectionViewModel {
    
    var type: ActHeaderType!
    let date: Date!
    let title: String?
    let subtitle: String?
    let backgroundColor: Color
    let imageButton: UIImage?
    var rightButtonIsHidden : Bool
}
