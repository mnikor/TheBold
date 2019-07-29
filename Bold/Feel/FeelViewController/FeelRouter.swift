//
//  FeelRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum FeelInputRouter {
    case menuShow
    case showAll(FeelTypeCell)
    case showPlayer
}

protocol FeelInputRouterProtocol {
    func input(_ inputCase: FeelInputRouter)
}

class FeelRouter: RouterProtocol, FeelInputRouterProtocol {
    
    typealias View = FeelViewController
    
    weak var viewController: FeelViewController!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: FeelInputRouter) {
        
        switch inputCase {
        case .menuShow:
            viewController.showSideMenu()
        case .showAll(let typeCell):
            viewController.performSegue(withIdentifier: StoryboardSegue.Feel.showItem.rawValue, sender: typeCell)
        case .showPlayer:
            let player = PlayerViewController.createController()
            player.present(viewController)
        }
    }
}
