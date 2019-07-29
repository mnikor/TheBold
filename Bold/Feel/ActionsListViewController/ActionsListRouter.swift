//
//  ActionsListRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ActionsListInputRouter {
    case back
    case info
    case presentedBy(AddActionPlanViewController)
}

protocol ActionsListRouterProtocol {
    func input(_ inputCase: ActionsListInputRouter)
}

class ActionsListRouter: RouterProtocol, ActionsListRouterProtocol {
    
    typealias View = ActionsListViewController
    
    weak var viewController: ActionsListViewController!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ActionsListInputRouter) {
        switch inputCase {
        case .back:
            viewController.navigationController?.popViewController(animated: true)
        case .info:
            print("info")
        case .presentedBy(let vController):
            vController.presentedBy(viewController)
        }
    }
    
    
    
    
}
