//
//  Action.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class Action: NSObject {

    var name: String?
    var duration: Date!
    var reminder: Date!
    var goal: Goal!
    var stake: Double!
    
    init(name: String?, duration: Date, reminder: Date, goal: Goal, stake: Double) {
        self.name = name
        self.duration = duration
        self.reminder = reminder
        self.goal = goal
        self.stake = stake
    }
}
