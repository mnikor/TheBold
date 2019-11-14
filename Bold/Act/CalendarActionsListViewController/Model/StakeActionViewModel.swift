//
//  StakeActionViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

struct StakeActionViewModel {
    
    let statusIcon: UIImage
    let statusIconColor: Color
    let title: String?
    let contentName: String?
    let contentNameIsHidden: Bool
    let stake: String?
    let stakeColor: Color
    let points: String?
    let event: Event
    
    static func createModelView(event: Event) -> StakeActionViewModel {
        
        var statusIcon = UIImage()
        var statusIconColor = ColorGoalType(rawValue: event.action?.goal?.color ?? 0)?.colorGoal() ?? .red
        let title  = event.name
        var contentName : String?
        var stake = L10n.Act.stakeDollar(NumberFormatter.stringForCurrency(event.stake))
        var stakeColor = ColorName.typographyBlack75.color
        var points: String?
        var contentNameIsHidden = true
        
        if let content = event.action?.content {
            contentName = content.title
            contentNameIsHidden = false
        }
        
        if case .failed? = StatusType(rawValue: event.status) {
            statusIconColor = ColorGoalType.red.colorGoal()
            statusIcon = Asset.stakeOval.image
            stake = L10n.Act.missed
            stakeColor = ColorGoalType.red.colorGoal()
            points = "-\(event.calculatePoints)"
        }else if case .wait? = StatusType(rawValue: event.status) {
            points = "+\(event.calculatePoints)"
            statusIcon = Asset.stakeOval.image
        }
        
        if event.action?.content != nil {
            statusIcon = Asset.stakePlay.image
        }

        return StakeActionViewModel(statusIcon: statusIcon, statusIconColor: statusIconColor, title: title, contentName: contentName, contentNameIsHidden: contentNameIsHidden, stake: stake, stakeColor: stakeColor, points: points, event: event)
    }
}

