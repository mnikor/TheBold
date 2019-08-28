//
//  CalendarAndHistoryRouter.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarAndHistoryInputRouter {
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
        case .editAction(let editVC):
            editVC.presentedBy(viewController)
        case .yearMonthAlert(let dateAlert):
            dateAlert.presentedBy(viewController)
        }
    }
    
}
