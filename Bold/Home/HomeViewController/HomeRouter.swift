//
//  HomeRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum HomeInputRouter {
    case menuShow
    case actionAll(HomeActionsTypeCell)
    case actionItem(FeelTypeCell)
    case unlockBoldManifest
    case createGoal
}

protocol HomeInputRouterProtocol: RouterProtocol {
    func input(_ inputCase: HomeInputRouter)
}

class HomeRouter: RouterProtocol, HomeInputRouterProtocol {

    typealias View = HomeViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: HomeInputRouter) {
        switch inputCase {
        case .menuShow:
            viewController.showSideMenu()
        case .actionAll(let type):
            let viewController: UIViewController?
            switch type {
            case .feel:
                viewController = StoryboardScene.Feel.storyboard.instantiateInitialViewController()
            case .think:
                viewController = StoryboardScene.Think.storyboard.instantiateInitialViewController()
            case .actActive:
                viewController = UIViewController()
            case .actNotActive:
                viewController = UIViewController()
            case .boldManifest:
                viewController = UIViewController()
            case .activeGoals, .activeGoalsAct:
                viewController = UIViewController()
                break
            }
            if let newVC = viewController {
                HostViewController.showController(newVC: newVC)
            }
        case .actionItem(let type):
            let actionListVC = StoryboardScene.Feel.actionsListViewController.instantiate()
            actionListVC.typeVC = type
            viewController.navigationController?.pushViewController(actionListVC, animated: true)
        case .unlockBoldManifest:
            viewController.performSegue(withIdentifier: StoryboardSegue.Home.manifestIdentifier.rawValue, sender: nil)
        case .createGoal:
            let createGoalVC = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(createGoalVC, animated: true)
        }
    }
}
