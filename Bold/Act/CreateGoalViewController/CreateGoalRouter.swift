//
//  CreateGoalRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateGoalInputRouter {
    case ideasPresent(IdeasViewController)
    case cancel
    case presentDateAlert(DateAlertViewController)
}

protocol CreateGoalInputRouterProtocol {
    func input(_ inputCase: CreateGoalInputRouter)
}

class CreateGoalRouter: RouterProtocol, CreateGoalInputRouterProtocol {
    
    typealias View = CreateGoalViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CreateGoalInputRouter) {
        switch inputCase {
        case .ideasPresent(let ideasVC):
//            let ideasVC = StoryboardScene.Act.ideasViewController.instantiate()
//            ideasVC.delegate = viewController
//            ideasVC.selectIdea = selectIdea
            viewController.navigationController?.pushViewController(ideasVC, animated: true)
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        case .presentDateAlert(let alertVC):
            alertVC.presentedBy(viewController)
        }
    }
}
