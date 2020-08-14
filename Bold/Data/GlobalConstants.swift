//
//  GlobalConstants.swift
//  Bold
//
//  Created by Alexander Kovalov on 10/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

struct GlobalConstants {
    
    struct LimitDate {
        static let minDate = DateFormatter.formatting(type: .compareDateEvent, dateString: "01/01/2019")
        static let maxDate = DateFormatter.formatting(type: .compareDateEvent, dateString: "01/01/2031")
    }
    
    static let appURL = "https://apps.apple.com/be/app/bold-strong-smart-mind/id1491187912"
    static let isBoldManifest = "isBoldManifestPlayed"
    
}
