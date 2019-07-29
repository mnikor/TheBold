//
//  CalendarActionsListRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarActionsListInputRouter {
    case presentdCreateAction
    case editAction(EditActionPlanViewController)
}

protocol CalendarActionsListInputRouterProtocol {
    func input(_ inputCase: CalendarActionsListInputRouter)
}

class CalendarActionsListRouter: RouterProtocol, CalendarActionsListInputRouterProtocol {
    
    typealias View = CalendarActionsListViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CalendarActionsListInputRouter) {
        switch inputCase {
        case .presentdCreateAction:
            print("dsf")
        case .editAction(let editVC):
            editVC.presentedBy(viewController)
        }
    }
 
}
