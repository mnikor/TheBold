//
//  IdeasRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum IdeasInputRouter {
    case back
    case cancel
}

protocol IdeasInputRouterProtocol {
    func input(_ inputCase: IdeasInputRouter)
}

class IdeasRouter: RouterProtocol, IdeasInputRouterProtocol {
    
    typealias View = IdeasViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: IdeasInputRouter) {
        switch inputCase {
        case .back:
            print("back")
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
