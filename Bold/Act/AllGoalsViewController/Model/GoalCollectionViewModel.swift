//
//  AllGoalsViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

struct GoalCollectionViewModel {
    
    let goal: Goal!
    
    let progressTintColor: Color
    let iconColor: Color
    let backgroundColor: Color
    let titleTextColor: Color
    let dueDateTextColor: Color
    let progressTextColor: Color
    
    let icon: UIImage
    let title: String?
    let dueDate: String
    let progress: Float
    let isHiddenCompletedIcon: Bool
    let completedIcon: UIImage?
    let progressText: String
    
    static func createGoalModel(goal: Goal) -> GoalCollectionViewModel {
        
        var icon = IdeasType(rawValue: goal.icon)?.iconImage() ?? UIImage()
        
        let progressTintColor = ColorGoalType(rawValue: goal.color)?.colorGoal() ?? .white
        var iconColor = progressTintColor
        var backgroundColor = Color.white
        var titleTextColor = ColorName.typographyBlack100.color
        var dueDateTextColor = ColorName.typographyBlack50.color
        var progressTextColor = ColorName.typographyBlack75.color
        
        let title = goal.name
        let dueDate = L10n.Act.dueOn + " " + DateFormatter.formatting(type: .goalDueDate, date: goal.endDate! as Date)
        var completedEvent : Int = 0
        var countEvent : Int = 0
        var completedIcon: UIImage?
        
        let result = DataSource.shared.searchAllEventsInGoal(goalID: goal.id!)
        
        let active = result.filter { (event) -> Bool in
            
            switch StatusType(rawValue: event.status) {
            case .completed?: return true
            default:
                return false
            }
        }
        
        completedEvent = active.count
        countEvent = result.count
        
        var progressText = L10n.Act.toCompleted("\(completedEvent)", "\(countEvent)")
        let progress = countEvent == 0 ? Float(countEvent) : Float(completedEvent)/Float(countEvent)
        
        switch StatusType(rawValue: goal.status) ?? StatusType.locked {
        case .wait, .create, .update:
            completedIcon = nil
        case .locked:
            icon = Asset.goalLockIcon.image
            backgroundColor = progressTintColor
            iconColor = .white
            titleTextColor = .white
            dueDateTextColor = .white
            progressTextColor = .white
            progressText = L10n.Act.goalIsLocked
            completedIcon = nil
        case .completed:
            completedIcon = Asset.completedIcon.image
            progressText = L10n.Profile.ArchivedGoals.completed
        case .failed:
            completedIcon = Asset.failedIcon.image
            progressText = L10n.Profile.ArchivedGoals.failed
        }
        
        let isHiddenCompletedIcon = completedIcon == nil ? true : false
        
        return GoalCollectionViewModel(goal: goal, progressTintColor: progressTintColor, iconColor: iconColor, backgroundColor: backgroundColor, titleTextColor: titleTextColor, dueDateTextColor: dueDateTextColor, progressTextColor: progressTextColor, icon: icon, title: title, dueDate: dueDate, progress: progress, isHiddenCompletedIcon: isHiddenCompletedIcon, completedIcon: completedIcon, progressText: progressText)
    }
}
