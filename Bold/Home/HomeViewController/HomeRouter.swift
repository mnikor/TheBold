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
    case showBoldManifest
    case createGoal
    case goalItem(Goal)
    case longTapGoalPresentedBy(EditGoalViewController)
    case showLevelOfMastery
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
            actionAll(type: type)
        case .actionItem(let type):
            let actionListVC = StoryboardScene.Feel.actionsListViewController.instantiate()
            actionListVC.typeVC = type
            viewController.navigationController?.pushViewController(actionListVC, animated: true)
        case .unlockBoldManifest:
            let vc = StoryboardScene.Settings.premiumViewController.instantiate()
            viewController.navigationController?.present(vc, animated: true, completion: nil)
        case .showBoldManifest:
            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
            vc.viewModel = DescriptionViewModel.boldManifestInfo
            viewController.navigationController?.present(vc, animated: true, completion: nil)
        case .createGoal:
            let createGoalVC = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(createGoalVC, animated: true)
        case .goalItem(let goal):
            let calendarVC = StoryboardScene.Act.calendarActionsListViewController.instantiate()
            calendarVC.presenter.goal = goal
            viewController.navigationController?.pushViewController(calendarVC, animated: true)
        case .longTapGoalPresentedBy(let vc):
            vc.presentedBy(viewController.navigationController!)
        case .showLevelOfMastery:
            let masteryVC = StoryboardScene.Profile.levelOfMasteryViewController.instantiate()
            viewController.navigationController?.pushViewController(masteryVC, animated: true)
        }
    }
    
    private func actionAll(type: HomeActionsTypeCell) {
        switch type {
        case .feel:
            let viewController = StoryboardScene.Feel.storyboard.instantiateInitialViewController()
            HostViewController.showController(newVC: viewController ?? UIViewController())
        case .think:
            let viewController = StoryboardScene.Think.storyboard.instantiateInitialViewController()
            HostViewController.showController(newVC: viewController ?? UIViewController())
        case .actActive, .actNotActive, .activeGoalsAct, .activeGoals:
            let viewController = StoryboardScene.Act.createGoalViewController.instantiate()
            self.viewController.navigationController?.pushViewController(viewController, animated: true)
        case .boldManifest, .unlockPremium:
            break
        }
    }
    
}
