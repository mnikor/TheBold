//
//  BaseStakesListRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum BaseStakesListInputRouter {
    case presentdCreateAction(goalID: String?)
//    case editAction(EditActionPlanViewController)
    case yearMonthAlert(YearMonthAlertViewController)
    case allGoals
    case goalItem(calendarVC: CalendarActionsListViewController)
    case longTapActionPresentedBy(StartActionViewController)
    case longTapGoalPresentedBy(EditGoalViewController)
    case showEditEvent(vc: EditActionPlanViewController)
    case tapPlus
    case createGoal
}

protocol BaseStakesListInputRouterProtocol {
    func input(_ inputCase: BaseStakesListInputRouter)
    func showThankForPaymentController()
}

class BaseStakesListRouter: RouterProtocol, BaseStakesListInputRouterProtocol {
    
    typealias View = BaseStakesListViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: BaseStakesListInputRouter) {
        switch inputCase {
        
        case .presentdCreateAction(let goalID):
            let vc = StoryboardScene.Act.createActionViewController.instantiate()
            vc.presenter.goalID = goalID
            viewController.navigationController?.pushViewController(vc, animated: true)
//        case .editAction(let editVC):
//            editVC.presentedBy(viewController)
        case .yearMonthAlert(let dateAlert):
            dateAlert.presentedBy(viewController)
        
        case .allGoals:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.allGoallIdentifier.rawValue, sender: nil)
        case .goalItem(calendarVC: let calendarVC):
            viewController.navigationController?.pushViewController(calendarVC, animated: true)
        case .longTapActionPresentedBy(let vc):
            vc.presentedBy(viewController.navigationController!)
        case .longTapGoalPresentedBy(let vc):
            vc.presentedBy(viewController.navigationController!)
        case .showEditEvent(vc: let editActionVC):
            editActionVC.presentedBy(viewController)
        
        case .tapPlus:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.createActionFromActViewIdentifier.rawValue, sender: nil)
        case .createGoal:
            let vc = StoryboardScene.Act.createGoalViewController.instantiate()
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showThankForPaymentController() {
        let vc = StoryboardScene.Settings.thanksForPaymentViewController.instantiate()
        viewController.present(vc, animated: true, completion: nil)
    }
 
}
