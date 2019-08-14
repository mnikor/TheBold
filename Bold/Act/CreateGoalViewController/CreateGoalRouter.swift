//
//  CreateGoalRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateGoalInputRouter {
    case ideas
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
        case .ideas:
            print("dfsf")
            let ideasVC = StoryboardScene.Act.ideasViewController.instantiate()
            viewController.navigationController?.pushViewController(ideasVC, animated: true)
//            let dateVC = StoryboardScene.Act.dateAlertViewController.instantiate()
//            viewController.present(dateVC, animated: true, completion: nil)
            
//            let vc = DateAlertViewController.createController(type: .endDate, currentDate: nil) { (selectDate) in
//                print("selecDate = \(selectDate)")
//            }
//            vc.presentedBy(viewController)
            
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        case .presentDateAlert(let alertVC):
            alertVC.presentedBy(viewController)
        }
    }
}
