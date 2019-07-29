//
//  HomeRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum HomeInputRouter {
    case menuShow
    case actionAll(FeelTypeCell)
    case actionItem
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
        case .actionAll:
            guard let feelVC = StoryboardScene.Feel.storyboard.instantiateInitialViewController() else { return }
            HostViewController.showController(newVC: feelVC)
        case .actionItem:
            let actionListVC = StoryboardScene.Feel.actionsListViewController.instantiate()
            viewController.navigationController?.pushViewController(actionListVC, animated: true)
        case .unlockBoldManifest:
            viewController.performSegue(withIdentifier: StoryboardSegue.Home.manifestIdentifier.rawValue, sender: nil)
        case .createGoal:
            let createGoalVC = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(createGoalVC, animated: true)
        }
    }
}
