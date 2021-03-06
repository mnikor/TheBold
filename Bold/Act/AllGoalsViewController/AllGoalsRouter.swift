//
//  AllGoalsRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum AllGoalsInputRouter {
    case addGoal
    case selectGoal(GoalEntity)
}

protocol AllGoalsInputRouterProtocol {
    func input(_ inputCase: AllGoalsInputRouter)
}

class AllGoalsRouter: RouterProtocol, AllGoalsInputRouterProtocol {
    
    typealias View = AllGoalsViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: AllGoalsInputRouter) {
        switch inputCase {
        case .addGoal:
            let vc = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(vc, animated: true)
        case .selectGoal(let selectGoal):
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.calendarListIdentifier.rawValue, sender: selectGoal)
        }
    }
    
}
