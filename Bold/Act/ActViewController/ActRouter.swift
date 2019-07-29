//
//  ActRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActInputRouter {
    case menuShow
    case calendar
    case tapPlus
    case allGoals
    case goalItem
    case longTapActionPresentedBy(StartActionViewController)
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
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.allGoallIdentifier.rawValue, sender: nil)
        case .tapPlus:
            print("tapPlus")
        case .allGoals:
            print("allGoals")
        case .goalItem:
            print("goalItem")
        case .longTapActionPresentedBy(let vc):
            vc.presentedBy(viewController)
        }
    }
}
