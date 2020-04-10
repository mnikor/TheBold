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
    let title: NSAttributedString?
    let contentName: String?
    let contentNameIsHidden: Bool
    let stake: String?
    let stakeColor: Color
    let points: String?
    let event: Event
    
    static func createModelView(event: Event) -> StakeActionViewModel {
        
        var statusIcon = UIImage()
        var statusIconColor = ColorGoalType(rawValue: event.action?.goal?.color ?? ColorGoalType.none.rawValue)?.colorGoal() ?? .red
        var title : NSMutableAttributedString?
        if let nameTitle = event.name {
            title = NSMutableAttributedString(string: nameTitle)
        }
        var contentName : String?
        var stake = L10n.Act.stakeDollar(NumberFormatter.stringForCurrency(event.stake))
        var stakeColor = ColorName.typographyBlack75.color
        var points: String?
        var contentNameIsHidden = true
        
        if case .failed? = StatusType(rawValue: event.status) {
            statusIconColor = ColorGoalType.red.colorGoal()
            statusIcon = Asset.stakeOval.image
            stake = L10n.Act.missed
            stakeColor = ColorGoalType.red.colorGoal()
            points = "-\(event.calculatePoints)"
            
        }else {
            points = "+\(event.calculatePoints)"
            statusIcon = Asset.stakeOval.image
            if case .completed? = StatusType(rawValue: event.status), let titleTemp = title{
                
                if event.startDate == Date().baseTime() as NSDate {
                    title?.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, titleTemp.length))
                }
                
            }
        }
        
        if let content = event.action?.content {
            contentName = content.title
            contentNameIsHidden = false
            statusIcon = Asset.stakePlay.image
        }

        return StakeActionViewModel(statusIcon: statusIcon, statusIconColor: statusIconColor, title: title, contentName: contentName, contentNameIsHidden: contentNameIsHidden, stake: stake, stakeColor: stakeColor, points: points, event: event)
    }
}

