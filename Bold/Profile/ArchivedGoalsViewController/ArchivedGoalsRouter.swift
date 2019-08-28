//
//  ArchivedGoalsRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ArchivedGoalsRouterInput {
    case close
}

protocol ArchivedGoalsRouterInputProtocol: RouterProtocol {
    func input(_ inputCase: ArchivedGoalsRouterInput)
}

class ArchivedGoalsRouter: ArchivedGoalsRouterInputProtocol {
    
    typealias View = ArchivedGoalsViewController
    
    weak var viewController: ArchivedGoalsViewController!
    
    required init(viewController: ArchivedGoalsViewController) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ArchivedGoalsRouterInput) {
        switch inputCase {
        case .close:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
}
