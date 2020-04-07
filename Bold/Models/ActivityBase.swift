//
//  ActivityBase.swift
//  Bold
//
//  Created by Alexander Kovalov on 24.03.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

class ActivityBase {
    var id: Int
    var position : Int
    var type : ContentType
    
    init(id: Int, position: Int, type: ContentType) {
        self.id = id
        self.position = position
        self.type = type
    }
}
