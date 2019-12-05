//
//  ActRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ActInputRouter {
    case menuShow
    case calendar
    case tapPlus
    case allGoals
    case goalItem(calendarVC: CalendarActionsListViewController)
    case longTapActionPresentedBy(StartActionViewController)
    case showEditEvent(vc: EditActionPlanViewController)
    case createGoal
}

protocol ActInputRouterProtocol {
    func input(_ inputCase: ActInputRouter)
}

class ActRouter: RouterProtocol, ActInputRouterProtocol {
    
    typealias View = ActViewController
    
    weak var viewController: ActViewController!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ActInputRouter) {
        switch inputCase {
        case .menuShow:
            viewController.showSideMenu()
        case .calendar:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.calendarFromActViewIdentifier.rawValue, sender: nil)
        case .tapPlus:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.createActionFromActViewIdentifier.rawValue, sender: nil)
        case .allGoals:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.allGoallIdentifier.rawValue, sender: nil)
        case .showEditEvent(vc: let editActionVC):
            editActionVC.presentedBy(viewController)
        case .goalItem(calendarVC: let calendarVC):
            viewController.navigationController?.pushViewController(calendarVC, animated: true)
        case .longTapActionPresentedBy(let vc):
            vc.presentedBy(viewController.navigationController!)
        case .createGoal:
            let vc = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
