//
//  HomeRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum HomeInputRouter {
    case menuShow
    case actionAll
    case actionItem
    case boldManifest
    case createGoal
}

protocol HomeInputRouterProtocol: RouterProtocol {
    func input(_ inputCase: HomeInputRouter)
}

class HomeRouter: RouterProtocol, HomeInputRouterProtocol {

    typealias View = HomeViewController
    
    var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: HomeInputRouter) {
        switch inputCase {
        case .menuShow: print("menu")
        case .actionAll: print("menu")
        case .actionItem: print("menu")
        case .boldManifest: print("menu")
        case .createGoal: print("menu")
        }
    }
}
