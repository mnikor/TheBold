//
//  CalendarAndHistoryRouter.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarAndHistoryInputRouter {
    case presentdCreateAction
    case editAction(EditActionPlanViewController)
    case yearMonthAlert(YearMonthAlertViewController)
}

protocol CalendarAndHistoryInputRouterProtocol {
    func input(_ inputCase: CalendarAndHistoryInputRouter)
}

class CalendarAndHistoryRouter: RouterProtocol, CalendarAndHistoryInputRouterProtocol {
    
    typealias View = CalendarAndHistoryViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CalendarAndHistoryInputRouter) {
        switch inputCase {
        case .presentdCreateAction:
            let vc = StoryboardScene.Act.createActionViewController.instantiate()
            viewController.navigationController?.pushViewController(vc, animated: true)
        case .editAction(let editVC):
            editVC.presentedBy(viewController)
        case .yearMonthAlert(let dateAlert):
            dateAlert.presentedBy(viewController)
        }
    }
    
}
