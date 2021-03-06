//
//  CreateActionRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateActionInputRouter {
    case presentSetting(AddActionCellType)
    case stake
    case share
    case cancel
}

protocol CreateActionInputRouterProtocol {
    func input(_ inputCase: CreateActionInputRouter)
}

class CreateActionRouter: RouterProtocol, CreateActionInputRouterProtocol {
    
    typealias View = CreateActionViewController
    
    weak var viewController: View!
 
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CreateActionInputRouter) {
        switch inputCase {
        case .presentSetting(let type):
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.configurateActionIdentifier.rawValue, sender: type)
        case .stake:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.stakeIdentifier.rawValue, sender: nil)
        case .share:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.shareWithFriendsIdentifier.rawValue, sender: nil)
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}
