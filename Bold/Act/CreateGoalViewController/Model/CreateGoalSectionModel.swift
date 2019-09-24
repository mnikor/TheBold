//
//  CreateGoalSectionModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CreateGoalSectionModel: NSObject {

    var title: String?
    var items: [CreateGoalActionModel]
    
    init(title: String?, items: [CreateGoalActionModel]) {
        self.title = title
        self.items = items
    }
}
