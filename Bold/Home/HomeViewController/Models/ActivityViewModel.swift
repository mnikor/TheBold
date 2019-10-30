//
//  ActivityViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 10/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

class HomeEntity: NSObject {
    
    var type : HomeActionsTypeCell
    var items : Array<Any>?
    
    init(type: HomeActionsTypeCell, items: Array<Any>?) {
        self.type = type
        self.items = items
    }
}


struct ActivityViewModel {
    
    let type: HomeActionsTypeCell
    let rowHeight: CGFloat
    let bottomCellHeight: CGFloat
    let collectionCellSize: CGSize
    let image: UIImage?
    let imageIsHidden: Bool
    let title: String
    let subtitle: String
    let titleButton: String?
    let enabledButton: Bool
    let imageButton: UIImage
    let items: [ActivityItemsViewModel]
    
    static func createViewModel(type: HomeActionsTypeCell) {
        
    }
    
    static func createViewModel(type: HomeActionsTypeCell, goals:[GoalCollectionViewModel], content: [ContentViewModel] , itemCount: Int) -> ActivityViewModel {
        
        //let type = HomeActionsTypeCell.activeGoals
        var enabledButton : Bool
        var titleButton : String?
        var imageButton : UIImage
        var imageIcon : UIImage?
        var imageIsHidden : Bool = false
        var titleText : String!
        var subtitleText : String!
        var items = [ActivityItemsViewModel]()
        
//        let calendarType = ActHeaderType.hide
//        let calendarTitle = L10n.Act.activeGoals
//        let calendarSubtitle = L10n.Act.youHaveActionWithStakes("\(itemCount)")
        
        switch type {
        case .actNotActive :
            enabledButton = false
            titleButton = nil
            imageButton = Asset.plusIcon.image
        case .actActive :
            enabledButton = false
            titleButton = nil
            imageButton = Asset.plusIcon.image
        case .activeGoals, .activeGoalsAct:
            enabledButton = true
            titleButton = L10n.showAll
            imageButton = Asset.rightArrowIcon.image
            items = goals.compactMap { (goal) -> ActivityItemsViewModel in
                return .goal(goal: goal)
            }
        default:
            enabledButton = true
            titleButton = L10n.showAll
            imageButton = Asset.rightArrowIcon.image
        }
        
        items += content.compactMap { ActivityItemsViewModel.content(content: $0) }
        
        switch type {
        case .feel:
            imageIsHidden = false
            imageIcon = Asset.menuFeel.image
            titleText = "Feel Bold"
            subtitleText = "Rewire your mind"
        case .think:
            imageIsHidden = false
            imageIcon = Asset.menuThink.image
            titleText = "Think Bold"
            subtitleText = "Jump into other bold minds"
        case .actActive, .actNotActive:
            imageIsHidden = false
            imageIcon = Asset.menuAct.image
            titleText = "Act Bold"
            subtitleText = "Take a next step"
        case .activeGoals:
            imageIsHidden = false
            titleText = L10n.Act.activeGoals
            subtitleText = L10n.Act.youHaveActionWithStakes("\(itemCount)")
        case .activeGoalsAct:
            titleText = L10n.Act.activeGoals
            subtitleText = L10n.Act.youHaveActionWithStakes("\(itemCount)")
            imageIsHidden = true
        default:
            break
        }
        
        return ActivityViewModel(type: type, rowHeight: type.rowHeight(), bottomCellHeight: type.bottomCellHeight(), collectionCellSize: type.collectionCellSize(), image: imageIcon, imageIsHidden: imageIsHidden, title: titleText ?? "", subtitle: subtitleText ?? "", titleButton: titleButton, enabledButton: enabledButton, imageButton: imageButton, items: items)
    }
    
}

struct ContentViewModel {
    
    let backgroundImage: UIImage?
    let title: String
    
}

enum ActivityItemsViewModel {
    case content(content: ContentViewModel)
    case goal(goal: GoalCollectionViewModel)
}


private struct Constants {

    struct CellSize {
        static let feelAndThink = CGSize(width: 124, height: 172)
        static let actNotActive = CGSize(width: 225, height: 102)
        static let actActive = CGSize(width: 150, height: 181)
        static let activeGoals = CGSize(width: 160, height: 181)
        static let boldManifest = CGSize.zero
    }
    
    struct rowHeight {
        static let feelThinkActActiveActiveGoals:CGFloat = 310
        static let actNotActive:CGFloat = 260
        static let boldManifest:CGFloat = 106
    }
    
    struct bottomCellHeight {
        static let feelThinkActActiveActiveGoals:CGFloat = 30
        static let actNotActive:CGFloat = 51
        static let boldManifest:CGFloat = 0
    }
}

enum HomeActionsTypeCell {
    case feel
    case think
    case boldManifest
    case actNotActive
    case actActive
    case activeGoals
    case activeGoalsAct
    
    func rowHeight() -> CGFloat {
        switch self {
        case .feel, .think, .actActive, .activeGoals, .activeGoalsAct:
            return Constants.rowHeight.feelThinkActActiveActiveGoals
        case .actNotActive:
            return Constants.rowHeight.actNotActive
        case .boldManifest:
            return Constants.rowHeight.boldManifest
        }
    }
    
    func bottomCellHeight() -> CGFloat {
        switch self {
        case .feel, .think, .actActive, .activeGoals, .activeGoalsAct:
            return Constants.bottomCellHeight.feelThinkActActiveActiveGoals
        case .actNotActive:
            return Constants.bottomCellHeight.actNotActive
        case .boldManifest:
            return Constants.bottomCellHeight.boldManifest
        }
    }
    
    func collectionCellSize() -> CGSize {
        switch self {
        case .feel, .think:
            return Constants.CellSize.feelAndThink
        case .actNotActive:
            return Constants.CellSize.actNotActive
        case .actActive:
            return Constants.CellSize.actActive
        case .activeGoals, .activeGoalsAct:
            return Constants.CellSize.activeGoals
        case .boldManifest:
            return Constants.CellSize.boldManifest
        }
    }
    
}
