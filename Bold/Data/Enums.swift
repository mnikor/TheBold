//
//  Enums.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum StatusType: Int {
    case wait = 0
    case completed
    case failed
    case block
}

enum ColorGoalType: Int {
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

enum IdeasType: Int {
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
        case .starts:
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
