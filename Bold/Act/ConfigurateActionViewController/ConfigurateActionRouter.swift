//
//  ConfigurateActionRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ConfigurateActionInputRouter {
    case cancel
    case presentSheet(DateAlertViewController)
}

protocol ConfigurateActionInputRouterProtocol {
    func input(_ inputCase: ConfigurateActionInputRouter)
}

class ConfigurateActionRouter: RouterProtocol, ConfigurateActionInputRouterProtocol {
    
    typealias View = ConfigurateActionViewController
    
    weak var viewController: ConfigurateActionViewController!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ConfigurateActionInputRouter) {
        
        switch inputCase {
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        case .presentSheet(let dateAlertVC):
            dateAlertVC.presentedBy(viewController)
        }
    }
}
