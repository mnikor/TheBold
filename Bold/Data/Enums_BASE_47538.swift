//
//  Enums.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum StatusType: Int16 {
    case create = 0
    case update
    case wait
    case completed
    case completeUpdate
    case failed
    case locked
}

enum ColorGoalType: Int16 {
    case none = 0
    case orange
    case red
    case blueDark
    case green
    case yellow
    case blue
    
    func colorGoal() -> UIColor {
        switch self {
        case .orange:
            return ColorName.primaryOrange.color
        case .red:
            return ColorName.primaryRed.color
        case .blueDark:
            return ColorName.secondaryBlue.color
        case .green:
            return ColorName.secondaryTurquoise.color
        case .yellow:
            return ColorName.secondaryYellow.color
        case .blue:
            return ColorName.primaryBlue.color
        default:
            return .white
        }
    }
}

enum IdeasType: Int16 {
    case none = 0
    case marathon
    case triathlon
    case charityProject
    case writeBook
    case quitSmoking
    case publicSpeech
    case skyDiving
    case launchStartUp
    case competeToWin
    case startNewProject
    case killProject
    case findNewJob
    case makeDiscovery
    case inventSomething
    case income
    case masterSkill
    
    func iconImage() -> UIImage? {
        switch self {
        case .marathon:
            return Asset.marathon.image
        case .triathlon:
            return Asset.triathlon.image
        case .charityProject:
            return Asset.emotional.image
        case .writeBook:
            return Asset.writeBook.image
        case .quitSmoking:
            return Asset.smoking.image
        case .publicSpeech:
            return Asset.publicSpeech.image
        case .skyDiving:
            return Asset.skyDiving.image
        case .launchStartUp:
            return Asset.startUp.image
        case .competeToWin:
            return Asset.completeToWin.image
        case .startNewProject:
            return Asset.startNewProject.image
        case .killProject:
            return Asset.killProject.image
        case .findNewJob:
            return Asset.findJob.image
        case .makeDiscovery:
            return Asset.makeDiscovery.image
        case .inventSomething:
            return Asset.inventSomethings.image
        case .income:
            return Asset.income.image
        case .masterSkill:
            return Asset.masterSkill.image
        default:
            return nil
        }
    }
    
    func titleText() -> String? {
        switch self {
        case .marathon:
            return L10n.Act.Ideas.marathon
        case .triathlon:
            return L10n.Act.Ideas.triathlon
        case .charityProject:
            return L10n.Act.Ideas.charityProject
        case .writeBook:
            return L10n.Act.Ideas.writeBook
        case .quitSmoking:
            return L10n.Act.Ideas.quitSmoking
        case .publicSpeech:
            return L10n.Act.Ideas.publicSpeech
        case .skyDiving:
            return L10n.Act.Ideas.skyDiving
        case .launchStartUp:
            return L10n.Act.Ideas.launchStartUp
        case .competeToWin:
            return L10n.Act.Ideas.competeToWin
        case .startNewProject:
            return L10n.Act.Ideas.startNewProject
        case .killProject:
            return L10n.Act.Ideas.killProject
        case .findNewJob:
            return L10n.Act.Ideas.findNewJob
        case .makeDiscovery:
            return L10n.Act.Ideas.makeDiscovery
        case .inventSomething:
            return L10n.Act.Ideas.inventSomething
        case .income:
            return L10n.Act.Ideas.income
        case .masterSkill:
            return L10n.Act.Ideas.masterSkill
        default:
            return nil
        }
    }
}

enum AddActionCellType {
    case headerAddToPlan
    case headerEditAction
    case headerWriteActivity
    case duration
    case reminder
    case goal
    case stake
    case share
    case starts
    case ends
    case color
    case colorList
    case icons
    case iconsList
    case when
    case none
    
    func iconType() -> UIImage? {
        switch self {
        case .duration:
            return Asset.addActionDuration.image
        case .reminder:
            return Asset.addActionReminder.image
        case .goal:
            return Asset.addActionGoal.image
        case .stake:
            return Asset.addActionStake.image
        case .share:
            return Asset.addActionShare.image
        case .starts, .when:
            return Asset.addActionStartTime.image
        case .ends:
            return Asset.addActionEndTime.image
        case .color:
            return Asset.addActionColor.image
        case .icons:
            return Asset.addActionIcons.image
        default :
            return nil
        }
    }
    
    func textType() -> String? {
        switch self {
        case .duration:
            return L10n.Act.duration
        case .reminder:
            return L10n.Act.reminder
        case .goal:
            return L10n.Act.goal
        case .stake:
            return L10n.Act.stake
        case .share:
            return L10n.Act.shareWithFriends
        case .starts:
            return L10n.Act.starts
        case .ends:
            return L10n.Act.ends
        case .color:
            return L10n.Act.color
        case .icons:
            return L10n.Act.icons
        case .when:
            return L10n.Act.when
        default :
            return nil
        }
    }
    
    func hideValue() -> Bool {
        switch self {
        case .share, .icons:
            return true
        default:
            return false
        }
    }
    
    func hideAccessoryIcon() -> Bool {
        switch self {
        case .icons:
            return true
        default:
            return false
        }
    }
    
}

enum ConfigureActionType {
    case header(HeaderType)
    case body(BodyType)
    
    enum HeaderType {
        case startDate
        case endDate
        case repeatAction
        case remindMe
        case when
        case chooseGoal
        case orCreateNew
        
        func titleText() -> String {
            switch self {
            case .startDate:
                return L10n.Act.Duration.startDate
            case .endDate:
                return L10n.Act.Duration.endDate
            case .repeatAction:
                return L10n.Act.Duration.repeat
            case .remindMe:
                return L10n.Act.Reminders.remindMe
            case .when:
                return L10n.Act.Reminders.when
            case .chooseGoal:
                return L10n.Act.Goals.chooseGoal
            case .orCreateNew:
                return L10n.Act.Goals.orCreateNew
            }
        }
    }
    
    enum BodyType {
        case today
        case tommorowStartDate
        case tommorowEndDate
        case chooseStartDate
        case chooseEndDate
        case afterOneWeek
        case noRepeat
        case everyDay
        case daysOfWeek
        case week
        case noReminders
        case beforeTheDay
        case onTheDay
        case setTime
        case goalName
        case goalNameSelect
        case enterGoal
        case none
        
        func titleText() -> String {
            switch self {
            case .today:
                return L10n.Act.Duration.today
            case .tommorowStartDate, .tommorowEndDate:
                return L10n.Act.Duration.tommorow
            case .chooseStartDate, .chooseEndDate:
                return L10n.Act.Duration.chooseDate
            case .afterOneWeek:
                return L10n.Act.Duration.afterOneWeek
            case .noRepeat:
                return L10n.Act.Duration.noRepeat
            case .everyDay:
                return L10n.Act.Duration.everyDay
            case .daysOfWeek:
                return L10n.Act.Duration.daysOfWeek
            case .noReminders:
                return L10n.Act.Reminders.noReminders
            case .beforeTheDay:
                return L10n.Act.Reminders.beforeTheDay
            case .onTheDay:
                return L10n.Act.Reminders.onTheDay
            case .setTime:
                return L10n.Act.Reminders.setTime
            case .enterGoal:
                return L10n.Act.Goals.enterYourGoal
            default:
                return String()
            }
        }
        
        func accesoryIsHidden() -> Bool {
            switch self {
            case .chooseStartDate, .chooseEndDate, .daysOfWeek, .setTime:
                return false
            default:
                return true
            }
        }
        
        func currentValueIsHidden() -> Bool {
            switch self {
            case .today:
                return false
            default:
                return true
            }
        }
    }
}

enum ActionDateType: Int16{
    case today = 0
    case tommorow
    case afterOneWeek
    case chooseDate
}

enum RemindMeType: Int16 {
    case noReminders = 0
    case beforeTheDay
    case onTheDay
}

enum DaysOfWeekType : Int{
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var shortText : String {
        switch self {
        case .monday:
            return L10n.Act.Duration.Day.mo
        case .tuesday:
            return L10n.Act.Duration.Day.tu
        case .wednesday:
            return L10n.Act.Duration.Day.we
        case .thursday:
            return L10n.Act.Duration.Day.th
        case .friday:
            return L10n.Act.Duration.Day.fr
        case .saturday:
            return L10n.Act.Duration.Day.sa
        case .sunday:
            return L10n.Act.Duration.Day.su
        }
    }
    
}

enum BoldAlertType {
    case congratulationsAction1
    case congratulationsAction2
    case goalIsAchievedMadeImportantDecision
    case goalIsAchievedAchievedYourGoal
    case youveMissedYourAction
    case youveMissedYourActionLock
    case dontGiveUpMoveToLaterDate
    case dontGiveUpDeleteGoal
    case dontGiveUpDeleteAction
    case dontGiveUpDeleteStake
    case dontGiveUpDeleteThisTask
    
    var points : Int? {
        switch self {
        case .congratulationsAction1, .congratulationsAction2:
            return PointsForAction.congratulationsAction
        case .goalIsAchievedMadeImportantDecision, .goalIsAchievedAchievedYourGoal:
            return PointsForAction.congratulationsGoal
        case .dontGiveUpMoveToLaterDate:
            return PointsForAction.moveToLaterDate
        case .youveMissedYourActionLock, .youveMissedYourAction:
            return nil
        case .dontGiveUpDeleteGoal:
            return PointsForAction.deleteGoal
        case .dontGiveUpDeleteAction, .dontGiveUpDeleteThisTask:
            return PointsForAction.deleteAction
        case .dontGiveUpDeleteStake:
            return PointsForAction.deleteStake
        }
    }
    
    func icon() -> UIImage {
        switch self {
        case .congratulationsAction1, .congratulationsAction2, .goalIsAchievedAchievedYourGoal, .goalIsAchievedMadeImportantDecision:
            return Asset.clapIcon.image
        case .youveMissedYourActionLock:
            return Asset.lockIcon.image
        case .youveMissedYourAction, .dontGiveUpMoveToLaterDate, .dontGiveUpDeleteGoal, .dontGiveUpDeleteAction, .dontGiveUpDeleteStake, .dontGiveUpDeleteThisTask:
            return Asset.shapeOrangeIcon.image
        }
    }
    
    func titleText() -> String {
        switch self {
        case .congratulationsAction1, .congratulationsAction2:
            return L10n.Alert.congratulations
        case .goalIsAchievedAchievedYourGoal, .goalIsAchievedMadeImportantDecision:
            return L10n.Alert.goalIsAchieved
        case .youveMissedYourActionLock, .youveMissedYourAction:
            return L10n.Alert.youveMissedYourAction
        case .dontGiveUpMoveToLaterDate, .dontGiveUpDeleteGoal, .dontGiveUpDeleteAction, .dontGiveUpDeleteStake, .dontGiveUpDeleteThisTask:
            return L10n.Alert.dontGiveUp
        }
    }
    
    func text() -> String {
        switch self {
        case .congratulationsAction1:
            return L10n.Alert.congratulationsText1
        case .congratulationsAction2:
            return L10n.Alert.congratulationsText2
        case .goalIsAchievedAchievedYourGoal:
            return L10n.Alert.importantDecision
        case .goalIsAchievedMadeImportantDecision:
            return L10n.Alert.goalFantastic
        case .youveMissedYourAction:
            return L10n.Alert.dontGiveUpKeepGoing
        case .youveMissedYourActionLock:
            return L10n.Alert.yourGoalIsLockedNow
        case .dontGiveUpMoveToLaterDate:
            return L10n.Alert.sometimesItsHardToFollowYourPlansLaterDate
        case .dontGiveUpDeleteGoal:
            return L10n.Alert.sometimesGoalsBecomeIrrelevant
        case .dontGiveUpDeleteAction:
            return L10n.Alert.sometimesActionsBecomeIrrelevantAsWeAdaptOurStrategy
        case .dontGiveUpDeleteStake:
            return L10n.Alert.areYouSureYouWantToDeleteThisStake
        case .dontGiveUpDeleteThisTask:
            return L10n.Alert.sometimesItsHardToFollowYourPlansDeleteThisTask
        }
    }
}
